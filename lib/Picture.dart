import 'dart:io';
import 'dart:async';

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cropperx/cropperx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pfc/utility/colors.dart';

class DriverPicture extends StatefulWidget {
  const DriverPicture({Key? key}) : super(key: key);

  @override
  State<DriverPicture> createState() => _DriverPictureState();
}

class _DriverPictureState extends State<DriverPicture> {
  List<CameraDescription> _cameras = <CameraDescription>[];
  int _cameraIndex = 0;
  int _cameraId = -1;
  bool _initialized = false;
  Size? _previewSize;
  final ResolutionPreset _resolutionPreset = ResolutionPreset.veryHigh;
  StreamSubscription<CameraErrorEvent>? _errorStreamSubscription;
  StreamSubscription<CameraClosingEvent>? _cameraClosingStreamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _fetchCameras();
  }

  @override
  void dispose() {
    _disposeCurrentCamera();
    _errorStreamSubscription?.cancel();
    _errorStreamSubscription = null;
    _cameraClosingStreamSubscription?.cancel();
    _cameraClosingStreamSubscription = null;
    super.dispose();
  }

  /// Fetches list of available cameras from camera_windows plugin.
  Future<void> _fetchCameras() async {
    List<CameraDescription> cameras = <CameraDescription>[];

    int cameraIndex = 0;
    try {
      cameras = await CameraPlatform.instance.availableCameras();
      if (cameras.isEmpty) {
      } else {
        cameraIndex = _cameraIndex % cameras.length;
      }
    } on PlatformException {
    }

    if (mounted) {
      setState(() {
        _cameraIndex = cameraIndex;
        _cameras = cameras;
      });
    }
  }

  /// Initializes the camera on the device.
  Future<void> _initializeCamera() async {
    assert(!_initialized);

    if (_cameras.isEmpty) {
      return;
    }

    int cameraId = -1;
    try {
      final int cameraIndex = _cameraIndex % _cameras.length;
      final CameraDescription camera = _cameras[cameraIndex];

      cameraId = await CameraPlatform.instance.createCamera(
        camera,
        _resolutionPreset,
      );

      _errorStreamSubscription?.cancel();
      _errorStreamSubscription = CameraPlatform.instance
          .onCameraError(cameraId)
          .listen(_onCameraError);

      _cameraClosingStreamSubscription?.cancel();
      _cameraClosingStreamSubscription = CameraPlatform.instance
          .onCameraClosing(cameraId)
          .listen(_onCameraClosing);

      final Future<CameraInitializedEvent> initialized =
          CameraPlatform.instance.onCameraInitialized(cameraId).first;

      await CameraPlatform.instance.initializeCamera(
        cameraId,
      );

      final CameraInitializedEvent event = await initialized;
      _previewSize = Size(
        event.previewWidth,
        event.previewHeight,
      );

      if (mounted) {
        setState(() {
          _initialized = true;
          _cameraId = cameraId;
          _cameraIndex = cameraIndex;
        });
      }
    } on CameraException {
      try {
        if (cameraId >= 0) {
          await CameraPlatform.instance.dispose(cameraId);
        }
      } on CameraException catch (e) {
        debugPrint('Failed to dispose camera: ${e.code}: ${e.description}');
      }

      // Reset state.
      if (mounted) {
        setState(() {
          _initialized = false;
          _cameraId = -1;
          _cameraIndex = 0;
          _previewSize = null;
        });
      }
    }
  }

  Future<void> _disposeCurrentCamera() async {
    if (_cameraId >= 0 && _initialized) {
      try {
        await CameraPlatform.instance.dispose(_cameraId);

        if (mounted) {
          setState(() {
            _initialized = false;
            _cameraId = -1;
            _previewSize = null;
          });
        }
      } on CameraException {
        if (mounted) {
          setState(() {
          });
        }
      }
    }
  }

  Widget _buildPreview() {
    return CameraPlatform.instance.buildPreview(_cameraId);
  }

  Future<void> _takePicture() async {
    final XFile file = await CameraPlatform.instance.takePicture(_cameraId);
    showCropper(context, before_cropped_image);
    setState(() {
      before_cropped_image = File(file.path.toString());

    });
    showCropper(context, before_cropped_image);
    _showInSnackBar('Picture captured to: ${file.path}');
  }




  Future<void> _switchCamera() async {
    if (_cameras.isNotEmpty) {
      // select next index;
      _cameraIndex = (_cameraIndex + 1) % _cameras.length;
      if (_initialized && _cameraId >= 0) {
        await _disposeCurrentCamera();
        await _fetchCameras();
        if (_cameras.isNotEmpty) {
          await _initializeCamera();
        }
      } else {
        await _fetchCameras();
      }
    }
  }



  void _onCameraError(CameraErrorEvent event) {
    if (mounted) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Error: ${event.description}')));

      // Dispose camera on camera error as it can not be used anymore.
      _disposeCurrentCamera();
      _fetchCameras();
    }
  }

  void _onCameraClosing(CameraClosingEvent event) {
    if (mounted) {
      _showInSnackBar('Camera is closing');
    }
  }

  void _showInSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ));
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
  File? file_choose_logo;
  File? before_cropped_image;
  String LogoAdded = "NotAdded";
  String non_teacher_image_api = "";
  bool useUpdateApi = false;

  final GlobalKey _teacherCropperKey = GlobalKey(debugLabel: 'teacherCropKey');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                if (_cameras.isEmpty)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 45)
                    ),
                    onPressed: () {
                      _fetchCameras ;
                    },
                    child: const Text('Re-check available cameras',overflow: TextOverflow.ellipsis,),
                  ),
                if (_cameras.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 49)
                        ),
                        onPressed: _initialized
                            ? _disposeCurrentCamera
                            : _initializeCamera,
                        child:
                        Text(_initialized ? 'Close camera' : 'Open camera'),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 49)
                        ),
                        onPressed: _initialized ? _takePicture : null,
                        child: const Text('Take picture'),
                      ),
                      if (_cameras.length > 1) ...<Widget>[
                        const SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: _switchCamera,
                          child: const Text(
                            'Switch camera',
                          ),
                        ),
                      ]
                    ],
                  ),
                const SizedBox(width: 5),
                InkWell(
                  child:Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ThemeColors.primaryColor)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, color: Colors.grey.shade700, size: 14,),
                        const SizedBox(width: 4,),
                        Expanded(
                          child:
                          file_choose_logo == null ?
                          Text(
                            non_teacher_image_api != "" && non_teacher_image_api != "null" ? non_teacher_image_api :"Choose Image",
                            style: TextStyle(color: Colors.grey.shade700),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          )
                              : Text(
                            file_choose_logo != null ? "$file_choose_logo" :"Choose Image",
                            style: TextStyle(color: Colors.grey.shade700),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap:(){
                    chooseImage();
                  },
                ),
              ],
            ),
            if (_initialized && _cameraId > 0 && _previewSize != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Align(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 500,
                    ),
                    child: AspectRatio(
                      aspectRatio: _previewSize!.width / _previewSize!.height,
                      child: _buildPreview(),
                    ),
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              height: 500,
              width: 500,
              decoration: BoxDecoration(
                  border: Border.all(color: ThemeColors.grey700)
              ),
              child: before_cropped_image==null?const Icon(Icons.person_outline,size: 300,):Image.file(before_cropped_image!),
            )
          ],
        ),
      ),
    );
  }
  chooseImage() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        before_cropped_image = File(result.files.single.path.toString());

      });
      showCropper(context, before_cropped_image);
    }
    else {
      // User canceled the picker
      setState(() {
        LogoAdded = "NotAdded";
      });
    }

    if(file_choose_logo != null){
      LogoAdded = "ADDED";
    }
  }

  showCropper(BuildContext context, File? file){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(

          title: const Text("Image Cropper"),

          actions: [
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
              setState(() {
                file_choose_logo == null;
              });
            }, child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Cancel"),
            ),),

            ElevatedButton(onPressed: () async {
              Navigator.pop(context);
              final imageBytes = await Cropper.crop(
                cropperKey: _teacherCropperKey,
              );
              File decodedimgfile = await File("image.jpg").writeAsBytes(imageBytes!);
              if (decodedimgfile != null)  {

                setState(() {
                  LogoAdded = "ADDED";
                  file = decodedimgfile;
                  file_choose_logo = file;
                }
                );
              }
            }, child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Set Image"),
            ),)

          ],
          content : Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
            ),
            child: Cropper(

              cropperKey: _teacherCropperKey,
              overlayType: OverlayType.grid,
              rotationTurns: 0,
              image: file==null?const Image(image: AssetImage('assets/pushpaklogo.png')):Image.file(file!),
            ),
          ),
        );
      },
    );
  }
}
