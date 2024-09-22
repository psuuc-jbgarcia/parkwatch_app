// import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
// import 'package:video_player/video_player.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Feed App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: VideoFeedScreen(),
//     );
//   }
// }

// class VideoFeedScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Video Feed')),
//       body: Center(
//         child: VideoFeedWidget(videoUrl: 'http://192.168.100.177:5000/video_feed_flutter/1'),
//       ),
//     );
//   }
// }

// class VideoFeedWidget extends StatefulWidget {
//   final String videoUrl;

//   VideoFeedWidget({required this.videoUrl});

//   @override
//   _VideoFeedWidgetState createState() => _VideoFeedWidgetState();
// }

// class _VideoFeedWidgetState extends State<VideoFeedWidget> {
//   late VideoPlayerController _videoPlayerController;
//   late ChewieController _chewieController;

//   @override
//   void initState() {
//     super.initState();
//     _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController,
//       autoPlay: true,
//       looping: true,
//     );
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     _chewieController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Chewie(
//       controller: _chewieController,
//     );
//   }
// }
