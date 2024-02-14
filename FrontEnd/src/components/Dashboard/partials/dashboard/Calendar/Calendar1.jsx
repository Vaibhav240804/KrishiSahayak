import "./Calendar1";
import { Calendar, dateFnsLocalizer } from "react-big-calendar";
import format from "date-fns/format";
import parse from "date-fns/parse";
import startOfWeek from "date-fns/startOfWeek";
import getDay from "date-fns/getDay";
import "react-big-calendar/lib/css/react-big-calendar.css";
import React, { useState } from "react";
import DatePicker from "react-datepicker";
import enINLocale from "date-fns/locale/en-IN";
import "react-datepicker/dist/react-datepicker.css";

const eventTypes = [
  "Sowing",
  "Picking",
  "Growing and Harvesting Crops",
  "Cattle Hospitality",
  "Soil Testing",
  "Equipment Buying",
  "Equipment Servicing",
  "Feeding Livestock",
  "Other",
];

const localizer = dateFnsLocalizer({
  format,
  parse,
  startOfWeek,
  getDay,
  locales: {
    "en-IN": enINLocale,
  },
});

const initialEvents = [
  {
    title: "Sowing",
    allDay: true,
    start: new Date(2024, 0, 1),
    end: new Date(2024, 0, 1),
  },
  // ... (other events)
];

function Calendar1() {
  const [newEvent, setNewEvent] = useState({
    title: "",
    type: "Sowing",
    start: "",
    end: "",
  });
  const [allEvents, setAllEvents] = useState(initialEvents);

  function handleAddEvent() {
    // Set title to the selected type if it's not "Other"
    const title = newEvent.type === "Other" ? newEvent.title : newEvent.type;

    // Create a new event object
    const newEventObj = {
      title,
      start: newEvent.start,
      end: newEvent.end,
    };

    // Update the events state
    setAllEvents([...allEvents, newEventObj]);

    // Clear the form
    setNewEvent({ title: "", type: "Sowing", start: "", end: "" });
  }

  function handleDeleteEvent(event) {
    const updatedEvents = allEvents.filter((e) => e !== event);
    setAllEvents(updatedEvents);
  }

  return (
    <div className="app">
      <h1 className="mb-4 mt-8 text-3xl font-bold">Event Calendar</h1>
      <div className="form-container" style={{ marginBottom: "20px" }}>
        <div className="form-section flex flex-col items-center">
          <label htmlFor="eventType" className="block text-sm font-medium mb-2">
            Event Type:
          </label>
          <select
            id="eventType"
            value={newEvent.type}
            onChange={(e) =>
              setNewEvent({ ...newEvent, type: e.target.value, title: "" })
            }
            className="mt-1 block w-1/4 py-2 px-3 border rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm text-black"
          >
            {eventTypes.map((eventType) => (
              <option key={eventType} value={eventType}>
                {eventType}
              </option>
            ))}
          </select>
        </div>

        {newEvent.type === "Other" && (
          <div className="form-section">
            <label htmlFor="customTitle" className="block text-sm font-medium">
              Mention the other field
            </label>
            <input
              id="otherfield"
              type="text"
              placeholder="Other field"
              value={newEvent.title}
              onChange={(e) =>
                setNewEvent({ ...newEvent, title: e.target.value })
              }
              className="py-2 px-3 border rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm w-1/4 mx-auto"
              style={{ color: "black" }}
            />
          </div>
        )}

        <div
          className="form-section"
          style={{ marginTop: "10px", color: "black" }}
        >
          <label htmlFor="startDate" className="block text-sm font-medium">
            Start Date:
          </label>
          <DatePicker
            id="startDate"
            placeholderText="Select Start Date"
            selected={newEvent.start}
            onChange={(start) => setNewEvent({ ...newEvent, start })}
            className="mt-1 block w-full py-2 px-3 border rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
            style={{ color: "black" }}
          />
        </div>

        <div
          className="form-section"
          style={{ marginTop: "10px", color: "black" }}
        >
          <label htmlFor="endDate" className="block text-sm font-medium">
            End Date:
          </label>
          <DatePicker
            id="endDate"
            placeholderText="Select End Date"
            selected={newEvent.end}
            onChange={(end) => setNewEvent({ ...newEvent, end })}
            className="mt-1 block w-full py-2 px-3 border rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
          />
        </div>

        <button
          className="bg-black text-white rounded-md w-32 mt-4 py-2 px-4"
          onClick={handleAddEvent}
        >
          Add Event
        </button>
      </div>

      <div className="event-list">
        <h2 style={{ paddingBottom: "1rem" }}>Event List</h2>
        {allEvents.map((event, index) => (
          <div
            key={index}
            className="event-item"
            style={{ paddingBottom: "1rem" }}
          >
            <span className="event-number" style={{ paddingRight: "1rem" }}>
              {index + 1}.
            </span>
            <span className="event-title" style={{ paddingRight: "1rem" }}>
              {event.title}
            </span>
            <button
              className=" bg-black rounded-md w-32 "
              onClick={() => handleDeleteEvent(event)}
            >
              Delete Event
            </button>
          </div>
        ))}
      </div>

      <Calendar
        localizer={localizer}
        events={allEvents}
        startAccessor="start"
        endAccessor="end"
        style={{ height: 500, margin: "30px", background: "#f59e0b" }}
      />
    </div>
  );
}

export default Calendar1;
