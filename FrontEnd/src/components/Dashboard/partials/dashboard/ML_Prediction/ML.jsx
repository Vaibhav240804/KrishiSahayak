import { useState, Fragment, useEffect } from "react";
import "./App.css";
import Modal from "./Compo/Modal";
import { Button } from "@material-tailwind/react";
import axios from "axios";

function ML() {
  const [showModal, setShowModal] = useState(false);
  const [prediction, setPrediction] = useState(null);
  const [image, setImage] = useState(null);
  const [userSoilComposition, setUserSoilComposition] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchUserSoilComposition = async () => {
      try {
        const response = await axios.get(
          "http://localhost:5000/api/getsoildetails",
          {
            withCredentials: true,
          }
        );
        setUserSoilComposition(response.data.soilComposition);
      } catch (error) {
        console.error("Error fetching user soil composition:", error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchUserSoilComposition();
  }, []);

  const handlePredictionUpdate = (newPrediction, newImage) => {
    setPrediction(newPrediction);
    setImage(newImage);
  };

  return (
    <Fragment>
      <div className="flex flex-col items-center justify-center h-screen">
        {isLoading ? (
          <p>Loading...</p>
        ) : userSoilComposition.length === 0 ? (
          <>
            <h1 className="text-3xl mb-5 text-white text-center">
              Please upload the soil composition and required details to
              determine suitable crops for cultivation by clicking the button
              below.
            </h1>

            <Button
              className="bg-blue-700 hover:bg-blue-800 focus:outline-none font-medium text-sm rounded-lg px-5 py-3 mt-5"
              onClick={() => setShowModal(true)}
            >
              Click Me
            </Button>
            <Modal
              isVisible={showModal}
              onClose={() => setShowModal(false)}
              onPredictionUpdate={handlePredictionUpdate}
            />
            {prediction && (
              <div>
                <p>
                  {" "}
                  <span
                    className=" text-2xl text-black "
                    style={{ color: "white", paddingRight: "1rem" }}
                  >
                    The Most Suitable Crop is:
                  </span>{" "}
                  <span className=" text-3xl text-green-600  ">
                    {prediction}
                  </span>{" "}
                </p>
                {image && (
                  <img
                    className="border-2 border-green-600 "
                    src={image}
                    alt="Predicted Crop"
                    style={{ width: "300px", height: "auto" }}
                  />
                )}
              </div>
            )}
          </>
        ) : (
          <div>
            <h1 className="text-3xl mb-5 text-white">User Soil Composition:</h1>
            <ul style={{ color: "white", fontSize: "2rem" }}>
              {userSoilComposition.map((soil, index) => (
                <li key={index}>
                  <strong>Soil Data:</strong>
                  <ul>
                    <li>{`N: ${soil.nLevel}`}</li>
                    <li>{`P: ${soil.pLevel}`}</li>
                    <li>{`K: ${soil.kLevel}`}</li>
                    <li>{`Temperature: ${soil.temperature}`}</li>
                    <li>{`Humidity: ${soil.humidity}`}</li>
                    <li>{`pH: ${soil.phLevel}`}</li>
                    <li>{`Rainfall: ${soil.rainfall}`}</li>
                  </ul>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    </Fragment>
  );
}

export default ML;
