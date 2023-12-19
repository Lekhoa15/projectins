import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:projectins/models/post.dart';
import 'package:projectins/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //upload post
  static Future<String> uploadPost({
    required String description,
    required Uint8List file,
    required String uid,
    required String username,
    String profImage = '',
  }) async {
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String res = "some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }
  //deleting post

  Future<void>deletePost(String postId) async{
    try{
     await firestore.collection('posts').doc(postId).delete();
    }catch(err){
      print(err.toString());
    }
  }
  Future<void> followUser(
    String uid,
    String followId,
  ) async{
    try{
      DocumentSnapshot snap = await firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)){
        await firestore.collection('users').doc(followId).update({
          'followers' : FieldValue.arrayRemove([uid])
        });
        await firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayRemove([followId])
        });
      }else{
         await firestore.collection('users').doc(followId).update({
          'followers' : FieldValue.arrayUnion([uid])
        });
        await firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayUnion([followId])
        });

      }
      
        
      
    }catch(e){
      print(e.toString());
    }
  }

}
