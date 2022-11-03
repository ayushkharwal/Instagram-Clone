import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StorageMethods {
  // Adding image to firebase Storage
  Future<String> uploadIamgeToStorage(
    String childName,
    Uint8List file,
    bool isPost,
  ) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(childName)
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask.snapshot;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
