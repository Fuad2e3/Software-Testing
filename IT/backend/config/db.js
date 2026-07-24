const mysql = require('mysql2');
require('dotenv').config();

const db = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'myapp_db'
});

// start connect function
// Establishes a connection to the MySQL database using configurations from environment variables.
db.connect((err) => {
  if (err) {
    console.error('DB Connection Error:', err.message);
  } else {
    console.log('DB Connected...');

    // Initialize tables
    const createCompaniesTable = `
      CREATE TABLE IF NOT EXISTS companies (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        company_name VARCHAR(255) NOT NULL,
        website VARCHAR(255),
        email VARCHAR(255),
        email_source VARCHAR(500),
        contact VARCHAR(20),
        contact_source VARCHAR(500),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    `;
    db.query(createCompaniesTable, (err) => {
      if (err) console.error('Error creating companies table:', err.message);
      else {
        console.log('Companies table ready.');
        // Ensure new source columns exist for existing tables
        const addEmailSource = "ALTER TABLE companies ADD COLUMN IF NOT EXISTS email_source VARCHAR(500) AFTER email";
        const addContactSource = "ALTER TABLE companies ADD COLUMN IF NOT EXISTS contact_source VARCHAR(500) AFTER contact";

        db.query(addEmailSource, (err) => {
           if (err) {} // Ignore if exists
        });
        db.query(addContactSource, (err) => {
           if (err) {} // Ignore if exists
        });
      }
    });
  }
});
// end connect function

module.exports = db;
