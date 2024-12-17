import React, { useState, useEffect } from "react";
import MarketDetails from "./MarketDetails";

const Findmarkets = () => {
  return (
    <div className=" ">
      <div className="bg-moon w-full h-full">
        <Map />
      </div>
    </div>
  );
};

function Map() {
  const [position, setPosition] = useState(null);
  const [markers, setMarkers] = useState([]);
  const [filteredResults, setFilteredResults] = useState([]);
  const [selectedPlace, setSelectedPlace] = useState(null);
  const [inputLocation, setInputLocation] = useState("");
  const [showInput, setShowInput] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => setPosition(position),
        (err) => {
          switch (err.code) {
            case err.PERMISSION_DENIED:
              setError("Location permission denied.");
              break;
            case err.POSITION_UNAVAILABLE:
              setError("Location information unavailable.");
              break;
            case err.TIMEOUT:
              setError("Geolocation request timed out.");
              break;
            default:
              setError("An unknown error occurred.");
          }
        }
      );
    } else {
      setError("Geolocation is not supported by this browser.");
    }
  }, []);

  const loadGoogleMapsScript = (apiKey) => {
    return new Promise((resolve, reject) => {
      if (window.google && window.google.maps) {
        resolve(window.google.maps);
      } else {
        const script = document.createElement("script");
        script.src = `https://maps.googleapis.com/maps/api/js?key=AIzaSyDzjhGRFc6zr04vdTOqLt-gVc9V32S9Lm4&libraries=places`;
        script.async = true;
        script.defer = true;
        script.onload = () => resolve(window.google.maps);
        script.onerror = () => reject(new Error("Failed to load Google Maps script."));
        document.head.appendChild(script);
      }
    });
  };

  const handleUseCurrentLocation = async () => {
    if (position) {
      try {
        await loadGoogleMapsScript("YOUR_API_KEY");
        fetchNearbyMarkets(position.coords.latitude, position.coords.longitude);
      } catch (err) {
        console.error(err.message);
      }
    }
  };

  const handleInputLocation = () => setShowInput(true);

  const handleSubmitLocation = async () => {
    if (inputLocation.trim() !== "") {
      setShowInput(false);
      try {
        await loadGoogleMapsScript("YOUR_API_KEY");
        fetchLocationCoordinates(inputLocation);
      } catch (err) {
        console.error(err.message);
      }
    }
  };

  const fetchLocationCoordinates = (location) => {
    const geocoder = new window.google.maps.Geocoder();
    geocoder.geocode({ address: location }, (results, status) => {
      if (status === window.google.maps.GeocoderStatus.OK) {
        const locationCoords = results[0].geometry.location;
        fetchNearbyMarkets(locationCoords.lat(), locationCoords.lng());
      } else {
        alert("Geocoding failed. Please try again with a different location.");
      }
    });
  };

  const fetchNearbyMarkets = (latitude, longitude) => {
    const map = new window.google.maps.Map(document.getElementById("map"), {
      center: { lat: latitude, lng: longitude },
      zoom: 15,
    });

    const request = {
      location: map.getCenter(),
      radius: "5000",
      name: ["market"],
    };

    const service = new window.google.maps.places.PlacesService(map);

    service.nearbySearch(request, (results, status) => {
      if (status === window.google.maps.places.PlacesServiceStatus.OK) {
        const operationalResults = results.filter(
          (place) => place.business_status === "OPERATIONAL"
        );
        setFilteredResults(operationalResults);
        setMarkers(
          operationalResults.map((place) => {
            const marker = new window.google.maps.Marker({
              position: place.geometry.location,
              map,
            });

            marker.addListener("click", () => setSelectedPlace(place));
            return marker;
          })
        );
      }
    });
  };

  return (
    <div className="shadow-slate-500 mt-5 border rounded-sm overflow-hidden">
      <div className="flex">
        <button
          onClick={handleUseCurrentLocation}
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mt-4 ml-4"
        >
          Use Current Location
        </button>
        <button
          onClick={handleInputLocation}
          className="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded mt-4 ml-4"
        >
          Input Location
        </button>
        {showInput && (
          <div className="flex ml-4">
            <input
              type="text"
              placeholder="Enter location..."
              className="h-10 mt-5 border rounded-md p-2 text-black"
              value={inputLocation}
              onChange={(e) => setInputLocation(e.target.value)}
            />
            <button
              onClick={handleSubmitLocation}
              className="bg-blue-500 mt-5 h-10 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded ml-2"
            >
              Submit
            </button>
          </div>
        )}
      </div>
      {error && <p className="text-red-500">{error}</p>}
      <div
        id="map"
        style={{
          height: "500px",
          width: "70%",
          margin: "45px 20px"
        }}
        className="my-10"
      ></div>
      {selectedPlace && (
        <MarketDetails
          chargingS={selectedPlace}
          onClose={() => setSelectedPlace(null)}
        />
      )}
    </div>
  );
}

export default Findmarkets;
