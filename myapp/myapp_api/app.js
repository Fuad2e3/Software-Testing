const express = require('express');
const cors = require('cors');
const connectDB = async () => { /* Mock connection if mongoose not installed */ console.log("DB connected (mock)"); };
const authRoutes = require('./routes/auth');
require('dotenv').config();

const app = express();

// Connect to Database (Optional: uncomment if using mongodb)
// const connectDB = require('./config/db');
// connectDB();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
