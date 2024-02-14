import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { BiUser } from "react-icons/bi";
import { AiOutlineUnlock } from "react-icons/ai";
import { FaMapMarkerAlt } from "react-icons/fa";
import { FaHome } from "react-icons/fa";
import { CgMail } from "react-icons/cg";
import axios from "axios";
import { useNavigate } from "react-router-dom";

function Register() {
  const [locationUpdate, setLocationUpdate] = useState(null);
  const [email, setEmail] = useState("");
  const [statename, setStatename] = useState("");
  const [cityname, setCityname] = useState("");
  const [address, setAddress] = useState("");
  const [name, setName] = useState("");
  const [password, setPassword] = useState("");
  const [pincode, setPincode] = useState("");
  const [latitude, setLatitude] = useState(null);
  const [longitude, setLongitude] = useState(null);

  useEffect(() => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(async (position) => {
        const { latitude, longitude } = position.coords;

        // Display alert and send location data to the server
        const allowLocation = window.confirm(`Allow Access to your Location!!`);

        if (allowLocation) {
          try {
            setLatitude(latitude);
            setLongitude(longitude);
            setLocationUpdate(false);
            const response = await axios.post(
              "http://localhost:5000/api/location",
              {
                latitude,
                longitude,
              }
            );
            const { city, state, address, pincode } = response.data;
            setCityname(city);
            setStatename(state);
            setAddress(address);
            setPincode(pincode);
            console.log(city, state, address, pincode);
            console.log("Location data saved:", response.data);
          } catch (error) {
            console.error("Error saving location data:", error.response.data);
          }
        } else {
          setLocationUpdate(true);
        }
      });
    } else {
      alert("Geolocation is not supported by this browser.");
    }
  }, []);

  const navigate = useNavigate();
  const submitHandler = async (e) => {
    e.preventDefault();

    try {
      const response = await axios.post("http://localhost:5000/api/register", {
        name,
        email,
        latitude,
        longitude,
        statename,
        cityname,
        pincode,
        address,
        password,
      });
      // console.log(latitude, longitude);
      console.log("User registered:", response.data);
      navigate("/login");
      // Optionally, redirect the user to a success page or handle accordingly
    } catch (error) {
      console.error("Error registering user:", error.response.data);
    }
  };

  return (
    <div>
      <div className="bg-slate-800 border border-slate-400 rounded-md p-8 shadow-lg backdrop-filter backdrop-blur-sm bg-opacity-30 relative">
        <h1 className="text-4xl text-green-600 text-center mb-6">Register</h1>

        <form onSubmit={submitHandler}>
          <div className="relative my-9">
            <input
              type="name"
              required
              id="name"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="block w-72 py-2.3 px-0 text-sm text-white bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:text-white focus:border-blue-600 peer"
              placeholder=""
            />
            <label
              htmlFor="name"
              className="absolute left-0 text-sm text-white duration-300 transform -translate-y-9  scale-100 top-5 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500  peer-placeholder-shown:scale-100  peer-placeholder-shown:top-0  peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6 "
            >
              Your Name
            </label>
            <BiUser className="absolute top-0 right-4 bottom-8" />
          </div>
          <div className="relative my-9">
            <input
              type="email"
              required
              id="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="block w-72 py-2.3 px-0 text-sm text-white bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:text-white focus:border-blue-600 peer"
              placeholder=""
            />
            <label
              htmlFor="email"
              className="absolute left-0 text-sm text-white duration-300 transform -translate-y-9  scale-100 top-5 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500  peer-placeholder-shown:scale-100  peer-placeholder-shown:top-0  peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6 "
            >
              Email
            </label>
            <CgMail className="absolute top-0 right-4 bottom-8" />
          </div>
          <div className="relative my-8">
            <input
              type="statename"
              required
              id="statename"
              value={statename}
              onChange={(e) => setStatename(e.target.value)}
              className="block w-72 py-2.3 px-0 text-sm text-white bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:text-white focus:border-blue-600 peer "
              placeholder=""
            />
            <label
              htmlFor="statename"
              className="absolute text-sm text-white duration-300 transform -translate-y-9 scale-100 top-5 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500  peer-placeholder-shown:scale-100 peer-placeholder-shown:top-0 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6  "
            >
              State Name
            </label>
            <FaMapMarkerAlt className="absolute top-0 right-4 bottom-8" />
          </div>
          <div className="relative my-8">
            <input
              type="cityname"
              required
              id="cityname"
              value={cityname}
              onChange={(e) => setCityname(e.target.value)}
              className="block w-72 py-2.3 px-0 text-sm text-white bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:text-white focus:border-blue-600 peer "
              placeholder=""
            />
            <label
              htmlFor="cityname"
              className="absolute text-sm text-white duration-300 transform -translate-y-9 scale-100 top-5 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500  peer-placeholder-shown:scale-100 peer-placeholder-shown:top-0 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6  "
            >
              City Name
            </label>
            <FaMapMarkerAlt className="absolute top-0 right-4 bottom-8" />
          </div>

          <div className="relative my-8">
            <input
              type="pincode"
              required
              id="pincode"
              value={pincode}
              onChange={(e) => setPincode(e.target.value)}
              className="block w-72 py-2.3 px-0 text-sm text-white bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:text-white focus:border-blue-600 peer "
              placeholder=""
            />
            <label
              htmlFor="pincode"
              className="absolute text-sm text-white duration-300 transform -translate-y-9 scale-100 top-5 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500  peer-placeholder-shown:scale-100 peer-placeholder-shown:top-0 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6  "
            >
              Pin Code
            </label>
            <FaMapMarkerAlt className="absolute top-0 right-4 bottom-8" />
          </div>

          <div className="relative my-8">
            <input
              type="address"
              required
              id="address"
              value={address}
              onChange={(e) => setAddress(e.target.value)}
              className="block w-72 py-2.3 px-0 text-sm text-white bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:text-white focus:border-blue-600 peer "
              placeholder=""
            />
            <label
              htmlFor="address"
              className="absolute text-sm text-white duration-300 transform -translate-y-9 scale-100 top-5 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500  peer-placeholder-shown:scale-100 peer-placeholder-shown:top-0 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6  "
            >
              Address
            </label>
            <FaHome className="absolute top-0 right-4 bottom-8" />
          </div>

          <div className="relative my-8">
            <input
              type="password"
              required
              id="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="block w-72 py-2.3 px-0 text-sm text-white bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:text-white focus:border-blue-600 peer "
              placeholder=""
            />
            <label
              htmlFor="password"
              className="absolute text-sm text-white duration-300 transform -translate-y-9 scale-100 top-5 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500  peer-placeholder-shown:scale-100 peer-placeholder-shown:top-0 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6  "
            >
              Your Password
            </label>
            <AiOutlineUnlock className="absolute top-0 right-4 bottom-8" />
          </div>
          {/* <div className="flex justify-between items-center">
            <div className="flex gap-2 items-center">
              <input type="checkbox" name="" id="" />
              <label htmlFor="Remember Me">Remember Me</label>
            </div>
            <Link to="" className="text-blue-500">
              Forgot Password?
            </Link>
          </div> */}
          <button
            className="w-full mb-4 text-[18px] mt-6 rounded-full bg-white text-emerald-800 hover:bg-emerald-600 hover:text-white py-2 transition-colors duration-300"
            type="submit"
          >
            Register
          </button>
          <div>
            <span className="m-4">
              Already Created ?{" "}
              <Link className="text-blue-500" to="/Login">
                Login
              </Link>{" "}
            </span>
          </div>
        </form>
      </div>
    </div>
  );
}

export default Register;
