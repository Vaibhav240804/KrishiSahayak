from langchain.schema import HumanMessage, SystemMessage, AIMessage
from langchain_community.chat_models.huggingface import ChatHuggingFace
from langchain_community.llms import HuggingFaceHub
from langchain.prompts import PromptTemplate
# from flask import Flask, jsonify, request
from translate import Translator
import uvicorn
from fastapi import FastAPI, Form, Request, requests
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from requests import request
import numpy as np
import pickle
from pydantic import BaseModel
from dotenv import load_dotenv, get_key
load_dotenv()
import os

session = {}

os.environ["HUGGINGFACEHUB_API_TOKEN"] = get_key(key_to_get="HUGGINGFACEHUB_API_KEY",dotenv_path=".env")

class Item(BaseModel):
    N: float
    P: float
    K: float
    temperature: float
    humidity: float
    ph: float
    rainfall: float

class chatItem(BaseModel):
    txt: str
    location: str
    curr_weather: str
    weather_forecast: str
    crop_name: str
    soil_analysis: str
    lang: str

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

pickle_in = open("./Crop_Recommendation_KNN.pkl", "rb")
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

llm = HuggingFaceHub(
    # repo_id="meta-llama/Meta-Llama-3-8B",
    repo_id="mistralai/Mistral-7B-Instruct-v0.2",
    task="text-generation",
    model_kwargs={
        "max_new_tokens": 512,
        "top_k": 30,
        "temperature": 0.1,
        "repetition_penalty": 1.03,
    },
)



def chatwithbot(txt:str, location:str="India", curr_weather:str="sunny", weather_forecast:str="rainy", crop_name:str="rice", soil_analysis:str="N: 90, P: 42, K: 43, temperature: 30, humidity: 80, ph: 6, rainfall: 200", lang:str="hi"):
    prompt = PromptTemplate(template= "you are farming assistant which understands local needs and challenges faced by Indian farmer,Indian farmer who possess generational knowledge(like tilling, sowing, weed management, etc,So you must to put on details on fertilizers, homemade remedies or using herbs etc wherver you seem to be neccessary) and asking you his concerns, in layman terms AND STRICTLY RESPOND IN LANGUAGE OF LANG. CODE: {lang} (NO OTHER LANGUAGE IS TOLLERATED), so that farmer can understand and don't stress out too much on vocabulary, give very short introduction and farmer wants solution not your gibberish so speak to the point directly. Respond within 6 lines. Points to foucus on: Use metrics in Indian standards, Tell solutions in local context ( like considering city or villege wide scope), following are details of crop and soil from farmer--> \t Location: {location}, current weather:{curr_weather}, future weather forecast of next week:{weather_forecast}, Crop:{crop_name}, soil analysis detail(ignore if values lookes like outliars and respond on previous provided information):{soil_analysis}",input_variables=["location","curr_weather","weather_forecast","crop_name","soil_analysis","lang"])

    chat_model = ChatHuggingFace(llm=llm)
    final_prompt = prompt.format(location=location, curr_weather=curr_weather, weather_forecast=weather_forecast, crop_name=crop_name, soil_analysis=soil_analysis,lang=lang)
    user_template= PromptTemplate(template="{user_input}", input_variables=["user_input"])

    messages = [
    HumanMessage("...."),
    AIMessage(content=final_prompt),
    HumanMessage(content=user_template.format(user_input=txt))
    ]
    res = chat_model(messages).content
    res = res[res.find("<|assistant|>")+len("<|assistant|>"):]
    return res

@app.post('/chat')
async def chat(data: chatItem):
    try:
        data = data.dict()
        print(data)
        txt = data['txt']
        lang = data['lang']
        location = data['location']
        curr_weather = data['curr_weather']
        weather_forecast = data['weather_forecast']
        crop_name = data['crop_name']
        crop_name = " "
        soil_analysis = data['soil_analysis']
        res = chatwithbot(txt, location, curr_weather, weather_forecast, crop_name, soil_analysis, lang)
        res = str(res)
        last_inst_index = res.rfind("[/INST]")
        res = res[last_inst_index + len("[/INST]"):].strip()
        print(res)
        return JSONResponse(content={"response":res})
    except Exception as e:
        return JSONResponse(content={"error": str(e)})
    
  
#following endpoint accepts post request, request body should contain crop name, forecasted weather, age of crop, soil analysis (not mandatory), location of farm, and current weather and returns daily tip for the crop after checking if this is first request of the day or not, if not first request then it will return the same tip as previous request, so we have to create session for each user, request will be in formdata.
# @app.post('/getdailytipforcrop')



@app.post('/predict')
def predict(data: Item):
    data = data.dict()
    print(data)
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
    print({'prediction': mapper[prediction[0]]})
    return {'prediction': mapper[prediction[0]]}

if __name__ == '__main__':
    uvicorn.run(app, host='127.0.0.1', port=8000)
