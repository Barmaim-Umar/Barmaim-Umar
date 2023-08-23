import 'package:flutter/material.dart';

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({Key? key}) : super(key: key);

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {

  String dropdownValue = "Select Option";
  List<String> dropdownList = ["1" , "2" , "3" , "4" , "5"];
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      const SizedBox(height: 50,),
                      InkWell(
                        onTap: () {
                          isOpen = !isOpen;
                          setState(() {

                          });
                        },
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration:  BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(dropdownValue),
                                Icon( isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                        ),
                      ),
                      if(isOpen)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ListView(
                          primary: true,
                          shrinkWrap: true,
                          children: dropdownList.map((e) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(color: dropdownValue == e ? Colors.white : Colors.grey),
                            child: InkWell(
                                onTap: () {
                                  dropdownValue = e;
                                  isOpen = false;
                                  setState(() {

                                  });
                                },
                                child: Text(e)),
                          )).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ),

          Material(
            type: MaterialType.transparency,
            child: ListTile(
              tileColor: Colors.blue,
              onTap: () {

              },
              hoverColor: Colors.red,
              title: const Text("data"),),
          )

        ],
      ),
    );
  }
}
