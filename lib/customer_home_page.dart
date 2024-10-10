import 'package:flutter/material.dart';

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _selectedIndex = 0;
  bool _bookingMade = false; // Track if booking made
  DateTime? _bookedDate;
  TimeOfDay? _bookedTime;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeWidget(
        viewBooking: _viewBooking,
        bookedDate: _bookedDate,
        bookedTime: _bookedTime,
      ),
      BookingsWidget(
        onBookingMade: (DateTime date, TimeOfDay time) {
          setState(() {
            _bookingMade = true;
            _bookedDate = date;
            _bookedTime = time;
          });
        },
        viewBooking: _viewBooking,
      ),
      SettingsWidget(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _viewBooking() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Your Booking"),
          content: Text(
              "Date: ${_bookedDate?.toString()}\nTime: ${_bookedTime?.toString()}"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Home'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: _bookingMade ? _viewBooking : null,
              tooltip: 'View Booking',
              child: Icon(Icons.calendar_today),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class HomeWidget extends StatelessWidget {
  final VoidCallback? viewBooking;
  final DateTime? bookedDate;
  final TimeOfDay? bookedTime;

  HomeWidget({this.viewBooking, this.bookedDate, this.bookedTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Home Page Content'),
          if (bookedDate != null && bookedTime != null)
            ElevatedButton(
              onPressed: viewBooking,
              child: Text('View Booking'),
            ),
        ],
      ),
    );
  }
}

class BookingsWidget extends StatefulWidget {
  final Function(DateTime, TimeOfDay) onBookingMade;
  final VoidCallback? viewBooking;

  BookingsWidget({required this.onBookingMade, this.viewBooking});

  @override
  _BookingsWidgetState createState() => _BookingsWidgetState();
}

class _BookingsWidgetState extends State<BookingsWidget> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onBookingMade(_selectedDate!, _selectedTime!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Bookings',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select Date'),
          ),
          SizedBox(height: 16.0),
          if (_selectedDate != null)
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Select Time'),
            ),
          SizedBox(height: 16.0),
          if (_selectedTime != null)
            ElevatedButton(
              onPressed: () {
                // Add booking logic here
                print('Booking made on $_selectedDate at $_selectedTime');
              },
              child: Text('Make Booking'),
            ),
          SizedBox(height: 16.0),
          if (_selectedDate != null &&
              _selectedTime != null &&
              widget.viewBooking != null)
            ElevatedButton(
              onPressed: widget.viewBooking,
              child: Text('View Booking'),
            ),
        ],
      ),
    );
  }
}

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text('Settings Page Content'),
      ),
    );
  }
}
