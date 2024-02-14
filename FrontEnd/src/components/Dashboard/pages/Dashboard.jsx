import React, { useState } from "react";
import DashboardCard04 from "../partials/dashboard/DashboardCard04";
import DashboardCard05 from "../partials/dashboard/DashboardCard05";
import DashboardCard11 from "../partials/dashboard/DashboardCard11";
import DashboardCard13 from "../partials/dashboard/DashboardCard13";
import WelcomeBanner from "../partials/dashboard/WelcomeBanner";
import Header from "../partials/Header";

function Dashboard() {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  return (
    <div className="flex h-screen overflow-hidden">


      {/* Content area */}
      <div className="relative flex flex-col flex-1 overflow-y-auto overflow-x-hidden">
        {/*  Site header */}
        <Header />

        <main>
          <div className="px-4 sm:px-6 lg:px-8 py-8 w-full max-w-9xl mx-auto">
            {/* Welcome banner */}
            <WelcomeBanner />

            {/* Dashboard actions */}
            <div className="sm:flex sm:justify-between sm:items-center mb-8">

              <div className="grid grid-flow-col sm:auto-cols-max justify-start sm:justify-end gap-2">

              </div>
            </div>

            {/* Cards */}
            <div className="grid grid-cols-12 gap-6  animate-fade-right animate-once animate-duration-[3000ms] animate-ease-linear ">
              {/* Bar chart (Direct vs Indirect) */}
              <DashboardCard04 />
              {/* Line chart (Real Time Value) */}
              <DashboardCard05 />
            
            </div>



            <div className=" pt-12 animate-fade-down animate-once animate-duration-[3000ms] animate-delay-[400ms] animate-ease-linear border-none " id="weather">
              <DashboardCard13  />
            </div>
            
            <div className=" pt-12  animate-fade-down animate-once animate-duration-[3000ms] animate-delay-[1500ms] animate-ease-linear" id="calendar">
              <DashboardCard11 />
            </div>


          </div>
        </main>
      </div>
    </div>
  );
}

export default Dashboard;
