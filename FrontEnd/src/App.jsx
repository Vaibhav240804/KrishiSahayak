import { useEffect, useState } from "react";
import Login from "./components/Login/Login";
import image from "./components/images/pics.jpg";
import { Route, Routes } from "react-router-dom";
import "./App.css";
import Register from "./components/Login/Register";
import Dashboard from "./components/Dashboard/pages/Dashboard";
import MapComponent from "./components/Mandimap/Map";

function App() {
  return (
    <div
      className="text-white h-[100vh] flex justify-center items-center bg-cover"
      style={{ backgroundImage: `url(${image})` }}
    >
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/map" element={<MapComponent />} />
        <Route path="" element={<Register />} />
        <Route path="/dashboard" element={<Dashboard />} />
      </Routes>
    </div>
  );
}

export default App;
