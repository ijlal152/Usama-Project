import 'dart:ui';

import 'package:e_lawyer_app/ui/homescreendata/HomeScreen.dart';
import 'package:e_lawyer_app/ui/homescreendata/LawyerHomeScreen.dart';
import 'package:e_lawyer_app/ui/login_signup_pages/login_lawyer.dart';
import 'package:e_lawyer_app/ui/login_signup_pages/login_page_for_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({Key? key}) : super(key: key);

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  String? finalemail;
  String? obtainedlawyerEmail;

  Future getValidationData() async {
    final SharedPreferences sp = await _pref;
    var obtainedEmail = sp.getString('clientemail')!;
    var lawyerEmail = sp.getString('lawyeremail')!;
    setState(() {
      finalemail = obtainedEmail;
      //obtainedlawyerEmail = lawyerEmail;
    });
  }
  Future getLawyerValidationData() async {
    final SharedPreferences sp = await _pref;
    //var obtainedEmail = sp.getString('clientemail')!;
    var lawyerEmail = sp.getString('lawyeremail')!;
    setState(() {
      //finalemail = obtainedEmail;
      obtainedlawyerEmail = lawyerEmail;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getValidationData();
    // lawyer
    getLawyerValidationData().whenComplete(() {
      debugPrint('Email is: $obtainedlawyerEmail');
      if(obtainedlawyerEmail == null){

      }else{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            LawyerHomeScreen()), (Route<dynamic> route) => false);
      }
    });

    // client
    getValidationData().whenComplete(() async{
      debugPrint('Email is: $finalemail');
      if(finalemail == null){

      }else{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            HomeScreen()), (Route<dynamic> route) => false);
      }

      // if(finalemail == null && obtainedlawyerEmail == null){
      //
      // }else if(finalemail != null && obtainedlawyerEmail == null){
      //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
      //       HomeScreen()), (Route<dynamic> route) => false);
      // }else if(obtainedlawyerEmail != null && finalemail == null){
      //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
      //       LawyerHomeScreen()), (Route<dynamic> route) => false);
      // }else{
      //
      // }

    });

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
        child: SafeArea(
            child: Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
                        Text('E - Lawyer App',
                          style: GoogleFonts.inter(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w900,
                            color: Colors.yellow,

                          ),
                        ),
                        SizedBox(height: 150.h,),

                        Container(
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue,
                                  offset: Offset(
                                    5.0,
                                    5.0,
                                  ),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                              ]
                            //borderRadius: BorderRadius.circular(12.r),
                          ),
                          width: 270.w,
                          height: 70.h,
                          child: ElevatedButton.icon(
                            icon: Image.asset('assets/images/hire.png', height: 35.h,),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const LoginPageForClient()));
                            },
                            style: ElevatedButton.styleFrom(
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                            ),
                            label: Text('Join as Client',
                              style: GoogleFonts.inter(
                              fontSize: 25.sp,
                                fontWeight: FontWeight.w900
                            ),),
                          ),
                        ),

                        SizedBox(height: 60.h,),

                        Container(
                          width: 270.w,
                          height: 70.h,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green,
                                offset: Offset(
                                  5.0,
                                  5.0,
                                ),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ), //BoxShadow
                            ]
                            //borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ElevatedButton.icon(onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const LoginPageForLawyer()));
                          },
                            icon: Image.asset('assets/images/join.png', height: 35.h,),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r)
                            )
                          ),
                              label: Text('Join as Lawyer',
                                style: GoogleFonts.inter(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w900
                                ),),),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            )
        ),

    );
  }
}
