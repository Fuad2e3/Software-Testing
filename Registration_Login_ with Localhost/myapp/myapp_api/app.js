const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middleware 
app.use(cors()); // Simplified CORS to allow everything during testing

// Memory optimize 
app.use(express.json({ limit: '1mb' }));

// 🛡️ Enhanced Brute Force Protection
const db = require('./config/db'); // Database required for auto-ban
const loginAttempts = new Map();
const loginLimiter = (req, res, next) => {
  const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress || req.ip;
  const email = req.body.email;
  const now = Date.now();
  const limit = 5;
  const windowMs = 30 * 1000; // Reduced to 30 seconds

  console.log(`\n--- [RateLimit Check] --- IP: ${ip} | Email: ${email}`);

  if (!loginAttempts.has(ip)) {
    loginAttempts.set(ip, { count: 1, lastAttempt: now });
    return next();
  }

  const data = loginAttempts.get(ip);

  // Reset if window expired
  if (now - data.lastAttempt > windowMs) {
    data.count = 1;
    data.lastAttempt = now;
    return next();
  }

  data.count++;
  data.lastAttempt = now;

  if (data.count > limit) {
    const retryAfter = Math.ceil((windowMs - (now - data.lastAttempt)) / 1000);

    // Auto-Ban Logic on Violation
    if (email) {
      db.query('SELECT rate_limit_violations FROM users WHERE email = ?', [email], (err, rows) => {
        if (!err && rows.length > 0) {
          const newViolations = rows[0].rate_limit_violations + 1;

          if (newViolations >= 2) {
            db.query("UPDATE users SET status = 'banned', rate_limit_violations = ? WHERE email = ?", [newViolations, email], (err) => {
              if (err) console.error('DB Update Error (Banning):', err.message);
              else console.log(`User ${email} BANNED due to repeated violations.`);
            });
          } else {
            db.query('UPDATE users SET rate_limit_violations = ? WHERE email = ?', [newViolations, email], (err) => {
              if (err) console.error('DB Update Error (Violation):', err.message);
              else console.log(`User ${email} violation count increased to ${newViolations}.`);
            });
          }
        }
      });
    }

    return res.status(429).json({
      success: false,
      message: `Too many attempts. Please try again in ${retryAfter || 30} seconds.`,
      retryAfter: retryAfter || 30
    });
  }

  next();
};


// Routes
app.use('/api/auth', loginLimiter, require('./routes/auth'));

// Test
app.get('/', (req, res) => {
  res.json({ message: 'API is running!' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
