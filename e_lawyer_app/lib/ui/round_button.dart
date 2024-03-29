import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap ;
  final bool loading;
  const RoundButton({
    Key? key, required this.title,
    required this.onTap,
    required this.loading
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: loading ? const CircularProgressIndicator(strokeWidth: 3, color: Colors.white,) : Text(title, style: const TextStyle(
            color: Colors.black,
            fontSize: 17
          ),) ,
        )
      ),
    );
  }
}
