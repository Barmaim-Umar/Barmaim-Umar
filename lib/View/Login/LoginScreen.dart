import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/SideBar/SideBar.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Utility {

  bool obscure = true;
  UiDecoration uiDecoration = UiDecoration();
  TextDecorationClass textDecoration = TextDecorationClass();
  TextEditingController loginIDController = TextEditingController(text: 'MasterAdmin@gmail.com');
  TextEditingController passwordController = TextEditingController(text: 'MasterAdmin');
  TextEditingController ipController = TextEditingController(text: GlobalVariable.baseURL);
  List userData = [];
  int freshLoad = 0;

  @override
  void initState() {
    super.initState();
    initDB();
  }

  void initDB() async {
    await Hive.initFlutter();
    await Hive.openBox('user');
  }

  loginAccount(){
    setState(() => freshLoad = 1);

    login().then((value) {
      var info = jsonDecode(value);

      if (info['success'].toString() == 'true') {
        setStateMounted(() {
          Map data = {
            'user_id': info['data'][0]['user_id'],
            'user_name': info['data'][0]['user_name'],
            'login_email': info['data'][0]['login_email'],
            // 'login_password' :info['data'][0]['login_password'],
            'created_by': info['data'][0]['created_by'],
            'created_date': info['data'][0]['created_date'],
            'token': info['data'][0]['token'],
          };
          var user = Hive.box('user');
          user.put('user_details', data);

          /// Token & User ID
          GlobalVariable.userId = info['data'][0]['user_id'];
          GlobalVariable.entryBy = info['data'][0]['user_id'].toString();

          Auth.token = info['data'][0]['token'];

          currentFYApiFunc();
          freshLoad = 0;

        });

        // Navigator.push(context, MaterialPageRoute(builder: (context) => const SideBar(),));

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SideBar()),
        // );
        navigationTransition();

      }
      else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        debugPrint('success false');
        setState(() {
          freshLoad = 0;
        });
      }
    });
  }

  navigationTransition(){
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const SideBar();
          },
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const curve = Curves.fastOutSlowIn;

            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return ScaleTransition(
              scale: curvedAnimation,
              // position: tween.animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ));
  }

  // current financial year
  currentFYApiFunc(){
    ServiceWrapper().currentFYApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        GlobalVariable.fYearFrom = DateTime.parse(info['data'][0]['year_from'].toString());
        GlobalVariable.fYearTo = DateTime.parse(info['data'][0]['year_to'].toString());
        GlobalVariable.currentFYId = info['data'][0]['year_gen_id'];
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size;
    return Scaffold(
      /// if screen width is <= 827 : ... don't get confuse
      body: currentWidth.width<=827 ?
      Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          height: currentWidth.height,
          width: currentWidth.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/PFCBackground.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Transform.scale(
            scale: 0.9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          width: 400,
                          padding: const EdgeInsets.only(
                              left: 58, right: 50, top: 45),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withOpacity(0.6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/pushpaklogo.png',
                                    height: 150,
                                  ),
                                ],
                              ),
                              heightBox40(),
                              uiDecoration.textFormField('E-mail', loginIDController),
                              heightBox35(),
                              TextFormField(
                                controller: passwordController,
                                cursorColor: ThemeColors.grey700,
                                obscureText: obscure,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade700)),
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 0),
                                  labelText: 'Password',
                                  labelStyle:
                                  const TextStyle(color: Colors.grey),
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          obscure = !obscure;
                                        });
                                      },
                                      child: Icon(
                                        obscure == true
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.grey,
                                      )),
                                ),
                              ),
                              heightBox35(),
                              ElevatedButton(
                                style: ButtonStyles.blueButton(),
                                onPressed: () {
                                  loginAccount();
                                  if(loginIDController.text.isEmpty){
                                    AlertBoxes.flushBarErrorMessage('Enter Login ID', context);
                                  }
                                  else if(passwordController.text.isEmpty){
                                    AlertBoxes.flushBarErrorMessage('Enter Password', context);
                                  }
                                },
                                child: const Center(
                                  child: Text('Sign In'),
                                ),
                              ),
                              const SizedBox(height: 102,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 73,
                  ),
                ],
              ),
            ),
          ),
        ),
      ):
      Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          height: currentWidth.height,
          width: currentWidth.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/PFCBackground.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 8, child: Container()),
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 42),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              width: 400,
                              padding: const EdgeInsets.only(
                                  left: 58, right: 50, top: 45),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white.withOpacity(0.6),
                              ),
                              child: FocusScope(
                                child: FocusTraversalGroup(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/pushpaklogo.png',
                                            height: 150,
                                          ),
                                        ],
                                      ),
                                      heightBox40(),
                                      uiDecoration.textFormField('E-mail', loginIDController),

                                      heightBox35(),
                                      TextFormField(
                                        controller: passwordController,
                                        cursorColor: ThemeColors.grey700,
                                        obscureText: obscure,
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade700),
                                          ),
                                          contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0),
                                          labelText: 'Password',
                                          labelStyle:
                                          const TextStyle(color: Colors.grey),
                                          suffixIcon: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  obscure = !obscure;
                                                });
                                              },
                                              child: Icon(
                                                obscure == true
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.grey,
                                              )),
                                        ),
                                      ),
                                      heightBox35(),
                                      uiDecoration.textFormField('IP (Optional)', ipController),
                                      heightBox35(),
                                      freshLoad == 1 ?  Center(child: CircularProgressIndicator(color: ThemeColors.primary,)) :
                                      ElevatedButton(
                                          style: ButtonStyles.blueButton(),
                                          onPressed: () {

                                            if(ipController.text.isNotEmpty){
                                              GlobalVariable.baseURL = ipController.text;
                                            }

                                            if(loginIDController.text.isEmpty){
                                              AlertBoxes.flushBarErrorMessage('Enter Login ID', context);
                                            }
                                            else if(passwordController.text.isEmpty){
                                              AlertBoxes.flushBarErrorMessage('Enter Password', context);
                                            }
                                            else{
                                              loginAccount();
                                            }
                                          },
                                          child: const Center(
                                            child: Text('Sign In'),
                                          )
                                      ),
                                      const SizedBox(height: 172),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 55),
                    ],
                  ),
                ),
              ),
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  Future login() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', Uri.parse('${GlobalVariable.baseURL}User/LoginUser'));
    request.bodyFields = {
      'login_email': loginIDController.text,
      'login_password': passwordController.text
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    }
    else {
      debugPrint("this is error: ${response.reasonPhrase}");
    }

    // var url = Uri.parse(GlobalVariable.baseURL+'User/LoginUser');
    // var url = Uri.parse('http://192.168.5.117:444/User/LoginUser');
    // var headers = {
    //   'Content-Type': 'application/x-www-form-urlencoded'
    // };
    // var body = {
    //   'login_email': loginIDController.text,
    //   'login_password': passwordController.text
    // };
    // var response = await http.post(url, headers: headers, body: body);
    // print(response.body.toString());
    // return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }
}
