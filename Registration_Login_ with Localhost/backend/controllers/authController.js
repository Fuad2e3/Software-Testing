const db = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// start register function
// Controller for user registration. Validates input, hashes the password using bcrypt, and inserts the new user into the database.
exports.register = (req, res) => {
  const { name, email, password } = req.body;
  console.log('Register attempt:', email);

  // Basic validation
  if (!name || !email || !password) {
    return res.status(400).json({ success: false, message: 'All fields are required!' });
  }

  if (password.length < 6) {
    return res.status(400).json({ success: false, message: 'Password must be at least 6 characters!' });
  }

  bcrypt.hash(password, 10, (err, hashed) => {
    if (err) {
      console.error('Bcrypt Hash Error:', err.message);
      return res.status(500).json({ success: false, message: 'Internal server error' });
    }

    db.query(
      'INSERT INTO users (name, email, password, status, rate_limit_violations) VALUES (?, ?, ?, ?, ?)',
      [name, email, hashed, 'active', 0],
      (err, result) => {
        if (err) {
          console.error('Insert Error:', err.message);
          return res.status(500).json({ success: false, message: 'Registration failed! Email might already exist.' });
        }
        console.log('User saved! ID:', result.insertId);
        res.json({ success: true, message: 'Registration successful!' });
      }
    );
  });
};
// end register function

// start login function
// Controller for user login. Validates credentials, checks account status (active, inactive, or banned), handles 30-day inactivity, compares password hashes, and generates a JWT token on success.
exports.login = (req, res) => {
  const { email, password } = req.body;
  console.log('Login attempt:', email);

  if (!email || !password) {
    return res.status(400).json({ success: false, message: 'Email and password are required!' });
  }

  db.query('SELECT * FROM users WHERE email = ?', [email], (err, rows) => {
    if (err) {
      console.error('Database Select Error:', err.message);
      return res.status(500).json({ success: false, message: 'Internal server error' });
    }

    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: 'User not found!' });
    }

    const user = rows[0];

    // Check for 30-day inactivity (Auto-Inactive)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    if (user.last_login && new Date(user.last_login) < thirtyDaysAgo && user.status === 'active') {
      db.query("UPDATE users SET status = 'inactive' WHERE id = ?", [user.id], (err) => {
        if (err) console.error('DB Update Error (Inactivity):', err.message);
      });
      user.status = 'inactive'; // Update local object for check below
      console.log(`User ${user.email} set to INACTIVE due to 30-day inactivity.`);
    }

    // Check Account Status
    if (user.status === 'banned') {
      return res.status(403).json({ success: false, message: 'Your account has been banned!' });
    }

    if (user.status === 'inactive') {
      return res.status(403).json({ success: false, message: 'Your account is inactive!' });
    }

    bcrypt.compare(password, user.password, (err, valid) => {
      if (err) {
        console.error('Bcrypt Compare Error:', err.message);
        return res.status(500).json({ success: false, message: 'Internal server error' });
      }

      if (!valid) {
        return res.status(401).json({ success: false, message: 'Wrong password!' });
      }

      // Update Last Login and reset violations
      db.query('UPDATE users SET last_login = NOW(), rate_limit_violations = 0 WHERE id = ?', [user.id], (err) => {
        if (err) console.error('DB Update Error (Login Success):', err.message);
      });

      const token = jwt.sign(
        { id: rows[0].id },
        process.env.JWT_SECRET || 'fallback_secret',
        { expiresIn: '7d' }
      );

      console.log('Login success:', email);
      res.json({
        success: true,
        token: token,
        user: { id: user.id, name: user.name, email: user.email, status: user.status }
      });
    });
  });
};
// end login function
