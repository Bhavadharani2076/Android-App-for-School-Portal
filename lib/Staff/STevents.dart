import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolportal/common.dart';

// Model for Event Data
class EventData {
  final String date;
  final String eventTitle;
  final String description;

  EventData({
    required this.date,
    required this.eventTitle,
    required this.description,
  });
}

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<EventData> eventList = [];
  final String apiUrl = ip+'event.php'; // Replace with your server URL
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Fetch all events on initialization
  }

  Future<void> fetchEvents({String searchDate = ''}) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'searchDate': searchDate},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          eventList = data.map((event) => EventData(
            date: event['event_date'],
            eventTitle: event['event_title'],
            description: event['event_description'],
          )).toList();
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  void _onSearch() {
    String searchDate = _searchController.text.trim();
    fetchEvents(searchDate: searchDate); // Fetch events based on search date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Events',
          style: TextStyle(
            color: Colors.white, // Title text color set to white
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0FBBBF),
                Color(0xFF40E495),
                Color(0xFF30DD8A),
                Color(0xFF2BB673),
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft, // Matches the `to left` direction
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search by date (YYYY-MM-DD)',
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _onSearch,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: eventList.length,
              itemBuilder: (context, index) {
                final event = eventList[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline marker
                    Column(
                      children: [
                        if (index == 0)
                          Container(
                            height: 30.0,
                            width: 2.0,
                            color: Colors.green,
                          ),
                        Icon(Icons.circle, size: 10.0, color: Colors.green),
                        if (index != eventList.length - 1)
                          Container(
                            height: 100.0,
                            width: 2.0,
                            color: Colors.green,
                          ),
                      ],
                    ),
                    SizedBox(width: 16.0),
                    // Event card
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                event.date,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                decoration:
                                BoxDecoration(color: Colors.green[200], borderRadius:
                                BorderRadius.circular(20.0),),
                                padding:
                                EdgeInsets.symmetric(vertical:
                                10.0, horizontal:
                                16.0,),
                                child:
                                Column(children:[
                                  Text(event.eventTitle, style:
                                  TextStyle(fontSize:
                                  18.0, fontWeight:
                                  FontWeight.bold, color:
                                  Colors.white)),
                                  SizedBox(height:
                                  8.0,),
                                  Text(event.description, style:
                                  TextStyle(fontSize:
                                  14.0, color:
                                  Colors.grey[700])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}