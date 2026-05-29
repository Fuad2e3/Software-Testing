// Note: This is a mock implementation as models weren't specified in the structure.
// In a real app, you would use a User model.

const jwt = require('jsonwebtoken');

// Mock User Data for demonstration
const users = [];

exports.register = async (req, res) => {
  const { name, email, password } = req.body;
  try {
    // Basic validation
    if (!name || !email || !password) {
      return res.status(400).json({ success: false, message: 'Please enter all fields' });
    }

    // Check if user already exists
    if (users.find(u => u.email === email)) {
      return res.status(400).json({ success: false, message: 'User already exists' });
    }

    // Create user
    const newUser = { id: users.length + 1, name, email, password };
    users.push(newUser);

    res.status(201).json({ success: true, message: 'User registered successfully' });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Server Error' });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = users.find(u => u.email === email && u.password === password);

    if (!user) {
      return res.status(400).json({ success: false, message: 'Invalid credentials' });
    }

    // Generate Token
    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({ success: true, token, user: { id: user.id, name: user.name, email: user.email } });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Server Error' });
  }
};
