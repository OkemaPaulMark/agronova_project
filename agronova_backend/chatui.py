import streamlit as st
import requests

st.set_page_config(page_title="AI Farming Assistant", page_icon="🌾")
st.title("🌿 AI Farming Assistant")

st.markdown("Ask me anything about farming, crops, livestock, soil, pests, etc.")

# Backend API URL
API_URL = "http://127.0.0.1:8000/chat"  # Change to LAN IP for mobile testing

# Session state for conversation history
if "messages" not in st.session_state:
    st.session_state.messages = []

# Show chat history
for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.markdown(msg["content"])

# Handle new user input
if question := st.chat_input("Type your question..."):
    st.session_state.messages.append({"role": "user", "content": question})

    with st.chat_message("user"):
        st.markdown(question)

    with st.chat_message("assistant"):
        with st.spinner("Thinking..."):
            try:
                res = requests.post(API_URL, json={"question": question})
                data = res.json()
                answer = data.get("response", "Sorry, I couldn't get a reply.")
            except Exception as e:
                answer = f"❌ Error: {str(e)}"
        st.markdown(answer)

    st.session_state.messages.append({"role": "assistant", "content": answer})
