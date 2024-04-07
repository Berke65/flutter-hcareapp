import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcareapp/main.dart';


class UserTile extends StatelessWidget {
  final String text;
  final String txt;
  final ImageProvider<Object>? imageProvider;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.txt,
    required this.onTap,
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 17),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: imageProvider,
              child: const Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                  )
                ],
              ),
            ),
            const SizedBox(width: 10,),
            Column(
              children: [
                Text(
                  text,
                  style: GoogleFonts.tauri(
                    textStyle: const TextStyle(color: Colors.black, letterSpacing: .5,fontWeight: FontWeight.bold),
                  ),
                ),
                Text(txt,
                  style: GoogleFonts.tauri(
                    textStyle: const TextStyle(color: Colors.black, letterSpacing: .5, fontSize: 15),
                  ),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}
