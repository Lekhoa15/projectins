import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectins/models/user.dart';
import 'package:projectins/providers/user_provider.dart';
import 'package:projectins/resources/firestore_methods.dart';
import 'package:projectins/resources/storage_methods.dart';
import 'package:projectins/utils/colors.dart';
import 'package:projectins/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isloading = false;

  postImage(
    String uid,
    String username,
    Uint8List profImage,
  ) async {
    setState(() {
      _isloading = true;
    });
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', profImage, false);
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'photoUrl': photoUrl});
      setState(() {
        _isloading = false;
        clearImage();
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                  Navigator.of(dialogContext).pop();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );

                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  User? user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user != null && user!.photoUrl != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    user!.photoUrl!,
                  ),
                ),
              Center(
                child: IconButton(
                  icon: const Icon(Icons.upload),
                  onPressed: () => _selectImage(context),
                ),
              ),
            ],
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () async {
                    FirestoreMethods.uploadPost(
                        description: _descriptionController.text,
                        file: _file!,
                        uid: user!.uid,
                        username: user!.username,
                        profImage: user!.photoUrl!);
                    if (_file != null) {
                      await postImage(
                        user!.uid,
                        user!.username,
                        _file!,
                      );
                      print('user: ${user!.toJson()}');

                      setState(() {
                        refreshData();
                        print('userUpdate: ${user!.toJson()} ');
                      });
                    } else {
                      print("erro");
                    }
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  if (user != null && user!.photoUrl != null) showImage(user!),
                  _isloading
                      ? const LinearProgressIndicator()
                      : const Padding(
                          padding: EdgeInsets.only(top: 0),
                        ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Write a caption...',
                            border: InputBorder.none,
                          ),
                          maxLines: 8,
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            )),
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  Widget showImage(User user) {
    print('Image : ${user.photoUrl}');
    return Image.network(user.photoUrl!);
  }

  refreshData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }
}
