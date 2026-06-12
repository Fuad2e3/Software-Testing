# 🌱 AI-Powered Smart Gardening Ecosystem

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android-brightgreen?style=for-the-badge&logo=android" alt="Platform">
  <img src="https://img.shields.io/badge/Language-Java-orange?style=for-the-badge&logo=java" alt="Language">
  <img src="https://img.shields.io/badge/Backend-Firebase-yellow?style=for-the-badge&logo=firebase" alt="Backend">
  <img src="https://img.shields.io/badge/AI-Gemini-blueviolet?style=for-the-badge&logo=google-gemini" alt="AI">
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License">
</p>

Empowering gardeners with cutting-edge AI, a thriving marketplace, and a global community. This project provides a comprehensive solution for smart garden management, featuring secure authentication and AI-driven insights.

---

## 🚀 Features

- **🔐 Secure Authentication**: Robust registration and login system.
- **🛡️ Brute Force Protection**: Advanced rate-limiting and auto-ban logic to prevent unauthorized access.
- **🤖 AI Insights**: (Planned) Integration with Google Gemini for personalized gardening advice.
- **🏪 Marketplace**: (Planned) A platform for gardeners to trade and share resources.
- **🌍 Global Community**: (Planned) Connect with other gardening enthusiasts.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Node.js, Express.js
- **Database**: MySQL
- **AI**: Google Gemini (Planned)
- **Security**: JWT, Bcrypt, Rate Limiting

---

## 📁 Project Structure

```bash
.
├── backend/            # Node.js Express API
│   ├── config/         # Database and server configurations
│   ├── controllers/    # Business logic for routes
│   ├── routes/         # API endpoint definitions
│   └── app.js          # Main entry point
├── frontend/           # Flutter Mobile Application
│   ├── lib/            # App source code
│   ├── android/        # Android specific files
│   └── pubspec.yaml    # Flutter dependencies
└── LICENSE             # MIT License
```

---

## ⚙️ Getting Started

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Configure your environment variables in `.env`:
   ```env
   PORT=3000
   DB_HOST=localhost
   DB_USER=root
   DB_PASS=yourpassword
   DB_NAME=gardening_db
   ```
4. Start the server:
   ```bash
   npm start
   ```

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="center">
  Developed with ❤️ by <b>Team Softece</b><br>
  <i>Software Testing Project | Green University of Bangladesh</i>
</p>
