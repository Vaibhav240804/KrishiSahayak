import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import numpy as np
import pickle
from pydantic import BaseModel

class Item(BaseModel):
    N: float
    P: float
    K: float
    temperature: float
    humidity: float
    ph: float
    rainfall: float

app = FastAPI()

# Add CORS middleware to allow all origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # You can specify specific origins if needed
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

pickle_in = open("Crop_Recommendation_KNN.pkl", "rb")
classifier = pickle.load(pickle_in)

mapper = {
    0: "Apple",
    1: "Banana",
    2: "Blackgram",
    3: "Chickpea",
    4: "Coconut",
    5: "Coffee",
    6: "Cotton",
    7: "Grapes",
    8: "Jute",
    9: "Kidneybeans",
    10: "Lentil",
    11: "Maize",
    12: "Mango",
    13: "Mothbeans",
    14: "Mungbean",
    15: "Muskmelon",
    16: "Orange",
    17: "Papaya",
    18: "Pigeonpeas",
    19: "Pomegranate",
    20: "Rice",
    21: "Watermelon"
}

@app.post('/predict')
def predict(data: Item):
    data = data.dict()
    N, P, K, temperature, humidity, ph, rainfall = (
        data['N'],
        data['P'],
        data['K'],
        data['temperature'],
        data['humidity'],
        data['ph'],
        data['rainfall'],
    )
    prediction = classifier.predict([[N, P, K, temperature, humidity, ph, rainfall]])
    return {'prediction': mapper[prediction[0]]}

if __name__ == '__main__':
    uvicorn.run(app, host='127.0.0.1', port=8000)
