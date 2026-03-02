import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:nsd/nsd.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/session.dart';
import 'package:path_provider/path_provider.dart';
import 'package:media_scanner/media_scanner.dart';
import 'dart:io';
import 'dart:async';

class RobotControlPage extends StatefulWidget {
  const RobotControlPage({super.key});

  @override
  State<RobotControlPage> createState() => _RobotControlPageState();
}

class _RobotControlPageState extends State<RobotControlPage> {
  String? _robotIp;
  bool _isSearching = true;
  bool _isRecording = false;
  bool _showPreview = true;

  Discovery? _discovery;

  Timer? _timer;
  Duration _recordDuration = Duration.zero;

  String? _localVideoPath;
  Session? _ffmpegSession;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  /* =========================
     DISCOVERY
     ========================= */

  Future<void> _startDiscovery() async {
    _discovery = await startDiscovery('_http._tcp');

    _discovery!.addListener(() {
      if (_discovery!.services.isNotEmpty) {
        final service = _discovery!.services.first;
        if (service.port == 81 || service.port == 80) {
          final ip = service.addresses?.first.address;
          if (ip != null) {
            setState(() {
              _robotIp = ip;
              _isSearching = false;
            });
            stopDiscovery(_discovery!);
          }
        }
      }
    });
  }

  /* =========================
     RECORDING
     ========================= */

  void _toggleRecording() {
    if (_robotIp == null) return;

    if (!_isRecording) {
      _startRecording();
    } else {
      _stopRecording();
    }
  }

  Future<void> _startRecording() async {

    // 1️⃣ Remove preview completely (destroy widget)
    setState(() {
      _isRecording = true;
      _showPreview = false;
    });

    // 2️⃣ Wait long enough for ESP32 to release stream
    await Future.delayed(const Duration(milliseconds: 1500));

    final tempDir = await getTemporaryDirectory();
    _localVideoPath =
    '${tempDir.path}/pawme_${DateTime.now().millisecondsSinceEpoch}.mp4';

    _recordDuration = Duration.zero;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _recordDuration += const Duration(seconds: 1);
      });
    });

    final command =
        '-f mjpeg -i http://$_robotIp:81/stream '
        '-c:v mpeg4 '
        '-q:v 5 '
        '-y $_localVideoPath';

    _ffmpegSession =
    await FFmpegKit.executeAsync(command, (session) async {

      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        await _moveToGallery();
      } else {
        final logs = await session.getAllLogsAsString();
        debugPrint("FFmpeg Failed:\n$logs");
      }

      // Restore preview after recording
      setState(() {
        _showPreview = true;
      });
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();

    if (_ffmpegSession != null) {
      await _ffmpegSession!.cancel();
      await Future.delayed(const Duration(seconds: 2));
    }

    setState(() {
      _isRecording = false;
    });
  }

  /* =========================
     SAVE TO GALLERY
     ========================= */

  Future<void> _moveToGallery() async {
    if (_localVideoPath == null) return;

    final file = File(_localVideoPath!);
    if (!await file.exists() || await file.length() == 0) return;

    final directory = Directory('/storage/emulated/0/DCIM/Pawme');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final newPath =
        '${directory.path}/pawme_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final newFile = await file.copy(newPath);

    await MediaScanner.loadMedia(path: newFile.path);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video saved to DCIM/Pawme")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ffmpegSession?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(duration.inMinutes)}:${two(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    final streamUrl =
    _robotIp != null ? "http://$_robotIp:81/stream" : "";

    return Scaffold(
      backgroundColor: Colors.black,
      body: _robotIp == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: _showPreview
                      ? Mjpeg(
                    key: const ValueKey("preview"),
                    isLive: true,
                    stream: streamUrl,
                  )
                      : const SizedBox.shrink(),
                ),
                if (_isRecording)
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Text(
                      _formatDuration(_recordDuration),
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _toggleRecording,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.red,
              child: Icon(
                _isRecording
                    ? Icons.stop
                    : Icons.fiber_manual_record,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}