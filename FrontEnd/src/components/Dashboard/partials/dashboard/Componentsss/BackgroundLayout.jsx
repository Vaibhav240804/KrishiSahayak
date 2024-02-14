import React, { useEffect, useState } from "react";
import { useStateContext } from "../Context";
//images
import Clear from "../wheatherIcon/images/Clear.jpg";
import Fog from "../wheatherIcon/images/fog.png";
import Cloudy from "../wheatherIcon/images/Cloudy.jpg";
import Rainy from "../wheatherIcon/images/Rainy.jpg";
import Snow from "../wheatherIcon/images/snow.jpg";
import Stormy from "../wheatherIcon/images/Stormy.jpg";
import Sunny from "../wheatherIcon/images/Sunny.jpg";

const BackgroundLayout = () => {
  const { weather } = useStateContext();
  const [image, setImage] = useState(Clear);

  useEffect(() => {
    if (weather.conditions) {
      let imageString = weather.conditions;
      if (imageString.toLowerCase().includes("clear")) {
        setImage(Clear);
      } else if (imageString.toLowerCase().includes("cloud")) {
        setImage(Cloudy);
      } else if (
        imageString.toLowerCase().includes("rain") ||
        imageString.toLowerCase().includes("shower")
      ) {
        setImage(Rainy);
      } else if (imageString.toLowerCase().includes("snow")) {
        setImage(Snow);
      } else if (imageString.toLowerCase().includes("fog")) {
        setImage(Fog);
      } else if (
        imageString.toLowerCase().includes("thunder") ||
        imageString.toLowerCase().includes("storm")
      ) {
        setImage(Stormy);
      }
    }
  }, [weather]);

  return (
    <img
      src={image}
      alt="weather_image"
      className="h-fit w-full fixed left-0 top-0 -z-[10] pt-12 object-fill "
    />
  );
};

export default BackgroundLayout;
