import 'dart:ui';

import 'package:e_lawyer_app/ui/UserModel/lawyerModel.dart';
import 'package:e_lawyer_app/ui/homescreendata/LawyerHomeScreen.dart';
import 'package:e_lawyer_app/ui/login_signup_pages/signup_lawyer.dart';
import 'package:e_lawyer_app/ui/login_signup_pages/signup_page_for_client.dart';
import 'package:e_lawyer_app/ui/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageForLawyer extends StatefulWidget {
  const LoginPageForLawyer({Key? key}) : super(key: key);

  @override
  State<LoginPageForLawyer> createState() => _LoginPageForLawyerState();
}

class _LoginPageForLawyerState extends State<LoginPageForLawyer> {

  final _formFieldKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passController = TextEditingController();

  final auth = FirebaseAuth.instance;
  String? errorMessage;
  bool loading = false;

  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  //var lobj = LawyerModel();
  // Future setSP() async{
  //   final SharedPreferences sp = await _pref;
  //   sp.setString("name", lobj.l_fullname!);
  //   sp.setString("email", lobj.l_email!);
  //   sp.setString("cnic", lobj.l_cnic!);
  //   sp.setString("phoneno", lobj.l_phoneno!);
  //   sp.setString("address", lobj.l_address!);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  void signIn(String email, String password) async {
    if (_formFieldKey.currentState!.validate()) {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password).then((userData) async {
          // setSP().whenComplete(() {
          //   Fluttertoast.showToast(msg: "Login Successful");
          //   Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(builder: (context) => LawyerHomeScreen()),
          //           (Route<dynamic> route) => false);
          // });
          final SharedPreferences sp = await _pref;
          sp.setString('lawyeremail', email);
          Fluttertoast.showToast(msg: "Login Successful");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LawyerHomeScreen()),
                  (Route<dynamic> route) => false);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: 'errorMessage');
        print(error.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        //constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/wall.jpeg'), fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 150.h,),
                Text('Lawyer Login here', style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),),
                SizedBox(height: 150.h,),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Form(
                        key: _formFieldKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Enter email';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                //helperText: 'Enter email e.g ijlal@gmail.com',
                                prefixIcon: Icon(Icons.email_outlined, color: Colors.yellow,),
                              ),
                            ),
                            SizedBox(height: 10.h,),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              controller: passController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Enter password';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700
                              ),
                              decoration: const InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline, color: Colors.yellow,)
                              ),
                            ),
                            SizedBox(height: 40.h,),

                            RoundButton(title: 'Login',
                              loading: loading,
                              onTap: (){
                                signIn(emailController.text, passController.text);
                              },),

                            SizedBox(height: 15.h,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Do not have any account ?', style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.w700
                                ),),
                                TextButton(onPressed: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => const SignupScreenForLawyer()));
                                },
                                    child: const Text('Sign up', style: TextStyle(
                                        fontWeight: FontWeight.w700
                                    ),)
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h,),
                            InkWell(
                              onTap: (){
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) => const LoginWithPhoneno()));
                              },
                              child: Container(
                                height: 50.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.r),
                                    border: Border.all(
                                        color: Colors.yellow
                                    )
                                ),
                                child: const Center(
                                  child: Text('Login with phone', style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.w700,
                                  ),),
                                ),
                              ),
                            )

                          ],
                        )
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    ));
  }
}
