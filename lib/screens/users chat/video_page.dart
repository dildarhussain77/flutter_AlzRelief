import 'package:alzrelief/screens/users%20chat/video_call.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallPage extends StatefulWidget {
  final String userId;
  final String peerId;

  const VideoCallPage({
    Key? key, 
    required this.userId, 
    required this.peerId
  }) : super(key: key);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  static const String appId = '27f3040165d643e5a88712f28d4c30d5';
  late RtcEngine _engine;
  bool _isInitializing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideoCall();
  }

  Future<void> _initializeVideoCall() async {
    try {
      // Ensure permissions are granted
      if (!await _checkPermissions()) {
        setState(() {
          _errorMessage = 'Camera and microphone permissions are required.';
          _isInitializing = false;
        });
        return;
      }

      // Initialize Agora Engine
      _engine = createAgoraRtcEngine();
      await _engine.initialize(RtcEngineContext(appId: appId));

      // Enable video and audio
      await _engine.enableVideo();
      await _engine.enableAudio();

      // Set up event handlers
      _setupEventHandlers();

      // Start local preview
      await _engine.startPreview();

      // Generate a dynamic channel name
      String channelName = _generateChannelName();

      // Join channel (you'll need to implement token generation)
      await _joinChannel(channelName);

    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize video call: $e';
        _isInitializing = false;
      });
    }
  }

  Future<bool> _checkPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();
    return cameraPermission.isGranted && microphonePermission.isGranted;
  }

  void _setupEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          print('Agora Error: $err - $msg');
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('Joined channel successfully');
          // Navigate to video call screen
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

  Future<void> _joinChannel(String channelName) async {
    // In a real app, generate a token server-side
    await _engine.joinChannel(
      token: '007eJxTYMhpSJto72zzXz13u2XotD/vpq8TvVzWJCX9sWnLkbTywrUKDEbmacYGJgaGZqYpZibGqaaJFhbmhkZpRhYpJsnGBimmPyPD0hsCGRmuHi5lYWSAQBBfgMExpyojNTM3tcg5IzEvLzWHgQEAAf4kqw==', // Implement token generation
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  String _generateChannelName() {
    return '${widget.userId}_${widget.peerId}_${DateTime.now().millisecondsSinceEpoch}';
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
    _engine.release();
    super.dispose();
  }
}