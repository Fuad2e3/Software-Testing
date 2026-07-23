const db = require('../config/db');

// Add a new company
exports.addCompany = (req, res) => {
  const { user_id, company_name, website, email, contact } = req.body;

  if (!user_id || !company_name) {
    return res.status(400).json({ success: false, message: 'User ID and Company Name are required!' });
  }

  const query = 'INSERT INTO companies (user_id, company_name, website, email, contact) VALUES (?, ?, ?, ?, ?)';
  db.query(query, [user_id, company_name, website, email, contact], (err, result) => {
    if (err) {
      console.error('Insert Company Error:', err.message);
      return res.status(500).json({ success: false, message: 'Failed to add company.' });
    }
    res.json({ success: true, message: 'Company added successfully!', companyId: result.insertId });
  });
};

// Get all companies for a user
exports.getCompanies = (req, res) => {
  const { userId } = req.params;

  const query = 'SELECT * FROM companies WHERE user_id = ? ORDER BY created_at DESC';
  db.query(query, [userId], (err, rows) => {
    if (err) {
      console.error('Fetch Companies Error:', err.message);
      return res.status(500).json({ success: false, message: 'Failed to fetch companies.' });
    }
    res.json({ success: true, companies: rows });
  });
};

// Delete a company
exports.deleteCompany = (req, res) => {
  const { id } = req.params;

  const query = 'DELETE FROM companies WHERE id = ?';
  db.query(query, [id], (err, result) => {
    if (err) {
      console.error('Delete Company Error:', err.message);
      return res.status(500).json({ success: false, message: 'Failed to delete company.' });
    }
    res.json({ success: true, message: 'Company deleted successfully!' });
  });
};
