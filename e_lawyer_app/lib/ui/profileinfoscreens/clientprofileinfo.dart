import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lawyer_app/ui/UserModel/clientModel.dart';
import 'package:e_lawyer_app/ui/Utils.dart';
import 'package:e_lawyer_app/ui/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ClientProfileInfo extends StatefulWidget {
  const ClientProfileInfo({Key? key}) : super(key: key);

  @override
  State<ClientProfileInfo> createState() => _ClientProfileInfoState();
}

class _ClientProfileInfoState extends State<ClientProfileInfo> {

  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  ClientModel loggedInUser = ClientModel();

  final firestore = FirebaseFirestore.instance.collection('users');
  final firestoreInstance = FirebaseFirestore.instance.collection('users').doc();
  CollectionReference reference = FirebaseFirestore.instance.collection('users');
  //User? user = auth.currentUser;


  // update record
  UpdateRecord(String name, String cnic, String address, String id) async{
    nameController.text = name;
    cnicController.text = cnic;
    addressController.text = address;

    print(id);

    reference.doc(id).update({
      'c_FullName' : nameController.text,
      'c_CNIC' : cnicController.text,
      'c_ProfilePic' : imagepath,
      'c_Address' : addressController.text
    }).then((value) {
      Utils().toastMessage('Post Updated');
    }).onError((error, stackTrace) {
      Utils().toastMessage('Could not update record');
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = ClientModel.fromMap(value.data());
      setState(() {
        //fullname = loggedInUser.c_fullname.toString();
      });
      nameController.text = loggedInUser.c_fullname.toString();
      cnicController.text = loggedInUser.c_cnic.toString();
      addressController.text = loggedInUser.c_address.toString();
      imagepath = loggedInUser.c_profilepic.toString();

    });
  }

  // form key
  final formkey = GlobalKey<FormState>();

  // controllers
  final nameController = TextEditingController();
  final cnicController = TextEditingController();
  final addressController = TextEditingController();

  String? imagepath;
  File? _image;

  Future _imgFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this._image = imageTemp);

      final bytes = await io.File(image.path).readAsBytes();
      imagepath = base64Encode(bytes);
      print(imagepath);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
    // }

  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                   ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      //_imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget showImage(BuildContext context) {
    return Container(
      //height: 300,
      width: 110.w,
      height: 110.h,
      decoration: BoxDecoration(
          image:
          DecorationImage(image: MemoryImage(base64Decode(imagepath!),), fit: BoxFit.cover)
      ),
      //child: Text('Image'),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('Client Info'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                      ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(55.r)
                        )
                        //borderRadius: BorderRadius.circular(55.r)
                    ),
                    child: GestureDetector(
                      onTap: (){
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 55.r,
                        child: _image != null ?ClipOval(
                          child: Image.file(_image!,width: 110.w, height: 110.h, fit: BoxFit.cover),
                        ) : Container(
                          width: 110.w,
                          height: 110.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: CircleAvatar(
                            radius: 55.r,
                            backgroundImage: MemoryImage(base64Decode(imagepath!)),
                          ),
                          //child: Image.asset('assets/images/pic.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  TextFormField(
                    controller: nameController,
                    style: TextStyle(),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Name required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      suffixIcon: Icon(Icons.edit),
                      labelText: 'Full name',
                      fillColor: Colors.white70,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  TextFormField(
                    controller: cnicController,
                    style: TextStyle(),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'CNIC required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      suffixIcon: Icon(Icons.edit),
                      labelText: 'CNIC',
                      fillColor: Colors.white70,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  TextFormField(
                    controller: addressController,
                    style: TextStyle(),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Address required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      suffixIcon: Icon(Icons.edit),
                      labelText: 'Address',
                      fillColor: Colors.white70,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 25.h,),
                  RoundButton(
                      title: 'Update Record',
                      onTap: (){
                        UpdateRecord(
                            nameController.text,
                            cnicController.text,
                            addressController.text,
                            user!.uid
                        );
                      },
                      loading: false
                  )
                ],
              ),
            ),
          )
      ),

    ));
  }
}
