import 'package:flutter/material.dart';

class ParkingIncidentsReports extends StatelessWidget {
  final List<Map<String, String>> posts = [
    {
      'title': 'Blocked Parking Space',
      'content': 'Someone parked their car blocking my space. License plate ABC123.',
      'comments': '5 comments',
    },
    {
      'title': 'Hit and Run',
      'content': 'Witnessed a hit and run in the parking lot. I have footage from my dashcam.',
      'comments': '3 comments',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parking Incidents'),
      
      ),
      body:ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  posts[index]['title']!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1759BD),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  posts[index]['content']!,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      posts[index]['comments']!,
      style: TextStyle(color: Colors.grey),
    ),
    TextButton(
      onPressed: () {
        // Handle commenting logic
      },
      child: Text('Comment'),
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF1759BD), // Updated to use 'foregroundColor'
      ),
    ),
  ],
),

              ],
            ),
          ),
        );
      },
    ) ,
    );
  }
}
