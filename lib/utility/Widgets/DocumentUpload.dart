import 'package:flutter/material.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class DocumentUpload extends StatelessWidget {
  final String title;
  const DocumentUpload({Key? key , required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10 , top: 10 , bottom: 10 , right: 70),
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(7)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document 1
          Row(
            children: [
              const Icon(Icons.upload),
              TextDecorationClass().heading2(title)
            ],
          ),
          const SizedBox(height: 10,),
          // Browse | No file Selected
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: ThemeColors.grey)
                ),
                child: const Text("Browse..."),
              ),
              const SizedBox(width: 10,),
              Text("No file selected." , style: TextStyle(color: Colors.grey.shade600 , fontSize: 13),),
            ],
          ),
          const SizedBox(height: 10,),
          // Upload Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () { debugPrint("tapped"); },
            icon: const Icon(Icons.upload),
            label: const Text("Upload"),
          )
        ],
      ),
    );
  }
}
