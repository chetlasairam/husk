import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:huskkk/constants.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = AgoraConst.appId;
const token = AgoraConst.token;
const channel = AgoraConst.channelName;

class Call extends StatefulWidget {
  const Call({Key? key}) : super(key: key);

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isMuted = false; // Track microphone mute state
  bool _isFrontCamera = true; // Track camera position
  bool _isCameraOff = false; // Track camera off state
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    // create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> endCall() async {
    await _engine.leaveChannel();
    _engine.destroyCustomVideoTrack(0);
    Navigator.pop(context); // Close the current screen and go back
  }

  void toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _engine.muteLocalAudioStream(_isMuted);
    });
  }

  void toggleCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _engine.switchCamera();
    });
  }

  void toggleCameraOff() {
    setState(() {
      _isCameraOff = !_isCameraOff;
      _engine.enableLocalVideo(!_isCameraOff);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end),
            onPressed: endCall,
          ),
          IconButton(
            icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
            onPressed: toggleMute,
          ),
          IconButton(
            icon: Icon(_isFrontCamera ? Icons.camera_rear : Icons.camera_front),
            onPressed: toggleCamera,
          ),
          IconButton(
            icon: Icon(_isCameraOff ? Icons.videocam_off : Icons.videocam),
            onPressed: toggleCameraOff,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
