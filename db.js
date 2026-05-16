const mysql = require('mysql2/promise');

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '24AAN328.y',
    database: 'flyticket_db'
});

module.exports = pool;