import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lawyer_app/ui/UserModel/clientModel.dart';
import 'package:e_lawyer_app/ui/Utils.dart';
import 'package:e_lawyer_app/ui/login_signup_pages/login_page_for_client.dart';
import 'package:e_lawyer_app/ui/profileinfoscreens/clientprofileinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  //final ref = FirebaseDatabase.instance.ref('Post');

  User? user = FirebaseAuth.instance.currentUser;

  ClientModel loggedInUser = ClientModel();
  //var fullname = loggedInUser.c_fullname.toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUserData();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = ClientModel.fromMap(value.data());
      setState(() {
        //fullname = loggedInUser.c_fullname.toString();
        //print(fullname);
      });
    });
  }

  // Widget showImage(BuildContext context) {
  //   return Container(
  //     //height: 300,
  //     width: 120.w,
  //     height: 120.h,
  //     decoration: BoxDecoration(
  //         image: DecorationImage(image: MemoryImage(base64Decode(loggedInUser.c_profilepic),),
  //             fit: BoxFit.cover),
  //        borderRadius: BorderRadius.circular(50.r)
  //     ),
  //     //child: Text('Image'),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('Client: ${loggedInUser.c_fullname}'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.yellow
              ),
                //
                //
                accountName: Text('${loggedInUser.c_fullname}'),
                accountEmail: Text('${loggedInUser.c_email}'),
              currentAccountPicture: FlutterLogo(),
            ),
            ListTile(
              title: Text('My Account'),
              leading: Icon(Icons.supervised_user_circle_sharp),
              onTap: (){
                //Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ClientProfileInfo())
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
            ),
            ListTile(
              title: Text('Contact us'),
              leading: Icon(Icons.contact_mail_rounded),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            const AboutListTile(
              icon: Icon(
                Icons.info,
              ),
              applicationIcon: Icon(
                Icons.local_play,
              ),
              applicationName: 'E - Laywer',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2022 pakdigitalground',
              aboutBoxChildren: [
                ///Content goes here...
              ],
              child: Text('About app'),
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout_outlined),
              onTap: (){
                //Navigator.pop(context);
                showAlertDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 230.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                image: const DecorationImage(
                    image: AssetImage('assets/images/back.jpeg'), fit: BoxFit.cover
                )
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 110.h,),
                    Text('Explore more', style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),),
                    SizedBox(height: 15.h,),
                    ElevatedButton(
                        onPressed: (){},
                        child: Text('Explore')
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25.h,),
            //Text(loggedInUser.c_email.toString()),
            //SizedBox(height: 25.h,),
            Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/advice.png', height: 50.h,),
                      SizedBox(height: 10.h,),
                      const Text('Online Advice'),
                    ],
                  ),
                ),
                SizedBox(width: 5.w,),
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/search.png', height: 50.h,),
                      SizedBox(height: 10.h,),
                      const Text('Search'),
                    ],
                  ),
                ),
                SizedBox(width: 5.w,),
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/lawyer.png', height: 50.h,),
                      SizedBox(height: 10.h,),
                      Text('Lawyers'),
                    ],
                  ),
                ),
                //SizedBox(width: 5,),
              ],
            ),
            SizedBox(height: 20.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/legal-document.png', height: 50.h,),
                      SizedBox(height: 10.h,),
                      Text('Legal Documents'),
                    ],
                  ),
                ),
                SizedBox(width: 5.w,),
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/newspaper.png', height: 50.r,),
                      SizedBox(height: 10.h),
                      Text('Legal News'),
                    ],
                  ),
                ),
                SizedBox(width: 5.w,),
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/defences.png', height: 50.h,),
                      SizedBox(height: 10.h,),
                      const Text('Defamation'),
                    ],
                  ),
                ),
                //SizedBox(width: 5,),
              ],
            ),
            SizedBox(height: 20.h,),
            Row(
              children: [
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/banking.png', height: 50.h,),
                      SizedBox(height: 10.h,),
                      const Text('Law firms'),
                    ],
                  ),
                ),
                SizedBox(width: 5.w,),

                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/calendar.png', height: 50.h,),
                      SizedBox(height: 10.h,),
                      const Text('Calendar'),
                    ],
                  ),
                ),
              ],
            ),
            //Text('Client Side', style: TextStyle(fontSize: 35.sp),),
            // SizedBox(height: 30.h,),
            // Text('Full name: ${loggedInUser.c_fullname}'),
            // Text('Email: ${loggedInUser.c_email}'),
            // Text('Address: ${loggedInUser.c_address}'),
            // Text('Password: ${loggedInUser.c_password}'),
            // Text('CNIC: ${loggedInUser.c_cnic}'),
          ],
        ),
      ),
    ));
  }
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No", style: TextStyle(
          color: Colors.black
      ),),
      onPressed:  () {
        //print('No');
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes", style: TextStyle(
        color: Colors.black
      ),),
      onPressed:  () async{

        auth.signOut().then((value) async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.remove('clientemail');
          pref.clear();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              LoginPageForClient()), (Route<dynamic> route) => false);
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) => const LoginPageForClient()));
        }).onError((error, stackTrace) {
          Utils().toastMessage(error.toString());
        });
        //print("Logout");
        // final SharedPreferences sp = await _pref;
        //
        // sp.remove("driver_shopname");
        // sp.remove("driver_name");
        // sp.remove("driver_email");
        // sp.remove("driver_countrycode");
        // sp.remove("driver_phoneno");
        // sp.remove("driver_address");
        // sp.remove("driver_password");
        // sp.remove("driver_fullphoneno");
        // sp.remove("driver_profilepic");

        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        //     LoginForm()), (Route<dynamic> route) => false);


      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout Dialogue"),
      content: Text("Do you really want to logout ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
