const express = require('express');
const pool = require('./db');
const crypto = require('crypto');

const app = express();
const port = 3000;

app.use(express.json());
app.use(express.static('public'));

// --- CUSTOMER ROUTES ---
app.get('/cities', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM City');
        res.json(rows);
    } catch (error) { res.status(500).json({ error: error.message }); }
});

app.get('/flights', async (req, res) => {
    const { from, to, date } = req.query;
    try {
        let query = `
            SELECT f.flight_id, f.from_city, f.to_city, c1.city_name AS from_city_name, c2.city_name AS to_city_name,
                   f.departure_time, f.arrival_time, f.price, f.seats_total, f.seats_available
            FROM Flight f
            JOIN City c1 ON f.from_city = c1.city_id
            JOIN City c2 ON f.to_city = c2.city_id WHERE 1=1
        `;
        const params = [];
        if (from) { query += " AND f.from_city = ?"; params.push(from); }
        if (to) { query += " AND f.to_city = ?"; params.push(to); }
        if (date) { query += " AND DATE(f.departure_time) = ?"; params.push(date); }

        const [rows] = await pool.query(query, params);
        res.json(rows);
    } catch (error) { res.status(500).json({ error: error.message }); }
});

app.post('/tickets', async (req, res) => {
    const { passenger_name, passenger_surname, passenger_email, flight_id } = req.body;
    const ticket_id = 'TKT-' + Math.floor(10000 + Math.random() * 90000);
    
    const rowsList = ['A', 'B', 'C', 'D', 'E', 'F'];
    const randomRow = rowsList[Math.floor(Math.random() * rowsList.length)];
    const randomNum = Math.floor(Math.random() * 30) + 1;
    const seat_number = `${randomNum}${randomRow}`;

    try {
        const [flight] = await pool.query('SELECT seats_available FROM Flight WHERE flight_id = ?', [flight_id]);
        if (flight.length === 0) return res.status(404).json({ error: 'Flight not found.' });
        if (flight[0].seats_available <= 0) return res.status(400).json({ error: 'No seats available.' });

        await pool.query(`INSERT INTO Ticket (ticket_id, passenger_name, passenger_surname, passenger_email, flight_id, seat_number) VALUES (?, ?, ?, ?, ?, ?)`,
            [ticket_id, passenger_name, passenger_surname, passenger_email, flight_id, seat_number]);
        await pool.query('UPDATE Flight SET seats_available = seats_available - 1 WHERE flight_id = ?', [flight_id]);

        res.status(201).json({ message: 'Ticket successfully booked!', ticket_id, seat_number });
    } catch (error) { res.status(500).json({ error: error.message }); }
});

// --- ADMIN ROUTES ---
app.post('/admin/login', async (req, res) => {
    const { username, password } = req.body;
    try {
        const hashedPassword = crypto.createHash('sha256').update(password).digest('hex');
        const [admin] = await pool.query('SELECT * FROM Admin WHERE username = ? AND password = ?', [username, hashedPassword]);
        if (admin.length > 0) res.json({ success: true });
        else res.status(401).json({ error: 'Invalid credentials!' });
    } catch (error) { res.status(500).json({ error: error.message }); }
});

app.get('/admin/tickets', async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT t.ticket_id, t.passenger_name, t.passenger_surname, t.passenger_email, f.flight_id, t.seat_number 
            FROM Ticket t JOIN Flight f ON t.flight_id = f.flight_id
        `);
        res.json(rows);
    } catch (error) { res.status(500).json({ error: error.message }); }
});

app.delete('/admin/flights/:id', async (req, res) => {
    const flight_id = req.params.id;
    try {
        await pool.query('DELETE FROM Ticket WHERE flight_id = ?', [flight_id]);
        await pool.query('DELETE FROM Flight WHERE flight_id = ?', [flight_id]);
        res.json({ message: 'Flight successfully deleted.' });
    } catch (error) { res.status(500).json({ error: error.message }); }
});

app.put('/admin/flights/:id', async (req, res) => {
    const flight_id = req.params.id;
    const { from_city, to_city, departure_time, arrival_time, price, seats_total } = req.body;

    if (from_city == to_city) {
        return res.status(400).json({ error: 'Origin and destination cities cannot be the same.' });
    }

    try {
        const [tickets] = await pool.query('SELECT COUNT(*) as sold FROM Ticket WHERE flight_id = ?', [flight_id]);
        const sold = tickets[0].sold;
        const seats_available = seats_total - sold;

        if (seats_available < 0) {
            return res.status(400).json({ error: 'Total seats cannot be less than already sold tickets.' });
        }

        await pool.query(
            `UPDATE Flight SET from_city = ?, to_city = ?, departure_time = ?, arrival_time = ?, price = ?, seats_total = ?, seats_available = ? WHERE flight_id = ?`,
            [from_city, to_city, departure_time, arrival_time, price, seats_total, seats_available, flight_id]
        );

        res.json({ message: 'Flight successfully updated.' });
    } catch (error) { res.status(500).json({ error: error.message }); }
});

app.post('/flights', async (req, res) => {
    const { flight_id, from_city, to_city, departure_time, arrival_time, price, seats_total } = req.body;
    
    if (from_city == to_city) return res.status(400).json({ error: 'Origin and destination cities cannot be the same.' });

    const now = new Date();
    if (new Date(departure_time) < now) return res.status(400).json({ error: 'Departure time cannot be in the past.' });
    if (new Date(arrival_time) <= new Date(departure_time)) return res.status(400).json({ error: 'Arrival time must be after departure time.' });

    try {
        const [depConflict] = await pool.query(`SELECT * FROM Flight WHERE from_city = ? AND DATE_FORMAT(departure_time, '%Y-%m-%d %H') = DATE_FORMAT(?, '%Y-%m-%d %H')`, [from_city, departure_time]);
        if (depConflict.length > 0) return res.status(400).json({ error: 'No two flights from the same city can depart at the same hour.' });

        const [arrConflict] = await pool.query(`SELECT * FROM Flight WHERE to_city = ? AND arrival_time = ?`, [to_city, arrival_time]);
        if (arrConflict.length > 0) return res.status(400).json({ error: 'No two flights can arrive at the same city at the same arrival time.' });

        await pool.query(`INSERT INTO Flight (flight_id, from_city, to_city, departure_time, arrival_time, price, seats_total, seats_available) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
            [flight_id, from_city, to_city, departure_time, arrival_time, price, seats_total, seats_total]);
        res.status(201).json({ message: 'Flight created!' });
    } catch (error) { res.status(500).json({ error: error.message }); }
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});