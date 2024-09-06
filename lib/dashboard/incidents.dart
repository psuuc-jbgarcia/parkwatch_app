import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ParkingIncidentsReports extends StatefulWidget {
  @override
  _ParkingIncidentsReportsState createState() => _ParkingIncidentsReportsState();
}

class _ParkingIncidentsReportsState extends State<ParkingIncidentsReports> {
  final _commentControllers = <String, TextEditingController>{};
  String? _currentUserId;
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentUserId = user.uid;
      await _fetchUserName();
    }
  }

  Future<void> _fetchUserName() async {
    if (_currentUserId != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(_currentUserId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final firstName = userData['firstName'] ?? '';
        final lastName = userData['lastName'] ?? '';
        final displayName = userData['displayName'] ?? '';

        setState(() {
          _currentUserName = firstName.isNotEmpty && lastName.isNotEmpty
              ? '$firstName $lastName'
              : displayName.isNotEmpty
                  ? displayName
                  : 'Anonymous';
        });
      }
    }
  }

  void _handleCommentSubmit(String incidentId, String comment) {
    if (comment.isNotEmpty && _currentUserName != null) {
      FirebaseFirestore.instance
          .collection('admin')
          .doc(incidentId)
          .collection('comments')
          .add({
        'text': comment,
        'timestamp': FieldValue.serverTimestamp(),
        'userName': _currentUserName!,
      }).then((_) {
        _commentControllers[incidentId]?.clear();
      }).catchError((error) {
        print('Failed to add comment: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Parking Incidents'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('admin').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No incidents reported.'));
          }

          final incidents = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: incidents.length,
            itemBuilder: (context, index) {
              final incident = incidents[index];
              final data = incident.data() as Map<String, dynamic>;

              if (!_commentControllers.containsKey(incident.id)) {
                _commentControllers[incident.id] = TextEditingController();
              }

              final timestamp = data['timestamp'] as Timestamp?;
              final formattedTimestamp = timestamp != null
                  ? timeago.format(timestamp.toDate())
                  : 'No Timestamp';

              return Card(
                margin: EdgeInsets.only(bottom: 16.0),
                elevation: 5,
                shadowColor: Colors.grey.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['description'] ?? 'No Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1759BD),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Timestamp: $formattedTimestamp',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Divider(height: 20, thickness: 1.5),
                      // Comments
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('admin')
                            .doc(incident.id)
                            .collection('comments')
                            .orderBy('timestamp')
                            .snapshots(),
                        builder: (context, commentsSnapshot) {
                          if (commentsSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (commentsSnapshot.hasError) {
                            return Center(child: Text('Error: ${commentsSnapshot.error}'));
                          }

                          if (!commentsSnapshot.hasData || commentsSnapshot.data!.docs.isEmpty) {
                            return Text('No comments yet.');
                          }

                          final comments = commentsSnapshot.data!.docs;

                          return Column(
                            children: comments.map((commentDoc) {
                              final commentData = commentDoc.data() as Map<String, dynamic>;
                              final commentText = commentData['text'] ?? 'No Comment';
                              final commentTimestamp = commentData['timestamp'] as Timestamp?;
                              final userName = commentData['userName'] ?? 'Anonymous';
                              final formattedCommentTimestamp = commentTimestamp != null
                                  ? timeago.format(commentTimestamp.toDate())
                                  : 'No Timestamp';

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Text(
                                    commentText,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Posted by $userName on $formattedCommentTimestamp',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),

                      Divider(height: 20, thickness: 1.5),
                      // Comment Input
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentControllers[incident.id],
                                decoration: InputDecoration(
                                  labelText: 'Add a comment',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send, color: Color(0xFF1759BD)),
                              onPressed: () {
                                final comment = _commentControllers[incident.id]?.text ?? '';
                                _handleCommentSubmit(incident.id, comment);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
