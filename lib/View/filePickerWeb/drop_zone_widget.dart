import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:pfc/utility/colors.dart';

import 'model/dropped_file.dart';

class DropZoneWidget extends StatefulWidget {
  final ValueChanged<DroppedFile> onDroppedFile;

  const DropZoneWidget({Key? key,required this.onDroppedFile,}) : super(key: key);

  @override
  State<DropZoneWidget> createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {

  late DropzoneViewController dropzoneController;
  bool isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    // final colorButton = isHighlighted ? Colors.blue.shade300 : Colors.green.shade300.withOpacity(0.1) ;
    return Stack(
      children: [

        DropzoneView(
          onCreated: (controller) => dropzoneController = controller,
          onHover: () => setState(() => isHighlighted = true),
          onLeave: () => setState(() => isHighlighted = false),
          onDrop: acceptFile,
        ),

        Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              backgroundColor: ThemeColors.primaryColor,
            ),
            icon: const Icon(Icons.search , size: 30,),
            label: const Text('Choose Files' ,style: TextStyle(color: Colors.white , fontSize: 24),),
            onPressed: () async {
              final events = await dropzoneController.pickFiles();
              if(events.isEmpty) return;
              acceptFile(events.first);
            },
          ),
        ),
      ],
    );
  }

  Future acceptFile(dynamic event)async{
    final name = event.name;
    final mime = await dropzoneController.getFileMIME(event);
    final bytes = await dropzoneController.getFileSize(event);
    final url = await dropzoneController.createFileUrl(event);
    debugPrint("Name: $name");
    debugPrint("Mime: $mime");
    debugPrint("Bytes: $bytes");
    debugPrint("Url: $url");

    final droppedFile = DroppedFile(
      url: url,
      name:name,
      mime:mime,
      bytes:bytes,
    );

    widget.onDroppedFile(droppedFile);
    setState(() => isHighlighted = false);
  }

}


// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dropzone/flutter_dropzone.dart';
// import 'package:pfc/View/filePickerWeb/model/dropped_file.dart';
//
// class DropZoneWidget extends StatefulWidget {
//   final ValueChanged<DroppedFile> onDroppedFile;
//
//   const DropZoneWidget({Key? key,required this.onDroppedFile,}) : super(key: key);
//
//   @override
//   State<DropZoneWidget> createState() => _DropZoneWidgetState();
// }
//
// class _DropZoneWidgetState extends State<DropZoneWidget> {
//
//   late DropzoneViewController dropzoneController;
//   bool isHighlighted = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final colorBackground = isHighlighted ? Colors.blue : Colors.green;
//     final colorButton = isHighlighted ? Colors.blue.shade300 : Colors.green.shade300 ;
//     return buildDecoration(
//       child: Stack(
//         children: [
//
//           DropzoneView(
//             onCreated: (controller) => this.dropzoneController = controller,
//             onHover: () => setState(() => isHighlighted = true),
//             onLeave: () => setState(() => isHighlighted = false),
//             onDrop: acceptFile,
//           ),
//
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Icon(Icons.cloud_upload_rounded , size: 80, color: Colors.white,),
//                 const Text("Drop Files Here" , style: TextStyle(color: Colors.white),),
//                 const SizedBox(height: 16,),
//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(horizontal: 64),
//                     backgroundColor: colorButton,
//                     shape: const RoundedRectangleBorder()
//                   ),
//                     icon: const Icon(Icons.search , size: 32,),
//                     label: const Text('Choose Files' ,style: TextStyle(color: Colors.white , fontSize: 24),),
//                     onPressed: () async {
//                     final events = await dropzoneController.pickFiles();
//                     if(events.isEmpty) return;
//                     acceptFile(events.first);
//                     },
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future acceptFile(dynamic event)async{
//     final name = event.name;
//     final mime = await dropzoneController.getFileMIME(event);
//     final bytes = await dropzoneController.getFileSize(event);
//     final url = await dropzoneController.createFileUrl(event);
//     debugPrint("Name: $name");
//     debugPrint("Mime: $mime");
//     debugPrint("Bytes: $bytes");
//     debugPrint("Url: $url");
//
//     final droppedFile = DroppedFile(
//       url: url,
//       name:name,
//       mime:mime,
//       bytes:bytes,
//     );
//
//     widget.onDroppedFile(droppedFile);
//     setState(() => isHighlighted = false);
//   }
//
//   Widget buildDecoration({required Widget child}){
//     final colorBackground = isHighlighted ? Colors.blue : Colors.green;
//
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         color: colorBackground,
//         padding: const EdgeInsets.all(10),
//         child: DottedBorder(
//             borderType: BorderType.RRect,
//             color: Colors.white,
//             padding: EdgeInsets.zero,
//             radius: const Radius.circular(10),
//             strokeWidth: 3,
//             dashPattern: const [8 , 4],
//             child: child,
//         ),
//       ),
//     );
//
//   }
//
// }
