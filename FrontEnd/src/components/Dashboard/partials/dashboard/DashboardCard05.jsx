import React from "react";
import { useNavigate } from "react-router-dom";

function DashboardCard05() {
  const history = useNavigate();

  const goToMap = () => {
    history("/map");
  };

  return (
    <div className="flex flex-col col-span-full sm:col-span-6 bg-white shadow-lg rounded-sm border border-slate-200 border-radius-md p-4">
      {/* Content of the card */}

      {/* Spacer to push the button to the bottom */}
      <div className="flex-grow"></div>

      {/* Styled button to navigate to /map */}
      <button
        onClick={goToMap}
        className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded border border-blue-700"
      >
        Go to Map
      </button>
    </div>
  );
}

export default DashboardCard05;
