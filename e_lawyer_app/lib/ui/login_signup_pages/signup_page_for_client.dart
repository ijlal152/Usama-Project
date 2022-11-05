import 'dart:async';
import 'dart:ui';
import 'package:e_lawyer_app/ui/UserModel/clientModel.dart';
import 'package:e_lawyer_app/ui/homescreendata/HomeScreen.dart';
import 'package:e_lawyer_app/ui/login_signup_pages/location/current_Location.dart';
import 'package:e_lawyer_app/ui/login_signup_pages/login_page_for_client.dart';
import 'package:e_lawyer_app/ui/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreenForClient extends StatefulWidget {
  const SignupScreenForClient({Key? key}) : super(key: key);

  @override
  State<SignupScreenForClient> createState() => _SignupScreenForClientState();
}

class _SignupScreenForClientState extends State<SignupScreenForClient> {

  //final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  String? finalemail;
  String clientImage = '';

  // Future getValidationData() async {
  //   final SharedPreferences sp = await _pref;
  //   var obtainedEmail = sp.getString('email')!;
  //   setState(() {
  //     finalemail = obtainedEmail;
  //   });
  //   print(finalemail);
  // }

  bool loading = false;
  String? errorMessage;
  final _formFieldKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final cnicController = TextEditingController();
  final fullnameController = TextEditingController();
  final locationController = TextEditingController();

  final auth = FirebaseAuth.instance;

  var newlocality ;
  var newcountry ;
  var newDistrict ;
  var newprovice ;

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    //locationController.text = '${newlocality}, ${newcountry}, ${newDistrict}, ${newprovice} ';
    super.initState();
    // getValidationData().whenComplete(() {
    //   if(finalemail == null){
    //
    //   }else{
    //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    //         HomeScreen()), (Route<dynamic> route) => false);
    //   }
    // });

  }


  //FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
    cnicController.dispose();
    fullnameController.dispose();
    locationController.dispose();
  }

  CurrentLocation location = CurrentLocation();

  String Address = 'search';

  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.5690628,72.6349776),
    zoom: 11, tilt: 60,
  );

  final List<Marker> _marker =  <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.5651,73.0169),
        infoWindow: InfoWindow(
            title: 'Rawalpindi'
        )
    ),

  ];

  loadData () {
    getUserCurrentLocation().then((value) async{
      print('My current location: ');
      print("${value.latitude} ${value.longitude}");
      List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude, value.longitude);
      print(placemarks);
      Placemark place = placemarks[0];
      Address = '${place.locality}, ${place.country}';
      newlocality = '${place.locality}';
      newcountry = '${place.country}';
      newDistrict = '${place.subAdministrativeArea}';
      newprovice = '${place.administrativeArea}';
      setState(() {
        print(Address);
        print('Locality: ${place.locality}, District: $newDistrict, Province: $newprovice Country: ${place.country}');
      });



      _marker.add(
          Marker(
              markerId: MarkerId('2'),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: const InfoWindow(
                  title: 'My current location'
              )
          )
      );
      CameraPosition cameraPosition = CameraPosition(
        zoom: 14,
        target: LatLng(value.latitude, value.longitude),
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState((){

      });
    }
    );
  }

  Future<Position> getUserCurrentLocation() async{
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace) {
      print('Error'+error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }



  void signUp(String email, String password) async {
    if (_formFieldKey.currentState!.validate()) {
      try {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
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
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    ClientModel clientModel = ClientModel();

    // writing all the values
    //clientModel.c_id = user!.email;
    //var id = DateTime.now().millisecondsSinceEpoch.toString();
    clientModel.c_id = user!.uid;
    clientModel.c_fullname = fullnameController.text;
    clientModel.c_cnic = cnicController.text;
    clientModel.c_email = emailController.text;
    clientModel.c_password = passController.text;
    clientModel.c_profilepic = clientImage;
    clientModel.c_address = locationController.text;



    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(clientModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
  }

  // void signUp(){
  //   setState(() {
  //     loading = true;
  //   });
  //   auth.createUserWithEmailAndPassword(email: emailController.text.toString(),
  //       password: passController.text.toString()).then((value) {
  //     setState(() {
  //       loading = false;
  //     });
  //   }).onError((error, stackTrace) {
  //     //Utils().toastMessage(error.toString());
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/wall.jpeg'), fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 150.h,),
                Text('Client Signup here', style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),),
                SizedBox(height: 85.h,),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Form(
                        key: _formFieldKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: fullnameController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Enter full name';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700
                              ),
                              decoration: const InputDecoration(
                                  hintText: 'Full Name',
                                  //helperText: 'Enter email e.g ijlal@gmail.com',
                                  prefixIcon: Icon(Icons.label_important_outline, color: Colors.yellow,)
                              ),
                            ),
                            SizedBox(height: 10.h,),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: cnicController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Enter CNIC';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700
                              ),
                              decoration: const InputDecoration(
                                  hintText: 'Enter CNIC e.g: 37102-2323232-9',
                                  //helperText: 'Enter email e.g ijlal@gmail.com',
                                  prefixIcon: Icon(Icons.perm_identity, color: Colors.yellow,)
                              ),
                            ),
                            SizedBox(height: 10.h,),
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
                                  prefixIcon: Icon(Icons.email_outlined, color: Colors.yellow,)
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
                                  prefixIcon: Icon(Icons.lock_outline , color: Colors.yellow,)
                              ),
                            ),
                            SizedBox(height: 10.h,),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: locationController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Enter Location';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700
                              ),
                              decoration:  InputDecoration(
                                  hintText: 'Address',
                                  //helperText: 'Enter email e.g ijlal@gmail.com',
                                  prefixIcon: const Icon(Icons.home, color: Colors.yellow,),
                                  suffixIcon: GestureDetector(
                                    onTap: (){
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (context) => CurrentLocation()));
                                      locationController.text = '$newlocality, $newDistrict, $newprovice, $newcountry';
                                    },
                                      child: const Icon(Icons.my_location, color: Colors.yellow,)
                                  )
                              ),
                            ),
                            SizedBox(height: 40.h,),

                            RoundButton(title: 'Sign Up',
                              loading: loading,
                              onTap: (){
                                signUp(emailController.text.toString(), passController.text.toString());
                              }, ),

                            SizedBox(height: 15.h,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account ?', style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.w700
                                ),),
                                TextButton(onPressed: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => LoginPageForClient()));
                                },
                                    child: Text('Login here', style: TextStyle(
                                        fontWeight: FontWeight.w700
                                    ),)
                                )
                              ],
                            ),

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
    );
  }
}
