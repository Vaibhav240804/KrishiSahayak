import React, { useState, useEffect } from "react";
import ML from "./ML_Prediction/ML";
// array(['rice', 'maize', 'chickpea', 'kidneybeans', 'pigeonpeas',
//        'mothbeans', 'mungbean', 'blackgram', 'lentil', 'pomegranate',
//        'banana', 'mango', 'grapes', 'watermelon', 'muskmelon', 'apple',
//        'orange', 'papaya', 'coconut', 'cotton', 'jute', 'coffee'],
//       dtype=object)

function DashboardCard04() {
  return (
    <div className="flex flex-col col-span-full sm:col-span-6 bg-stone-900 shadow-lg rounded-sm border border-slate-200 ">
      <ML />
    </div>
  );
}

export default DashboardCard04;
