import 'dart:typed_data';

/// A platform-agnostic representation of a captured image
class CapturedImage {
  /// Local file path (might not be available on web)
  final String? path;

  /// The actual bytes of the image (works on all platforms)
  final Uint8List bytes;

  /// The filename or name of the image
  final String name;

  const CapturedImage({this.path, required this.bytes, required this.name});

  /// Check if the image has a valid path (non-web platforms)
  bool get hasPath => path != null && path!.isNotEmpty;
}
