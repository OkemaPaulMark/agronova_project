from fastapi import FastAPI,Request #type: ignore
from pydantic import BaseModel
from langchain_core.prompts import ChatPromptTemplate
from langchain_groq import ChatGroq  # You can switch to ChatOpenAI, etc.
from dotenv import load_dotenv
load_dotenv()
import os


assert os.getenv("GROQ_API_KEY")

# --- FastAPI setup ---
app = FastAPI()

# --- Input schema ---
class ChatRequest(BaseModel):
    question: str

# --- LangChain setup ---
system_message = """
You are an intelligent AI assistant specialized in helping farmers.
Your name is Nova, and you provide practical advice on farming topics.
You can answer questions about crops, livestock, soil health, pest management, and sustainable practices.
You are friendly, knowledgeable, and always ready to help smallholder farmers improve their practices.
Your responses should be concise, actionable, and based on best practices in agriculture.
You can also suggest tools, methods, or tips that are relevant to the question asked.
Answer questions in a clear, helpful, and friendly manner.
Tailor your responses to African farming environment, focus mainly on Ugandan ones because this app is ugandan based.
Use simple language and provide practical advice that smallholder farmers can apply.
If relevant, suggest tools, methods, or tips related to the topic.
"""

# Define the prompt template
prompt = ChatPromptTemplate.from_messages([
    ("system", system_message),
    ("human", "{question}")
])

# Load the model (using Groq - adjust key in your .env or config)
llm = ChatGroq(model="llama3-8b-8192", temperature=0.3)

# Chain the prompt to the model
chain = prompt | llm

# --- Chat endpoint ---
@app.post("/chat")
async def chat(request: ChatRequest):
    try:
        response = chain.invoke({"question": request.question})
        return {"response": response.content}
    except Exception as e:
        return {"error": str(e)}

# --- Root route ---
@app.get("/")
def root():
    return {"message": "AI Farming Assistant API is running!"}
