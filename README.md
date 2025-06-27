# 🌿 AgroNova

**AgroNova** is a smart assistant application designed to support farmers in diagnosing crop and animal diseases, and providing helpful recommendations. It combines a **Flutter mobile app** frontend with a **FastAPI backend** powered by **machine learning** and **LLM (Language Model) capabilities**.

---

## 🧩 Project Structure

agronova_project/
├── fastapi_backend/ → FastAPI backend for disease prediction and chatbot
├── flutter_app/ → Mobile app interface for farmers
├── requirements.txt → Python backend dependencies
├── .gitignore → Ignored files for version control
└── README.md → Project overview (this file)


---

## 🚀 Features

- 📱 **Mobile App**: Built with Flutter for an intuitive farmer interface.
- 🧠 **Disease Detection**: Uses CNN-based machine learning models to detect crop and animal diseases from images.
- 💬 **Chatbot Assistant**: Powered by LangChain and Groq to answer agricultural questions.
- 🔐 **Secure Configuration**: Sensitive data stored in `.env` files.
- 📦 **Monorepo Architecture**: Combines frontend and backend for simpler management and deployment.

---

## 🛠️ Tech Stack

- **Flutter** – Mobile frontend
- **FastAPI** – Backend API server
- **Python** – Backend language
- **LangChain + Groq** – LLM-powered chatbot
- **TensorFlow** – For ML models
- **dotenv** – For environment configuration

---

## 🧪 Setup Instructions

### 1. Clone the repo
```bash
git clone https://github.com/your-username/agronova_project.git
cd agronova_project
