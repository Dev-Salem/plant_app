import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_app/features/scan/presentation/screens/scan_result_screen.dart';

class CameraWidget extends StatefulWidget {
  final Function(String imagePath)? onImageCaptured;

  const CameraWidget({super.key, this.onImageCaptured});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isPermissionDenied = false;
  String? _capturedImagePath;
  bool _isCapturing = false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeController(_selectedCameraIndex);
    }
  }

  Future<void> _initializeCamera() async {
    if (await _checkCameraPermission()) {
      try {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          await _initializeController(_selectedCameraIndex);
        }
      } catch (e) {
        debugPrint('Error initializing camera: $e');
      }
    } else {
      setState(() {
        _isPermissionDenied = true;
      });
    }
  }

  Future<bool> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _initializeController(int cameraIndex) async {
    if (_cameras.isEmpty) return;

    final CameraController cameraController = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controller = cameraController;

    try {
      await cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
        _selectedCameraIndex = cameraIndex;
      });
    } catch (e) {
      debugPrint('Error initializing controller: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile photo = await _controller!.takePicture();
      setState(() {
        _capturedImagePath = photo.path;
      });
      widget.onImageCaptured?.call(photo.path);
    } catch (e) {
      debugPrint('Error taking picture: $e');
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _capturedImagePath = image.path;
        });
        widget.onImageCaptured?.call(image.path);
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  void _switchCamera() {
    if (_cameras.length < 2) return;
    final newIndex = _selectedCameraIndex == 0 ? 1 : 0;
    _initializeController(newIndex);
  }

  Widget _buildPermissionDeniedWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Camera access denied',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please grant camera permission to use this feature',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final result = await openAppSettings();
              if (result) {
                if (!mounted) return;
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isPermissionDenied) {
      return _buildPermissionDeniedWidget();
    }

    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.green));
    }

    return Column(
      children: [
        Expanded(
          child:
              _capturedImagePath != null
                  ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(File(_capturedImagePath!), fit: BoxFit.cover),
                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _capturedImagePath = null;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Retake'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: CameraPreview(_controller!),
                    ),
                  ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.flip_camera_ios),
                color: Colors.white,
                onPressed: _switchCamera,
              ).animate().fade(duration: 300.ms).scale(delay: 200.ms),

              IconButton(
                icon: const Icon(Icons.photo_library),
                color: Colors.white,
                onPressed: _pickImageFromGallery,
              ).animate().fade(duration: 300.ms).scale(delay: 150.ms),

              GestureDetector(
                onTap: _takePicture,
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child:
                        _isCapturing
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Container(
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ).animate().fade(duration: 300.ms).scale(delay: 100.ms),

              IconButton(
                icon: const Icon(Icons.close),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ).animate().fade(duration: 300.ms).scale(delay: 200.ms),
            ],
          ),
        ),
      ],
    );
  }
}

class CameraScreen extends ConsumerWidget {
  final Function(String imagePath)? onImageCaptured;

  const CameraScreen({super.key, this.onImageCaptured});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Take a photo of your plant', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: CameraWidget(
          onImageCaptured: (imagePath) {
            if (onImageCaptured != null) {
              onImageCaptured!(imagePath);
            } else {
              _processCapturedImage(context, ref, imagePath);
            }
          },
        ),
      ),
    );
  }

  void _processCapturedImage(BuildContext context, WidgetRef ref, String imagePath) {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ProcessingDialog(),
    );

    Navigator.pop(context); // Close dialog
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ScanResultScreen(imagePath: imagePath)),
    );
  }
}

class ProcessingDialog extends StatelessWidget {
  const ProcessingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Analyzing your plant...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Our AI is identifying the species and checking for diseases',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 300.ms).scale(begin: const Offset(0.8, 0.8));
  }
}
