// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String email;
  final String uid;
  final String? photoUrl;
  final String username;
  final String? bio;
  final List? followers;
  final List? following;
  
  const User({
   required this.email,
   required this.uid,
    this.photoUrl,
   required this.username,
   this.bio,
    this.followers,
    this.following,

  });
  Map<String, dynamic> toJson() =>{
   "username" : username,
   "uid" : uid,
   "email" : email,
   "photoUrl" : photoUrl,
   "bio"  : bio,
   "followers" : followers,
   "following" : following,
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],

    );
  }
}