import React from 'react';
import Calendar1 from './Calendar/Calendar1';
// Import utilities
import { tailwindConfig } from '../../utils/Utils';

function DashboardCard11() {

  return(
    <div className="col-span-full xl:col-span-6 bg-slate-500 opacity-100 shadow-lg border border-slate-200 h-full text-center rounded-lg">     
        <Calendar1/>
    </div>
  )
}

export default DashboardCard11;
