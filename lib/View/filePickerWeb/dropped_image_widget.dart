import 'package:flutter/material.dart';
import 'package:pfc/View/filePickerWeb/model/dropped_file.dart';

class DroppedFileWidget extends StatelessWidget {
  final DroppedFile? file;
  const DroppedFileWidget({Key? key , required this.file,}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildImage(),
      if (file != null ) buildFileDetails(file!),
    ],
  );

  Widget buildImage(){
    if (file == null ) return buildEmptyFile('No File');

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Image.network(
        file!.url,
        width: 520,
        height: 420,
        fit: BoxFit.contain,
        errorBuilder: (context, error, _) => buildEmptyFile('No Preview'),
      ),
    );
  }

  Widget buildEmptyFile(String text) => Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(5)
      ),
      child: const Icon(Icons.person,size: 200,)
  );

  Widget buildFileDetails(DroppedFile file) {
    const style = TextStyle(fontSize: 20);
    return Container(
      margin: const EdgeInsets.only(left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(file.name , style: style.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8,),
          // Text(file.mime , style: style,),
          // const SizedBox(height: 8,),
          // Text(file.size , style: style,),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:pfc/View/filePickerWeb/model/dropped_file.dart';
//
// class DroppedFileWidget extends StatelessWidget {
//   final DroppedFile? file;
//   const DroppedFileWidget({Key? key , required this.file,}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       buildImage(),
//       if (file != null ) buildFileDetails(file!),
//     ],
//   );
//
//   Widget buildImage(){
//     if (file == null ) return buildEmptyFile('No File');
//
//     return Image.network(
//         file!.url,
//         width: 120,
//       height: 120,
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, _) => buildEmptyFile('No Preview'),
//     );
//   }
//
//   Widget buildEmptyFile(String text) => Container(
//     width: 120,
//     height: 120,
//     color: Colors.blue.shade300,
//     child: Center(
//       child: Text(
//         text,
//         style:const  TextStyle(color: Colors.white),
//       ),
//     ),
//   );
//
//   Widget buildFileDetails(DroppedFile file) {
//     const style = TextStyle(fontSize: 20);
//     return Container(
//       margin: const EdgeInsets.only(left: 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(file.name , style: style.copyWith(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8,),
//           Text(file.mime , style: style,),
//           const SizedBox(height: 8,),
//           Text(file.size , style: style,),
//         ],
//       ),
//     );
//   }
// }
