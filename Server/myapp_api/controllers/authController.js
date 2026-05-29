const mysql = require('mysql2');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'myapp_db'
});

db.connect((err) => {
  if(err) console.log('DB Error:', err.message);
  else console.log('DB Connected!');
});

// REGISTER
exports.register = (req, res) => {
  const { name, email, password } = req.body;
  console.log('Register attempt:', email);

  bcrypt.hash(password, 10, (err, hashed) => {
    if(err) return res.status(500).json({ success: false, message: err.message });

    db.query(
      'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
      [name, email, hashed],
      (err, result) => {
        if(err) {
          console.log('Insert Error:', err.message);
          return res.status(500).json({ success: false, message: err.message });
        }
        console.log('User saved! ID:', result.insertId);
        res.json({ success: true, message: 'Registration successful!' });
      }
    );
  });
};

// LOGIN
exports.login = (req, res) => {
  const { email, password } = req.body;
  console.log('Login attempt:', email);

  db.query('SELECT * FROM users WHERE email = ?', [email], (err, rows) => {
    if(err) return res.status(500).json({ success: false, message: err.message });
    if(rows.length === 0) return res.status(404).json({ message: 'User not found!' });

    bcrypt.compare(password, rows[0].password, (err, valid) => {
      if(!valid) return res.status(401).json({ message: 'Wrong password!' });

      const token = jwt.sign(
        { id: rows[0].id },
        process.env.JWT_SECRET,
        { expiresIn: '7d' }
      );

      console.log('Login success:', email);
      res.json({
        success: true,
        token: token,
        user: { id: rows[0].id, name: rows[0].name, email: rows[0].email }
      });
    });
  });
};
