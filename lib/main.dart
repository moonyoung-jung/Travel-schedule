import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class Trip {
  String title;
  String date;

  Trip({required this.title, required this.date});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '여행 일정 관리',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TripPlanner(),
    );
  }
}

class TripPlanner extends StatefulWidget {
  @override
  _TripPlannerState createState() => _TripPlannerState();
}

class _TripPlannerState extends State<TripPlanner> {
  List<Trip> trips = [];
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: Icon(Icons.menu), onPressed: (){},),
        backgroundColor: Colors.amber[100],
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(trips[index].title),
            subtitle: Text(trips[index].date),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTripPage()),
          ).then((value) {
            if (value != null) {
              setState(() {
                trips.add(value);
              });
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amber[100],
      ),
    );
  }
}

class AddTripPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('여행 일정 추가', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.amber[100]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: '여행 제목',
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                      labelText: '여행 일자',
                      suffixIcon: IconButton(onPressed: (){
                        showDatePicker(context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2031),
                        );
                      },
                          icon: Icon(Icons.calendar_month))
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  Trip(
                    title: titleController.text,
                    date: dateController.text,
                  ),
                );
              },
              child: Text('일정 추가'),
            ),
          ],
        ),
      ),
    );
  }
}