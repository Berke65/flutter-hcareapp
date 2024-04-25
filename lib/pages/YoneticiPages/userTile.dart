import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String txt;
  final String roleTxt;
  final ImageProvider<Object>? imageProvider;
  final void Function()? onTap;

  const UserTile({
    Key? key,
    required this.text,
    required this.roleTxt,
    required this.txt,
    required this.onTap,
    required this.imageProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 17),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: imageProvider,
              child: imageProvider == null ? const Icon(Icons.person) : null, //default yerine ikon koyma ama çalışmıyor çok mantı
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: GoogleFonts.tauri(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      letterSpacing: .5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  txt,
                  style: GoogleFonts.tauri(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      letterSpacing: .5,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  roleTxt,

                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
