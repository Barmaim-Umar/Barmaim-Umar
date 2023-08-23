import 'package:flutter/material.dart';
import 'package:pfc/utility/colors.dart';

class DeleteIconButton extends StatefulWidget {
  const DeleteIconButton({Key? key, required this.onPressed}) : super(key: key);
  final void Function()? onPressed;

  @override
  State<DeleteIconButton> createState() => _DeleteIconButtonState();
}

class _DeleteIconButtonState extends State<DeleteIconButton> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 20,
      width: 20,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(color: ThemeColors.deleteColor, borderRadius: BorderRadius.circular(5)),
      child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {
        showDialog(context: context, builder: (context) {
          return
            AlertDialog(
              title: const Text("Are you sure you want to delete"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: const Text("Cancel")),

                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: ThemeColors.darkRedColor,
                        foregroundColor: Colors.white
                    ),
                    onPressed: widget.onPressed,
                    child: const Text("Delete"),
                )
              ],
            );
        },);
      }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,)),
    );

  }
}
