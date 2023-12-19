import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectins/Screens/add_post_screen.dart';
import 'package:projectins/Screens/feed_screen.dart';
import 'package:projectins/Screens/profile_screen.dart';
import 'package:projectins/Screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notif'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser?.uid ?? '', // Provide a default value if currentUser is null
  ),
];
