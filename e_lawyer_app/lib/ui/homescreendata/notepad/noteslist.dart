import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lawyer_app/ui/Utils.dart';
import 'package:e_lawyer_app/ui/homescreendata/notepad/Add%20notes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleCont.dispose();
    descController.dispose();
  }

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('NotePadData').snapshots();
  CollectionReference reference = FirebaseFirestore.instance.collection('NotePadData');

  final titleCont = TextEditingController();
  final descController = TextEditingController();
  final searchFilter = TextEditingController();

  Future<void> showMyDialog(String title, String desc,String id) async{
    titleCont.text = title;
    descController.text = desc;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Container(
              height: 300.h,
              child: Column(
                children: [
                  TextField(
                    controller: titleCont,
                    decoration: const InputDecoration(
                        hintText: 'Title'
                    ),
                  ),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        hintText: 'Description'
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Cancel')),

              TextButton(onPressed: (){
                Navigator.pop(context);
                reference.doc(id).update({
                  'title' : titleCont.text,
                  'Desc' : descController.text,
                }).then((value) {
                  Utils().toastMessage('Post Updated');
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              }, child: const Text('Update')),

            ],
          );
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
        elevation: 0,
        actions: [

        ],
      ),

      body: Column(
        children: [
          SizedBox(height: 20.h,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder()
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
          ),
          SizedBox(height: 10.h,),

          StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }else if(snapshot.hasError){
                  return const Text('Some error');
                }
                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){

                          return ListTile(
                            onTap: (){
                              showMyDialog(snapshot.data!.docs[index]['title'].toString(), snapshot.data!.docs[index]['Desc'].toString(), snapshot.data!.docs[index]['id'].toString(),);
                              //showMyDialog(snapshot.data!.docs[index]['title'].toString(), snapshot.data!.docs[index]['Desc'].toString());
                            },
                            title: Text(snapshot.data!.docs[index]['title'].toString(), style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),),
                            subtitle: Text(snapshot.data!.docs[index]['Desc'].toString()),
                            trailing: Icon(Icons.more_vert),
                          );
                        })
                );

              }
          ),

        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotes()));
      }),
    ));
  }
}
