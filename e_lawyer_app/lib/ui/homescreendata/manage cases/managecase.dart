import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageCases extends StatefulWidget {
  const ManageCases({Key? key}) : super(key: key);

  @override
  State<ManageCases> createState() => _ManageCasesState();
}

class _ManageCasesState extends State<ManageCases> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('Manage cases'),
        centerTitle: true,
      ),
      body: Center(
        child: Image.asset('assets/images/case-study.png', height: 150.h,),
      ),
    ));
  }
}
