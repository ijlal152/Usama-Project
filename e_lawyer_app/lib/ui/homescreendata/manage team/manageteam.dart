import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageTeam extends StatefulWidget {
  const ManageTeam({Key? key}) : super(key: key);

  @override
  State<ManageTeam> createState() => _ManageTeamState();
}

class _ManageTeamState extends State<ManageTeam> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('Manage Team'),
        centerTitle: true,
      ),
      body: Center(
        child: Image.asset('assets/images/team.png', height: 150.h,),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            
          }
      ),
    ));
  }
}
