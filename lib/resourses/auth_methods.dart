import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/users_model.dart' as model;
import 'package:instagram_clone/resourses/storage_methods.dart';

class AuthMethods {
  // SignUp Function
  Future signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // register user
        UserCredential cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadIamgeToStorage('profilePics', file, false);

        // add user to database
        // model.User user = model.User(
        //   username: username,
        //   uid: cred.user!.uid,
        //   email: email,
        //   bio: bio,
        //   photoUrl: photoUrl,
        //   followers: [],
        //   following: [],
        // );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'photoUrl': photoUrl,
          'bio': bio,
          'followers': [],
          'following': [],
        });

        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The emailis badly formatted';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Login User
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error Occured';
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
