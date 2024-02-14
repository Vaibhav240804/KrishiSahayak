import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishi_sahayak/lang/abs_lan.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../providers/providers.dart';

class PersonalCalendar extends StatefulWidget {
  const PersonalCalendar({Key? key}) : super(key: key);

  @override
  State<PersonalCalendar> createState() => _PersonalCalendarState();
}

class _PersonalCalendarState extends State<PersonalCalendar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Languages.of(context)!.personalCal,
                style: Theme.of(context).textTheme.titleMedium),
            const Divider(height: 20),
            const HomeCalendarPage(),
          ],
        ),
      ),
    );
  }
}

class HomeCalendarPage extends StatefulWidget {
  const HomeCalendarPage({Key? key}) : super(key: key);

  @override
  State<HomeCalendarPage> createState() => _HomeCalendarPageState();
}

class _HomeCalendarPageState extends State<HomeCalendarPage> {
  late CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    return SizedBox(
      height: 600,
      child: Card(
        elevation: 5,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 500,
                child: SfCalendar(
                  cellEndPadding: 3,
                  showDatePickerButton: true,
                  view: CalendarView.month,
                  controller: _controller,
                  dataSource: MeetingDataSource(
                      Provider.of<TodoProvider>(context)
                          .meetings
                          .cast<Meeting>()),
                  todayHighlightColor: Colors.purpleAccent,
                  monthViewSettings: const MonthViewSettings(
                    showAgenda: true,
                    agendaItemHeight: 50,
                    agendaViewHeight: 200,
                  ),
                  headerHeight: 50,
                  headerDateFormat: 'MMMM yyyy',
                  appointmentBuilder: (context, calendarAppointmentDetails) {
                    if (calendarAppointmentDetails.appointments.isEmpty) {
                      return Container();
                    }
                    final Meeting meetingDetails =
                        calendarAppointmentDetails.appointments.first;

                    return Container(
                      margin: const EdgeInsets.fromLTRB(1, 6, 10, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 0),
                      width: calendarAppointmentDetails.bounds.width,
                      height: calendarAppointmentDetails.bounds.height,
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.withOpacity(0.3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              meetingDetails.subject.toString().split('.').last,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    if (todoProvider.meetings.length == 1) {
                                      return AlertDialog(
                                        title: const Text('No Todos'),
                                        content: const Text(
                                            'There are no todos for this date'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              Languages.of(context)!.cancel,
                                              style: const TextStyle(
                                                color: Colors.greenAccent,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return AlertDialog(
                                        title: const Text('Delete Todo'),
                                        content: const Text(
                                            'Are you sure you want to delete this todo?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              todoProvider.removeMeeting(
                                                  meetingDetails);
                                            },
                                            child: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  monthCellBuilder: (context, details) {
                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat.d(locale.toString())
                              .format(details.date)
                              .toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    );
                  },
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.purpleAccent, width: 4),
                    shape: BoxShape.circle,
                  ),
                  showNavigationArrow: true,
                  todayTextStyle: Theme.of(context).textTheme.titleSmall,
                  headerStyle: const CalendarHeaderStyle(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.purpleAccent,
                  elevation: 5,
                ),
                onPressed: () {
                  if (_controller.selectedDate == null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('No Date Selected'),
                          content:
                              const Text('Please select a date to add a todo'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                Languages.of(context)!.cancel,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  final Meeting meeting = Meeting(
                    startTime: _controller.selectedDate!,
                    endTime:
                        _controller.selectedDate!.add(const Duration(hours: 1)),
                    subject: FarmActivity.picking,
                    color: Colors.purpleAccent,
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Todo Details'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select Task'),
                              DropdownButtonFormField<FarmActivity>(
                                value: meeting.subject,
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    meeting.subject = newValue;
                                  }
                                },
                                items: FarmActivity.values.map((activity) {
                                  return DropdownMenuItem<FarmActivity>(
                                    value: activity,
                                    child: Text(
                                        activity.toString().split('.').last),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text(
                              Languages.of(context)!.cancel,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              todoProvider.addMeeting(meeting);
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text(
                              Languages.of(context)!.save,
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.add_circle_outline_sharp,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
    print(source.first.startTime);
  }
  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }
}
