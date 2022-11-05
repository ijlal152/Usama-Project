import 'dart:ui';

import 'package:e_lawyer_app/ui/UserModel/clientModel.dart';
import 'package:e_lawyer_app/ui/Utils.dart';
import 'package:e_lawyer_app/ui/homescreendata/HomeScreen.dart';
import 'package:e_lawyer_app/ui/login_signup_pages/signup_page_for_client.dart';
import 'package:e_lawyer_app/ui/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageForClient extends StatefulWidget {
  const LoginPageForClient({Key? key}) : super(key: key);

  @override
  State<LoginPageForClient> createState() => _LoginPageForClientState();
}

class _LoginPageForClientState extends State<LoginPageForClient> {

  final _formFieldKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passController = TextEditingController();

  final auth = FirebaseAuth.instance;

  String? errorMessage;

  bool loading = false;

  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  var obj = ClientModel();
  var a, b, c, d;
  // setSP() async{
  //   final SharedPreferences sp = await _pref;
  //   sp.setString("name", obj.c_fullname!);
  //   sp.setString("email", obj.c_email!);
  //   sp.setString("cnic", obj.c_cnic!);
  //   sp.setString("address", obj.c_address!);
  //   print('Shared preference has been set');
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
          //setSP();
          setState(() {
            loading = true;
          });
          final SharedPreferences sp = await _pref;
          sp.setString('clientemail', email);
          Fluttertoast.showToast(msg: "Login Successful");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false);
          setState(() {
            loading = false;
          });
        });
      } on FirebaseAuthException catch (error) {
        setState(() {
          loading = false;
        });
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



  void login(){

    // setState(() {
    //   loading = true;
    // });
    // auth.signInWithEmailAndPassword(email: emailController.text.toString(),
    //     password: passController.text.toString()).then((value) {
    //   Utils().toastMessage(value.user!.email.toString());
    //   // Navigator.push(context,
    //   //     MaterialPageRoute(builder: (context) => const HomeScreen()));
    //   setState(() {
    //     loading = false;
    //   });
    // }).onError((error, stackTrace) {
    //   debugPrint(error.toString());
    //   Utils().toastMessage(error.toString());
    //   setState(() {
    //     loading = false;
    //   });
    // });
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
                Text('Client Login here', style: TextStyle(
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
                                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return ("Please Enter a valid email");
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
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                            SizedBox(height: 10.h,),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              controller: passController,
                              validator: (value){
                                RegExp regex = new RegExp(r'^.{6,}$');
                                if(value!.isEmpty){
                                  return 'Enter password';
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Enter Valid Password(Min. 6 Character)");
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
                                  prefixIcon: Icon(Icons.lock_outline)
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
                                      MaterialPageRoute(builder: (context) => const SignupScreenForClient()));
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


