import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void CameraDeepArCallback(CameraDeepArController controller);
typedef void OnImageCaptured(String path);
typedef void OnVideoRecorded(String path);
typedef void OnCameraReady(bool isCameraReady);

enum RecordingMode { photo, video, lowQVideo }

enum CameraMode { masks, effects, filters }

enum CameraDirection { back, front }

enum Masks {
  None,
  Aviators,
  Bigmouth,
  Dalmatian,
  Flowers,
  Koala,
  Lion,
  Smallface,
  Teddycigar,
  Kanye,
  Tripleface,
  Sleepingmask,
  Fatify,
  Obama,
  MudMask,
  Pug,
  Slash,
  TwistedFace,
  Grumpycat,
}

enum Effects {
  None,
  Fire,
  Rain,
  Heart,
  Blizzard,
}

enum Filters {
  None,
  Filmcolorperfection,
  Tv80,
  Drawingmanga,
  Sepia,
  Bleachbypass,
}

class CameraDeepAr extends StatefulWidget {
  final CameraDeepArCallback cameraDeepArCallback;
  final OnImageCaptured onImageCaptured;
  final OnVideoRecorded onVideoRecorded;
  final OnCameraReady onCameraReady;
  final String androidLicenceKey, iosLicenceKey;
  final RecordingMode recordingMode;
  final CameraDirection cameraDirection;
  final CameraMode cameraMode;

  const CameraDeepAr({
    Key? key,
    required this.cameraDeepArCallback,
    required this.androidLicenceKey,
    required this.iosLicenceKey,
    required this.onImageCaptured,
    required this.onVideoRecorded,
    required this.onCameraReady,
    this.cameraMode = CameraMode.masks,
    this.cameraDirection = CameraDirection.front,
    this.recordingMode = RecordingMode.video,
  }) : super(key: key);
  @override
  _CameraDeepArState createState() => _CameraDeepArState();
}

class _CameraDeepArState extends State<CameraDeepAr> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> args = {
      "androidLicenceKey": widget.androidLicenceKey,
      "iosLicenceKey": widget.iosLicenceKey,
      "recordingMode": RecordingMode.values.indexOf(widget.recordingMode),
      "direction": CameraDirection.values.indexOf(widget.cameraDirection),
      "cameraMode": CameraMode.values.indexOf(widget.cameraMode)
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
          viewType: 'plugins.flutter.io/deep_ar_camera',
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParams: args,
          creationParamsCodec: StandardMessageCodec());
    }
    return UiKitView(
        viewType: 'plugins.flutter.io/deep_ar_camera',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: args,
        creationParamsCodec: StandardMessageCodec());
  }

  void _onPlatformViewCreated(int id) async {
    final CameraDeepArController controller = await CameraDeepArController.init(
      id,
      this,
    );
    widget.cameraDeepArCallback(controller);
  }

  void onImageCaptured(String path) {
    widget.onImageCaptured(path);
  }

  void onVideoRecorded(String path) {
    widget.onVideoRecorded(path);
  }

  void onCameraReady(bool ready) {
    widget.onCameraReady(ready);
  }
}

class DeepCameraArPermissions {
  static const MethodChannel _channel = const MethodChannel('camera_deep_ar');

  static Future<bool> checkForPermission() async {
    return await _channel.invokeMethod('checkForPermission');
  }
}

class CameraDeepArController {
  CameraDeepArController._(
    this.channel,
    this._cameraDeepArState,
  ) {
    channel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<CameraDeepArController> init(
    int id,
    _CameraDeepArState _cameraDeepArState,
  ) async {
    final MethodChannel channel =
        MethodChannel('plugins.flutter.io/deep_ar_camera/$id');
    String resp = await channel.invokeMethod('isCameraReady');
    print("Camera Status $resp");
    return CameraDeepArController._(
      channel,
      _cameraDeepArState,
    );
  }

  @visibleForTesting
  final MethodChannel channel;

  final _CameraDeepArState _cameraDeepArState;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onCameraReady":
        bool isReady = call.arguments['isReady'] as bool;
        _cameraDeepArState.onCameraReady(isReady);
        break;
      case "onVideoRecordingComplete":
        String path = call.arguments['path'] as String;
        _cameraDeepArState.onVideoRecorded(path);
        break;
      case "onSnapPhotoCompleted":
        String path = call.arguments['path'] as String;
        _cameraDeepArState.onImageCaptured(path);
        break;
      default:
        throw MissingPluginException();
    }
  }

  Future isCameraReady() async {
    return channel.invokeMethod('isCameraReady');
  }

  Future dispose() async {
    return channel.invokeMethod('dispose');
  }

  Future switchCamera() async {
    return channel.invokeMethod('switchCamera');
  }

  Future snapPhoto() async {
    return channel.invokeMethod('snapPhoto');
  }

  Future startVideoRecording() async {
    return channel.invokeMethod('startVideoRecording');
  }

  Future stopVideoRecording() async {
    return channel.invokeMethod('stopVideoRecording');
  }

  // Future next({@required String licenceKey}) async {
  //   return channel.invokeMethod('next');
  // }
  //
  // Future previous({@required String licenceKey}) async {
  //   return channel.invokeMethod('previous');
  // }

  Future setCameraMode({required CameraMode camMode}) async {
    return channel.invokeMethod('setCameraMode', <String, dynamic>{
      'cameraMode': CameraMode.values.indexOf(camMode),
    });
  }

  Future setRecordingMode({required RecordingMode recordingMode}) async {
    return channel.invokeMethod('setRecordingMode', <String, dynamic>{
      'recordingMode': RecordingMode.values.indexOf(recordingMode),
    });
  }

  Future switchCameraDirection({required CameraDirection direction}) async {
    return channel.invokeMethod('switchCameraDirection', <String, dynamic>{
      'direction': CameraDirection.values.indexOf(direction),
    });
  }

  Future zoomTo(int p) async {
    return channel.invokeMethod('zoomTo', <String, dynamic>{
      'zoom': p,
    });
  }

  Future changeMask(int p) async {
    if (p > Masks.values.length - 1) p = 0;
    return channel.invokeMethod('changeMask', <String, dynamic>{
      'mask': p,
    });
  }

  Future changeEffect(int p) async {
    if (p > Effects.values.length - 1) p = 0;
    return channel.invokeMethod('changeEffect', <String, dynamic>{
      'effect': p,
    });
  }

  Future changeFilter(int p) async {
    if (p > Filters.values.length - 1) p = 0;
    return channel.invokeMethod('changeFilter', <String, dynamic>{
      'filter': p,
    });
  }
}
