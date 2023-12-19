// import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectins/Screens/login_screens.dart';
import 'package:projectins/resources/auth_methods.dart';
import 'package:projectins/responsive/mobile_layout_screen.dart';
import 'package:projectins/responsive/responsive_layout_screen.dart';
import 'package:projectins/responsive/web_layout_screen.dart';
import 'package:projectins/utils/colors.dart';
import 'package:projectins/utils/utils.dart';
import 'package:projectins/widgets/text_field_input.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({ Key ? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }
  void selectImage() async{
  Uint8List im = await pickImage(ImageSource.gallery);
  setState(() {
    _image = im;
    
  });
  }
  void signUpUser() async{
    setState(() {
      _isLoading = true;
    });
    
    String res= await AuthMethods().signUpUser(
    email: _emailController.text, 
    password: _passwordController.text, 
    username: _usernameController.text, 
    bio: _bioController.text,
    file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if(res =='succes'){
      showSnackBar(res, context);
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:(context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(), 
            
            ), 
            ),
      );
    }
                
  }
  void navigateToLogin(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(), 
              
              ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold( resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: SizedBox(
          height: screenSize.height,
          child: SingleChildScrollView(
        
            child: Container(
              constraints: BoxConstraints(minHeight: screenSize.height),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                
          
                  SvgPicture.asset('assets/ic_instagram.svg', 
                  color: primaryColor, 
                  height: 64,),
                  
          
                  const SizedBox(height: 64),
                  //uc
                  
                   Expanded(
                     child: Stack(
                      children: [
                        _image!=null?CircleAvatar(
                          radius:74 ,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius:74 ,
                          backgroundImage: NetworkImage(
                            'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 90,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                           ),
                           
                        ),
                           
                      ],
                                   ),
                   ),
                  const SizedBox(
                    height: 64,
                  ),
                  TextFeildInput(
                    hintText: 'Enter your username',
                    textInputText: TextInputType.text,
                    textEditingController:_usernameController ,
                  ),
                   const SizedBox(
                    height: 24,
                  ),
          
                  TextFeildInput(
                    hintText: 'Enter your email',
                    textInputText: TextInputType.emailAddress,
                    textEditingController:_emailController ,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFeildInput(
                    hintText: 'Enter your password',
                    textInputText: TextInputType.text,
                    textEditingController:_passwordController ,
                    isPass: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                   TextFeildInput(
                    hintText: 'Enter your bio',
                    textInputText: TextInputType.text,
                    textEditingController:_bioController ,
                    
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  
                  InkWell(
                    onTap: signUpUser,
                  child : Container(
                    child:_isLoading 
                    ? const Center(
                      child:CircularProgressIndicator(
                        color: primaryColor,
                      ),
                      )
                      : const Text('Sign up'),
                    
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ) ,
                      color: blueColor
                      ),
                  ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                 
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: const Text("Don't have an account? "),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                        GestureDetector(
                        onTap: navigateToLogin,
                          child: Container(
                          child: const Text(
                              " Login.",
                              
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ),
          ),
        )
        ),
      //body: Text('From Login Screen'),
    );
  }
}