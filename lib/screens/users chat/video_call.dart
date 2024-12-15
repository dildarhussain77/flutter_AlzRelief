import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoCallScreen extends StatefulWidget {
  final RtcEngine engine;
  final String peerId;
  final String channelName;

  const VideoCallScreen({
    super.key, 
    required this.engine, 
    required this.peerId,
    required this.channelName,
  });

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool _isMuted = false;
  bool _isCameraOff = false;
  bool _isFrontCamera = true;

  @override
  void initState() {
    super.initState();
    _setupEventHandlers();
  }

  void _setupEventHandlers() {
    widget.engine.registerEventHandler(
      RtcEngineEventHandler(
    onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
      setState(() {
        _remoteUid = remoteUid; // Update remote user UID
      });
      print("Remote user joined: $remoteUid");
    },
    onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
      setState(() {
        _remoteUid = null; // Update when remote user leaves
      });
      print("Remote user left: $remoteUid");
    },
  ),
      // RtcEngineEventHandler(
      //   onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
      //     setState(() {
      //       _remoteUid = remoteUid;
      //     });
      //   },
      //   onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
      //     setState(() {
      //       _remoteUid = null;
      //     });
      //   },
      // ),
    );
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      widget.engine.muteLocalAudioStream(_isMuted);
    });
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOff = !_isCameraOff;
      widget.engine.muteLocalVideoStream(_isCameraOff);
    });
  }

  void _switchCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      widget.engine.switchCamera();
    });
  }

  void _endCall() {
    widget.engine.leaveChannel();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Remote User Video
            Center(
              child: _remoteUid != null
                  ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: widget.engine,
                        canvas: VideoCanvas(
                          uid: _remoteUid!,
                          renderMode: RenderModeType.renderModeHidden,  // Corrected render mode
                        ),
                      ),
                    )
                  : const Text('Waiting for remote user...'),
            ),

            // Local User Video (Small Overlay)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _remoteUid != null
                ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: widget.engine,
                    canvas: VideoCanvas(
                      uid: _remoteUid!,
                      renderMode: RenderModeType.renderModeHidden, // Corrected render mode
                    ),
                  ),
                )
                : const SizedBox.shrink(),
              ),
            ),

            // Call Controls
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mute Toggle
                  IconButton(
                    icon: Icon(
                      _isMuted ? Icons.mic_off : Icons.mic,
                      color: Colors.green,
                    ),
                    onPressed: _toggleMute,
                  ),

                  // Camera Toggle
                  IconButton(
                    icon: Icon(
                      _isCameraOff ? Icons.videocam_off : Icons.videocam,
                      color: Colors.green,
                    ),
                    onPressed: _toggleCamera,
                  ),

                  // Switch Camera
                  IconButton(
                    icon: const Icon(Icons.switch_camera, color: Colors.blue),
                    onPressed: _switchCamera,
                  ),

                  // End Call
                  IconButton(
                    icon: const Icon(Icons.call_end, color: Colors.red),
                    onPressed: _endCall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.engine.leaveChannel();
    widget.engine.release();
    super.dispose();
  }
}