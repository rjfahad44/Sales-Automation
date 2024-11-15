import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_automation/APIs/AuthenticationAPI.dart';
import 'package:sales_automation/Screens/HomeScreen/HomeScreen.dart';
import 'package:sales_automation/global.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController uNameController = TextEditingController();
  final TextEditingController pController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final ValueNotifier<bool> enableLoginButtons = ValueNotifier(true);
  bool _obscureText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //enableLoginButtons.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Text(
                          'Login Account',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // SvgPicture.asset("asset/images/User.svg"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 180,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: uNameController,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Enter Your Email address";
                            }
                            return null;
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              label: const Text("Email or UserName"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    width: 0.60, color: Color(0xFF6C6A6A)),
                              ),
                              prefixIcon: const Icon(Icons.person)),
                        ),

                        /// Email Text filed
                        const SizedBox(
                          height: 18,
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.text,
                          obscureText: _obscureText,
                          controller: pController,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Enter Your Password";
                            } else if (value.length < 5) {
                              return "Enter 6 digit password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text("Password"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  width: 0.60, color: Color(0xFF6C6A6A)),
                            ),
                            prefixIcon: const Icon(Icons.local_mall_outlined),
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {});
                                  _obscureText = !_obscureText;
                                },
                                child: _obscureText
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility)),
                          ),
                        ),

                        /// password TextFiled
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {

                              },
                              child: const Text(
                                'Forget Password?',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// forgot Password
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ValueListenableBuilder<bool>(
                              valueListenable: enableLoginButtons,
                              builder: (context, val, child) {
                                return ElevatedButton(
                                  onPressed: (val)
                                      ? () async {
                                          if (_key.currentState!.validate()) {
                                            enableLoginButtons.value =
                                                !enableLoginButtons.value;
                                            await loginProcess();
                                            enableLoginButtons.value =
                                                !enableLoginButtons.value;
                                          }
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: (val)
                                      ? const Text(
                                          'Login ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      : const Text(
                                          'Loading ... ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                );
                              }),
                        ),

                        /// login Button
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't Have an Account!",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            const SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                              onTap: () {

                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -180,
                left: -60,
                child: Opacity(
                  opacity: 0.25,
                  child: Container(
                    width: 480,
                    height: 406,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFFFC600),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -180,
                right: -260,
                child: Opacity(
                  opacity: 0.25,
                  child: Container(
                    width: 450,
                    height: 406,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFFFC600),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> loginProcess() async {
    String userName = uNameController.text.trim().toString();
    String password = pController.text.trim().toString();

    AuthenticationAPI api = AuthenticationAPI();
    bool status = await api.login(userName, password);
    if (status) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      Fluttertoast.showToast(
          msg: "Login failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
