import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
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
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 17),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.person_outline),
            const SizedBox(width: 20,),
            Text(
              text,
              style: GoogleFonts.tauri(
                textStyle: TextStyle(color: Colors.black, letterSpacing: .5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
