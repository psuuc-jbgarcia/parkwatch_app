import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ParkingModelImageScreen extends StatefulWidget {
  final String fileName; // Allow dynamic file name assignment

  const ParkingModelImageScreen({Key? key, this.fileName = 'parkingmodel1'})
      : super(key: key); // Default to 'parkingmodel1'

  @override
  _ParkingModelImageScreenState createState() =>
      _ParkingModelImageScreenState();
}

class _ParkingModelImageScreenState extends State<ParkingModelImageScreen> {
  late Future<String> imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = fetchSpecificImageUrl(widget.fileName); // Fetch the specific image
  }

  /// Fetch the URL of a specific image by its file name
  Future<String> fetchSpecificImageUrl(String fileName) async {
    try {
      // Reference the specific file in Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('parkingmodel/$fileName');
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint('Error fetching image: $e'); // Debug log for error
      return ''; // Return an empty string on failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: imageUrl,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading indicator
        } else if (snapshot.hasError || snapshot.data!.isEmpty) {
          return Center(
            child: Text('Failed to load image. Please try again.'),
          );
        } else {
          final url = snapshot.data!;
          return Flexible(
            child: Container(
              constraints: BoxConstraints(maxHeight: 300), // Set max height
              child: Image.network(
                url,
                fit: BoxFit.contain,
              ),
            ),
          );
        }
      },
    );
  }
}
