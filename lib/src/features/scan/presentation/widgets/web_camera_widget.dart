// import 'dart:async';
// import 'dart:html' as html;
// import 'dart:js' as js;
// import 'dart:ui' as ui;

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:plant_app/features/scan/domain/models/captured_image.dart';

// class WebCameraWidget extends StatefulWidget {
//   final Function(CapturedImage capturedImage) onImageCaptured;

//   const WebCameraWidget({super.key, required this.onImageCaptured});

//   @override
//   WebCameraWidgetState createState() => WebCameraWidgetState();
// }

// class WebCameraWidgetState extends State<WebCameraWidget> {
//   final String viewType = 'web-camera-view-${DateTime.now().millisecondsSinceEpoch}';
//   late html.VideoElement _videoElement;
//   html.CanvasElement? _canvasElement;
//   bool _cameraInitialized = false;
//   bool _cameraAvailable = false;
//   bool _isCapturing = false;
//   html.MediaStream? _mediaStream;
//   bool _isFrontCamera = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebCamera();
//   }

//   @override
//   void dispose() {
//     _stopCameraStream();
//     super.dispose();
//   }

//   Future<void> _initializeWebCamera() async {
//     _videoElement =
//         html.VideoElement()
//           ..autoplay = true
//           ..muted = true
//           ..style.objectFit = 'cover'
//           ..style.width = '100%'
//           ..style.height = '100%';

//     // Register the video element with a unique id
//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) => _videoElement);

//     _canvasElement = html.CanvasElement(width: 1280, height: 720);

//     try {
//       await _startCameraStream();
//       setState(() {
//         _cameraAvailable = true;
//         _cameraInitialized = true;
//       });
//     } catch (e) {
//       print('Error initializing web camera: $e');
//       setState(() {
//         _cameraAvailable = false;
//         _cameraInitialized = true;
//       });
//     }
//   }

//   Future<void> _startCameraStream() async {
//     try {
//       final constraints = {
//         'video': {
//           'facingMode': _isFrontCamera ? 'user' : 'environment',
//           'width': {'ideal': 1280},
//           'height': {'ideal': 720},
//         },
//       };

//       _mediaStream = await html.window.navigator.mediaDevices?.getUserMedia(constraints);
//       if (_mediaStream != null) {
//         _videoElement.srcObject = _mediaStream;
//       }
//     } catch (e) {
//       print('Error starting camera stream: $e');
//       rethrow;
//     }
//   }

//   void _stopCameraStream() {
//     if (_mediaStream != null) {
//       _mediaStream!.getTracks().forEach((track) => track.stop());
//       _mediaStream = null;
//     }
//   }

//   void _switchCamera() {
//     _stopCameraStream();
//     setState(() {
//       _isFrontCamera = !_isFrontCamera;
//       _cameraInitialized = false;
//     });
//     _startCameraStream().then((_) {
//       setState(() {
//         _cameraInitialized = true;
//       });
//     });
//   }

//   Future<void> takePicture() async {
//     if (!_cameraInitialized || _isCapturing || _canvasElement == null) return;

//     setState(() {
//       _isCapturing = true;
//     });

//     try {
//       // Draw the current video frame to the canvas
//       _canvasElement!.width = _videoElement.videoWidth;
//       _canvasElement!.height = _videoElement.videoHeight;
//       _canvasElement!.context2D.drawImage(_videoElement, 0, 0);

//       // Convert canvas to blob
//       final completer = Completer<Uint8List>();
//       _canvasElement!.toBlob('image/jpeg').then((blob) {
//         final reader = html.FileReader();
//         reader.readAsArrayBuffer(blob);
//         reader.onLoadEnd.listen((event) {
//           final result = reader.result as Uint8List;
//           completer.complete(result);
//         });
//       });

//       final imageBytes = await completer.future;
//       final capturedImage = CapturedImage(
//         bytes: imageBytes,
//         name: 'web_camera_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
//       );

//       widget.onImageCaptured(capturedImage);
//     } catch (e) {
//       print('Error capturing image: $e');
//     } finally {
//       setState(() {
//         _isCapturing = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_cameraInitialized) {
//       return const Center(child: CircularProgressIndicator(color: Colors.green));
//     }

//     if (!_cameraAvailable) {
//       return _buildCameraUnavailableWidget();
//     }

//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: HtmlElementView(viewType: viewType),
//         ),
//         Positioned(
//           bottom: 20,
//           left: 0,
//           right: 0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.switch_camera),
//                 color: Colors.white,
//                 onPressed: _switchCamera,
//               ).animate().fade(duration: 300.ms).scale(delay: 200.ms),
//               const SizedBox(width: 20),
//               GestureDetector(
//                 onTap: takePicture,
//                 child: Container(
//                   height: 70,
//                   width: 70,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 4),
//                     color: Colors.transparent,
//                   ),
//                   child: Center(
//                     child:
//                         _isCapturing
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : Container(
//                               height: 60,
//                               width: 60,
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                               ),
//                             ),
//                   ),
//                 ),
//               ).animate().fade(duration: 300.ms).scale(delay: 100.ms),
//               const SizedBox(width: 20),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCameraUnavailableWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.camera_alt, size: 100, color: Colors.grey[400]),
//           const SizedBox(height: 20),
//           const Text(
//             'Camera access not available',
//             style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Please check your browser permissions or try using a different browser',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.grey),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: () async {
//               try {
//                 // Request permissions again
//                 await _startCameraStream();
//                 setState(() {
//                   _cameraAvailable = true;
//                 });
//               } catch (e) {
//                 print('Error requesting camera permission: $e');
//               }
//             },
//             icon: const Icon(Icons.refresh),
//             label: const Text('Try again'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
