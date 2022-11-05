import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lawyer_app/ui/Utils.dart';
import 'package:e_lawyer_app/ui/round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {

  bool loading = false;
  final titleController = TextEditingController();
  final postController = TextEditingController();

  final firestore = FirebaseFirestore.instance.collection('NotePadData');


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('Add Notes'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 30.h,),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 15.h,),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: const InputDecoration(
                  hintText: 'Add description',
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(
              title: 'Add Notes',
              onTap: (){
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                firestore.doc(id).set({
                  'title' : titleController.text.toString(),
                  'Desc' : postController.text.toString(),
                  'id' : id
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  titleController.clear();
                  postController.clear();
                  Utils().toastMessage('Data added');
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              },
              loading: loading,
            ),
          ],
        ),
      ),
    ));
  }
}
