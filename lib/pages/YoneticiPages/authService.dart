import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart'; // Ekleme

class AuthService {
// kullanılmıyor silinecek
  Future<void> addDropdownValuesToFirestore({
    required BuildContext context,
    required String selectedNurse,
    required String selectedSick,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('dropdown_values').add({
        'selectedNurse': selectedNurse,
        'selectedSick': selectedSick,
      });
      print('Dropdown değerleri Firestore\'a başarıyla eklendi');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'), // const kaldırıldı
        ),
      );
    }
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}