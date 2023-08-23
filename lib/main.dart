import 'package:flutter/material.dart';
import 'package:pfc/Provider/AnimationProvider.dart';
import 'package:pfc/Provider/DropDownProvider.dart';
import 'package:pfc/Provider/ProviderOfFragment.dart';
import 'package:pfc/View/Login/LoginScreen.dart';
import 'package:pfc/View/SideBar/SideBar.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DropdownProvider(),
        ),
        ChangeNotifierProvider( create: (_) => AnimationProvider(),),
        ChangeNotifierProvider(create: (_) => ButtonProvider()),
        ChangeNotifierProvider(create: (_) => FragmentsNotifier()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: const SideBar()),
          home: const LoginScreen()),
          // home: const NewLedger()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
