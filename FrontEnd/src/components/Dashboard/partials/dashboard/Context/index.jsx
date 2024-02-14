import { useContext, createContext, useState, useEffect } from "react";
import axios from "axios";

const StateContext = createContext();

export const StateContextProvider = ({ children }) => {
  const [weather, setWeather] = useState({});
  const [values, setValues] = useState([]);
  const [place, setPlace] = useState(null);
  const [thisLocation, setLocation] = useState("");

  useEffect(() => {
    const fetchUserLocation = async () => {
      try {
        const response = await axios.get(
          "http://localhost:5000/api/getuserlocation",
          {
            withCredentials: true,
          }
        );
        const userLocation = response.data.userInfo;

        // Assuming city information is available in userInfo.city
        const city = userLocation.city;
        console.log("city : " + city);
        setPlace(city); // Set the city for fetching weather information
      } catch (error) {
        console.error("Error fetching user Location:", error);
      }
    };

    fetchUserLocation();
  }, []);

  // fetch api
  const fetchWeather = async () => {
    const options = {
      method: "GET",
      url: "https://visual-crossing-weather.p.rapidapi.com/forecast",
      params: {
        aggregateHours: "24",
        location: place ? place : "Aurangabad",
        contentType: "json",
        unitGroup: "metric",
        shortColumnNames: 0,
      },
      headers: {
        "X-RapidAPI-Key": "92fc33f039mshb0206b8c02f67c8p186c27jsnbb5581423f26",
        "X-RapidAPI-Host": "visual-crossing-weather.p.rapidapi.com",
      },
    };

    try {
      const response = await axios.request(options);
      console.log(response.data);
      const thisData = Object.values(response.data.locations)[0];
      setLocation(thisData.address);
      setValues(thisData.values);
      setWeather(thisData.values[0]);
    } catch (e) {
      console.error(e);
      // if the api throws error.
      console.log("This place does not exist");
    }
  };

  useEffect(() => {
    fetchWeather();
  }, [place]);

  useEffect(() => {
    console.log(values);
  }, [values]);

  return (
    <StateContext.Provider
      value={{
        weather,
        setPlace,
        values,
        thisLocation,
        place,
      }}
    >
      {children}
    </StateContext.Provider>
  );
};

export const useStateContext = () => useContext(StateContext);
