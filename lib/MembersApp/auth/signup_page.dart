import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/auth/login_page.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/provider/PasswordValidatorProvider.dart';

// ignore: camel_case_types
class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

// ignore: camel_case_types
class _signUpState extends State<signUp> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  String mobile = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String errorMessage = "";

  @override
  void dispose() {
    mobileController.dispose();
    // emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passwordValidator = Provider.of<PasswordValidator>(context);
    return Scaffold(
      // drawer: const MyDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/theme.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Society Manager",
              style: TextStyle(
                  color: buttonTextColor,
                  fontSize: 20,
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
              height: 5,
            ),
            Text('Register as Member',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: buttonTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[6789][0-9]{0,9}$')),
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      style: TextStyle(color: buttonTextColor),
                      textInputAction: TextInputAction.next,
                      controller: mobileController,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: alertColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: buttonTextColor),
                        ),
                        hintText: 'Mobile No.',
                        hintStyle: TextStyle(
                          color: buttonTextColor,
                        ),

                        // enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: buttonTextColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
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
                    // TextFormField(
                    //   style: const TextStyle(color: buttonTextColor),
                    //   textInputAction: TextInputAction.next,
                    //   controller: emailController,
                    //   decoration: const InputDecoration(

                    //     enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //       color: buttonTextColor,
                    //     )),
                    //     labelText: 'Email',
                    //     labelStyle: TextStyle(
                    //       color: buttonTextColor,
                    //     ),
                    //     // enabledBorder: OutlineInputBorder(),
                    //     focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //       color: buttonTextColor,
                    //     )),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    //       borderSide: BorderSide(color: buttonTextColor),
                    //     ),
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter Email';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // const SizedBox(height: 10),
                    TextFormField(
                      style: TextStyle(color: buttonTextColor),
                      textInputAction: TextInputAction.next,
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: alertColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: buttonTextColor),
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: buttonTextColor,
                        ),
                        // enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: buttonTextColor),
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: buttonTextColor)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        passwordValidator.validatePassword(value);
                        return passwordValidator.errorMessage;
                      },
                      onChanged: (value) {
                        passwordValidator.updatePassword(value);
                        // setState(() {
                        //   password = value;
                        // });
                        _formKey.currentState?.validate();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: TextStyle(color: buttonTextColor),
                      textInputAction: TextInputAction.next,
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: alertColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: buttonTextColor),
                        ),
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(
                          color: buttonTextColor,
                        ),
                        // enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: buttonTextColor),
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: buttonTextColor)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value != passwordValidator.password) {
                          return 'Passwords does not match';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        passwordValidator.updateConfirmPassword(value);
                        // setState(() {
                        //   confirmPassword = value;
                        // });
                        _formKey.currentState?.validate();
                      },
                    ),
                    Text(
                      errorMessage,
                      style: TextStyle(
                          color: alertColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
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
                            foregroundColor:
                                const Color.fromARGB(255, 0, 0, 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            // if (_formKey.currentState!.validate()) {
                            await storeUserData(
                                context,
                                mobileController.text,
                                // emailController.text,
                                passwordController.text,
                                confirmPasswordController.text);
                            // }
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const loginScreen();
                          }));
                        },
                        child: Text(
                          "Already have an account? Sign In",
                          style:
                              TextStyle(color: buttonTextColor, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> storeUserData(BuildContext context, String mobile,
      String password, String confirmPassword) async {
    // final passwordValidator = Provider.of<PasswordValidator>(context);
    try {
      // Create a new document in the "users" collection
      await firestore.collection('users').doc(mobile).set({
        'Mobile No.:': mobile,
        // 'email': email,
        'password': password,
        'confirmPassword': confirmPassword
      });
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const loginScreen();
        }),
        (route) => false,
      );
      // passwordValidator.updateErrorMessage('');
      setState(() {
        errorMessage = '';
      });
    } on FirebaseException catch (e) {
      // passwordValidator.updateErrorMessage(e.message!);
      setState(() {
        errorMessage = e.message!;
      });
    }
  }
}
