const mysql = require('mysql2');
require('dotenv').config();

const db = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'myapp_db'
});

db.connect((err) => {
  if (err) {
    console.error('DB Connection Error:', err.message);
  } else {
    console.log('DB Connected...');
  }
});

module.exports = db;
