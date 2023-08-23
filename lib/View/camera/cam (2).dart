// // Copyright 2013 The Flutter Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:pfc/utility/utility.dart';
//
//
// /// Camera example home widget.
// class CameraExampleHome extends StatefulWidget {
//   /// Default Constructor
//   const CameraExampleHome({super.key});
//
//   @override
//   State<CameraExampleHome> createState() {
//     return _CameraExampleHomeState();
//   }
// }
//
// /// Returns a suitable camera icon for [direction].
// IconData getCameraLensIcon(CameraLensDirection direction) {
//   switch (direction) {
//     case CameraLensDirection.back:
//       return Icons.camera_rear;
//     case CameraLensDirection.front:
//       return Icons.camera_front;
//     case CameraLensDirection.external:
//       return Icons.camera;
//   }
//   // This enum is from a different package, so a new value could be added at
//   // any time. The example should keep working if that happens.
//   // ignore: dead_code
//   return Icons.camera;
// }
//
// void _logError(String code, String? message) {
//   // ignore: avoid_print
//   print('Error: $code${message == null ? '' : '\nError Message: $message'}');
// }
//
// class _CameraExampleHomeState extends State<CameraExampleHome>
//     with WidgetsBindingObserver, TickerProviderStateMixin ,Utility{
//   CameraController? controller;
//   XFile? imageFile;
//   XFile? videoFile;
//   VoidCallback? videoPlayerListener;
//   bool enableAudio = true;
//   final double _minAvailableZoom = 1.0;
//   final double _maxAvailableZoom = 1.0;
//   double _currentScale = 1.0;
//   double _baseScale = 1.0;
//
//   // Counting pointers (number of user fingers on screen)
//   int _pointers = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   // #docregion AppLifecycle
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     final CameraController? cameraController = controller;
//
//     // App state changed before we got the chance to initialize.
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       return;
//     }
//
//     if (state == AppLifecycleState.inactive) {
//       cameraController.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       onNewCameraSelected(cameraController.description);
//     }
//   }
//   // #enddocregion AppLifecycle
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 height: 480,
//                 width: 845,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(
//                     color:Colors.grey,
//                     width: 3.0,
//                   ),
//                 ),
//                 child: Center(
//                   child: _cameraPreviewWidget(),
//                 ),
//               ),
//               heightBox10(),
//               _captureControlRowWidget(),
//               _cameraTogglesRowWidget(),
//               _thumbnailWidget(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Display the preview from the camera (or a message if the preview is not available).
//   Widget _cameraPreviewWidget() {
//     final CameraController? cameraController = controller;
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       return const Text(
//         'Tap a camera',
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 24.0,
//           fontWeight: FontWeight.w900,
//         ),
//       );
//     } else {
//       return Listener(
//         onPointerDown: (_) => _pointers++,
//         onPointerUp: (_) => _pointers--,
//         child: CameraPreview(
//           controller!,
//           child: LayoutBuilder(
//               builder: (BuildContext context, BoxConstraints constraints) {
//                 return GestureDetector(
//                   behavior: HitTestBehavior.opaque,
//                   onScaleStart: _handleScaleStart,
//                   onScaleUpdate: _handleScaleUpdate,
//                   onTapDown: (TapDownDetails details) =>
//                       onViewFinderTap(details, constraints),
//                 );
//               }),
//         ),
//       );
//     }
//   }
//
//   void _handleScaleStart(ScaleStartDetails details) {
//     _baseScale = _currentScale;
//   }
//
//   Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
//     // When there are not exactly two fingers on screen don't scale
//     if (controller == null || _pointers != 2) {
//       return;
//     }
//
//     _currentScale = (_baseScale * details.scale)
//         .clamp(_minAvailableZoom, _maxAvailableZoom);
//
//     await controller!.setZoomLevel(_currentScale);
//   }
//
//   /// Display the thumbnail of the captured image or video.
//   Widget _thumbnailWidget() {
//     return imageFile == null?
//     Container()
//         :
//     SizedBox(
//         height: 500,
//         width: 500,
//         // The captured image on the web contains a network-accessible URL
//         // pointing to a location within the browser. It may be displayed
//         // either with Image.network or Image.memory after loading the image
//         // bytes to memory.
//         child: kIsWeb
//             ? Image.network(imageFile!.path,fit: BoxFit.cover,)
//             : Image.file(File(imageFile!.path))
//     );
//   }
//   /// Display the control bar with buttons to take pictures and record videos.
//   Widget _captureControlRowWidget() {
//     final CameraController? cameraController = controller;
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//           minimumSize: const Size(200, 50)
//       ),
//       onPressed: cameraController != null &&
//           cameraController.value.isInitialized &&
//           !cameraController.value.isRecordingVideo
//           ? onTakePictureButtonPressed
//           : null,
//       child: const Text('Take Picture',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
//     );
//   }
//
//   /// Display a row of toggle to select the camera (or a message if no camera is available).
//   Widget _cameraTogglesRowWidget() {
//     final List<Widget> toggles = <Widget>[];
//
//     void onChanged(CameraDescription? description) {
//       if (description == null) {
//         return;
//       }
//       onNewCameraSelected(description);
//     }
//     if (_cameras.isEmpty) {
//       SchedulerBinding.instance.addPostFrameCallback((_) async {
//         // AlertBoxes.flushBar('No camera found.',context);
//       });
//       return const Text('No camera found.');
//     }
//     else {
//       for (final CameraDescription cameraDescription in _cameras) {
//         toggles.add(
//           SizedBox(
//             width: 90.0,
//             child: RadioListTile<CameraDescription>(
//               title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
//               groupValue: controller?.description,
//               value: cameraDescription,
//               onChanged:
//               controller != null && controller!.value.isRecordingVideo
//                   ? null
//                   : onChanged,
//             ),
//           ),
//         );
//       }
//     }
//
//     return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: toggles);
//   }
//
//   void showInSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
//     if (controller == null) {
//       return;
//     }
//
//     final CameraController cameraController = controller!;
//
//     final Offset offset = Offset(
//       details.localPosition.dx / constraints.maxWidth,
//       details.localPosition.dy / constraints.maxHeight,
//     );
//     cameraController.setExposurePoint(offset);
//     cameraController.setFocusPoint(offset);
//   }
//
//   Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
//     final CameraController? oldController = controller;
//     if (oldController != null) {
//       // `controller` needs to be set to null before getting disposed,
//       // to avoid a race condition when we use the controller that is being
//       // disposed. This happens when camera permission dialog shows up,
//       // which triggers `didChangeAppLifecycleState`, which disposes and
//       // re-creates the controller.
//       controller = null;
//       await oldController.dispose();
//     }
//
//     final CameraController cameraController = CameraController(
//       cameraDescription,
//       kIsWeb ? ResolutionPreset.max : ResolutionPreset.max,
//       enableAudio: enableAudio,
//       imageFormatGroup: ImageFormatGroup.jpeg,
//     );
//
//     controller = cameraController;
//
//     // If the controller is updated then update the UI.
//     cameraController.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//       if (cameraController.value.hasError) {
//         // AlertBoxes.flushBar(
//         //     'Camera error ${cameraController.value.errorDescription}',context);
//       }
//     });
//
//     try {
//       await cameraController.initialize();
//     } on CameraException catch (e) {
//       switch (e.code) {
//         case 'CameraAccessDenied':
//         // AlertBoxes.flushBar('You have denied camera access.',context);
//           break;
//         default:
//           _showCameraException(e);
//           break;
//       }
//     }
//
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   void onTakePictureButtonPressed() {
//     takePicture().then((XFile? file) {
//       if (mounted) {
//         setState(() {
//           imageFile = file;
//         });
//         if (file != null) {
//           // AlertBoxes.flushBar('Picture saved to ${file.path}',context);
//         }
//       }
//     });
//   }
//
//   Future<XFile?> takePicture() async {
//     final CameraController? cameraController = controller;
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       // AlertBoxes.flushBar('Error: select a camera first.',context);
//       return null;
//     }
//
//     if (cameraController.value.isTakingPicture) {
//       // A capture is already pending, do nothing.
//       return null;
//     }
//
//     try {
//       final XFile file = await cameraController.takePicture();
//       return file;
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }
//   }
//
//   void _showCameraException(CameraException e) {
//     _logError(e.code, e.description);
//     showInSnackBar('Error: ${e.code}\n${e.description}');
//   }
// }
//
// /// CameraApp is the Main Application.
// class CameraApp extends StatelessWidget {
//   /// Default Constructor
//   const CameraApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CameraExampleHome(),
//     );
//   }
// }
//
// List<CameraDescription> _cameras = <CameraDescription>[];
//
// Future<void> fetchCamera() async {
//   // Fetch the available cameras before initializing the app.
//   try {
//     WidgetsFlutterBinding.ensureInitialized();
//     _cameras = await availableCameras();
//   } on CameraException catch (e) {
//     _logError(e.code, e.description);
//   }
//   runApp(const CameraApp());
// }