import 'package:flutter/material.dart';

import 'drop_zone_widget.dart';
import 'dropped_image_widget.dart';
import 'model/dropped_file.dart';

class FilePickerWeb extends StatefulWidget {
  const FilePickerWeb({Key? key}) : super(key: key);

  @override
  State<FilePickerWeb> createState() => _FilePickerWebState();
}

class _FilePickerWebState extends State<FilePickerWeb> {
  DroppedFile? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// Preview
            DroppedFileWidget(file: file),

            const SizedBox(height: 16,),

            /// FileDropZone & PickFileButton
            SizedBox(
              height: 300,
              child: DropZoneWidget(
                onDroppedFile: (file) => setState(() => this.file = file),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:pfc/View/filePickerWeb/drop_zone_widget.dart';
// import 'package:pfc/View/filePickerWeb/dropped_image_widget.dart';
// import 'package:pfc/View/filePickerWeb/model/dropped_file.dart';
//
// class FilePickerWeb extends StatefulWidget {
//   const FilePickerWeb({Key? key}) : super(key: key);
//
//   @override
//   State<FilePickerWeb> createState() => _FilePickerWebState();
// }
//
// class _FilePickerWebState extends State<FilePickerWeb> {
//   DroppedFile? file;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         padding: const EdgeInsets.all(16),
//         child:  Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//
//             /// Preview
//             DroppedFileWidget(file: file),
//
//             const SizedBox(height: 16,),
//
//             /// FileDropZone & PickFileButton
//             SizedBox(
//               height: 300,
//               child: DropZoneWidget(
//                 onDroppedFile: (file) => setState(() => this.file = file),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
