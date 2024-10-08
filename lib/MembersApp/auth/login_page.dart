import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:societyuser_app/MembersApp/auth/forgotPassword.dart';
import 'package:societyuser_app/MembersApp/auth/signup_page.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/screen/HomeScreen/home_screen.dart';
import 'package:societyuser_app/VendorsApp/auth/Vendors_loginPage.dart';

// ignore: camel_case_types
class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

// ignore: camel_case_types
class _loginScreenState extends State<loginScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? userFlatNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const MyDrawer(flatnumber: userFlatNumber),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/theme.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Society Manager",
              style: TextStyle(
                  color: buttonTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                "Society Information & Management System",
                style: TextStyle(color: buttonTextColor, fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text('Welcome Back',
                style: TextStyle(
                    color: buttonTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(color: buttonTextColor),
                    textInputAction: TextInputAction.next,
                    controller: mobileController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: buttonTextColor,
                      )),
                      labelText: 'Mobile No.',
                      labelStyle: TextStyle(
                        color: buttonTextColor,
                      ),
                      // enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: buttonTextColor,
                      )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: buttonTextColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Mobile No.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: TextStyle(color: buttonTextColor),
                    textInputAction: TextInputAction.next,
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: buttonTextColor,
                        ),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: buttonTextColor,
                      ),
                      // enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: buttonTextColor,
                      )),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: buttonTextColor)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonTextColor,
                          foregroundColor: const Color.fromARGB(255, 0, 0, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login(mobileController.text,
                                passwordController.text, context);
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const forgotPassword();
                      }));
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: buttonTextColor),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginAsVendors();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Login as vendors',
                    style: TextStyle(color: buttonTextColor),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(color: buttonTextColor),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const signUp();
                      }),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: buttonTextColor, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void storeLoginData(bool isLogin, String phoneNum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('phoneNum');
    prefs.setBool('isLogin', isLogin);
    prefs.setString('phoneNum', phoneNum);
  }

  Future<void> login(
      String mobile, String password, BuildContext context) async {
    try {
      // Fetch the user document from Firestore based on the provided username
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(mobile)
          .get();

      if (userDoc.exists) {
        // Compare the provided password with the stored password
        final storedPassword = userDoc.data()!['password'];

        if (password == storedPassword) {
          storeLoginData(true, mobileController.text);
          SnackBar snackBar = const SnackBar(
            backgroundColor: Colors.green,
            content: Center(child: Text('Login successful')),
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        } else {
          SnackBar snackBar = const SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text('Incorrect password')),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        // User does not exist
        SnackBar snackBar = const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Center(child: Text('User does not exist'))),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // print('User does not exist');
      }
    } catch (e) {
      // Error occurred
      // ignore: avoid_print
      // print('Error: $e');
    }
  }
}
