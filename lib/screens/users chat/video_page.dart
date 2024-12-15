import 'package:alzrelief/screens/users%20chat/video_call.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallPage extends StatefulWidget {
  final String userId;
  final String peerId;

  const VideoCallPage({
    super.key,
    required this.userId,
    required this.peerId,
  });

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  static const String appId = '27f3040165d643e5a88712f28d4c30d5';
  late RtcEngine _engine;
  bool _isInitializing = true;
  String? _errorMessage;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoCall();
  }

  Future<bool> _checkPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();

    if (cameraPermission.isPermanentlyDenied || microphonePermission.isPermanentlyDenied) {
      setState(() {
        _errorMessage = 'Permissions are permanently denied. Please enable them in settings.';
      });
      return false;
    }

    if (!cameraPermission.isGranted || !microphonePermission.isGranted) {
      throw Exception('Permissions not granted');
    }

    return true;
  }

  Future<void> _initializeVideoCall() async {
  try {
    if (!await _checkPermissions()) return;

    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    await _engine.enableVideo();
    await _engine.enableAudio();

    _setupEventHandlers();
    await _engine.startPreview();
    await _joinChannel(); // Ensure this is called after permissions and engine setup
  } catch (e) {
    print('Error during Agora setup: $e');
    _engine.release();
    setState(() {
      _errorMessage = 'Failed to initialize video call: $e';
      _isInitializing = false;
    });
  }
}


  void _setupEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          if (!_hasNavigated) {
            setState(() {
              _hasNavigated = true;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VideoCallScreen(
                  engine: _engine,
                  peerId: widget.peerId,
                  channelName: connection.channelId ?? '',
                ),
              ),
            );
          }
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('Remote user joined: $remoteUid');
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          print('Remote user left: $remoteUid');
        },
      ),
    );
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: '007eJxTYLieMYPH6V7CrZN7/CU+bP+tdbTypUBqLX/y0n3HFwXGFK5RYDAyTzM2MDEwNDNNMTMxTjVNtLAwNzRKM7JIMUk2Nkgx9Tgbmd4QyMgwZ+prRkYGCATxORkcc6qCUnMyU9MYGABXbSJ3',
      channelId: 'AlzRelief',
      uid: widget.userId.hashCode, // Ensure unique UIDs for both users
      options: const ChannelMediaOptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Initializing Video Call')),
      body: Center(
        child: _isInitializing
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage ?? 'Unable to start video call',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: _initializeVideoCall,
                    child: const Text('Retry'),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _engine?.release();
    super.dispose();
  }
}