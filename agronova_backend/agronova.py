from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from langchain_core.prompts import ChatPromptTemplate
from langchain_groq import ChatGroq
from dotenv import load_dotenv
import os
# import tensorflow as tf
import io

# --- Load environment variables ---
load_dotenv()
assert os.getenv("GROQ_API_KEY")

# --- FastAPI app setup ---
app = FastAPI()

# --- CORS (so Flutter can call FastAPI endpoint) ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change to your Flutter app domain in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# remove them 
# # --- Load TensorFlow Model (.h5 or SavedModel) ---
# MODEL_PATH = "trained_cnn_model.h5"  # or change to folder path for SavedModel
# model = tf.keras.models.load_model(MODEL_PATH)

# # --- Class labels (adjust based on your model output order) ---
# class_labels = ["Healthy", "Leaf Blight", "Rust"]


# --- Predict Endpoint ---
# @app.post("/predict")
# async def predict(file: UploadFile = File(...)):
#     try:
#         # Step 1: Read and decode the image
#         contents = await file.read()
#         image = Image.open(io.BytesIO(contents)).convert("RGB")

#         # Step 2: Resize and normalize image
#         image = image.resize((256, 256))  # Match your model's expected input size
#         image_array = np.array(image) / 255.0  # Normalize pixels to 0–1
#         image_array = np.expand_dims(image_array, axis=0)  # Shape: (1, 256, 256, 3)

#         # Step 3: Run inference
#         predictions = model.predict(image_array)[0]
#         max_index = int(np.argmax(predictions))
#         predicted_class = class_labels[max_index]
#         confidence = float(predictions[max_index]) * 100  # Optional: convert to %

#         return {
#             "class": predicted_class,
#             "confidence": confidence,
#             "advice": get_advice(predicted_class)
#         }

#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")


# def get_advice(label: str) -> str:
#     if label == "Leaf Blight":
#         return "Apply fungicide and remove infected leaves."
#     elif label == "Rust":
#         return "Use rust-resistant varieties and rotate crops."
#     elif label == "Healthy":
#         return "No issues detected. Continue regular monitoring."
#     else:
#         return "No specific advice available for this result."
# --- Chatbot setup ---
class ChatRequest(BaseModel):
    question: str

system_message = """
You are an intelligent AI assistant specialized in helping farmers.
Your name is Nova, and you provide practical advice on farming topics.
... (shortened for brevity)
"""

prompt = ChatPromptTemplate.from_messages([
    ("system", system_message),
    ("human", "{question}")
])
llm = ChatGroq(model="llama-3.1-8b-instant", temperature=0.3)
chain = prompt | llm

@app.post("/chat")
async def chat(request: ChatRequest):
    try:
        response = chain.invoke({"question": request.question})
        return {"response": response.content}
    except Exception as e:
        return {"error": str(e)}

@app.get("/")
def root():
    return {"message": "AI Farming Assistant API is running!"}
