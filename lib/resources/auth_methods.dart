
// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectins/models/user.dart' as model;
import 'package:projectins/resources/storage_methods.dart';
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future <model.User> getUserDetails() async{
  User currentUser = _auth.currentUser!;
  DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
  print('snap: ${model.User.fromSnap(snap).toJson()}');
  return model.User.fromSnap(snap) ;
}

  Future<String> signUpUser({
    required String email ,
    required String password,
    required String username , 
    required String bio,
    required Uint8List file,
  }) async{
    String res = "Some error occurred";
    try{
      if(email.isNotEmpty || password.isNotEmpty ||username.isNotEmpty||bio.isNotEmpty){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print(cred.user!.uid);

     String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);
      
      model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            photoUrl: photoUrl,
            following: [],
            followers: [],
      );

      await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);
         
      
      
       res ='success';
      }

    } 
    catch(err){
      res = err.toString();
    }
    return res;

  }
  //logging in user
  Future<String> loginUser({
    required String email,
    required String password

  })async{
    String res ="Some error occurred";
    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";

      }else{
        res = "Please enter all the feilds";
      }

    }catch(err){
      // res = err.toString();
    }
    return res;
  }
  Future<void> signOut() async{
   await _auth.signOut();
  }
}