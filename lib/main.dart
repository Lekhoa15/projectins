import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projectins/Screens/login_screens.dart';
import 'package:projectins/Screens/signup_screens.dart';
import 'package:projectins/providers/user_provider.dart';
import 'package:projectins/responsive/mobile_layout_screen.dart';
import 'package:projectins/responsive/responsive_layout_screen.dart';
import 'package:projectins/responsive/web_layout_screen.dart';
import 'package:projectins/utils/colors.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
  await Firebase.initializeApp(
    options: const FirebaseOptions(
     apiKey: "AIzaSyApKYJLPMpDt8OCndWuP0MvqT3VZLAIDtg",
    // authDomain: "instagram-tu-f0742.firebaseapp.com",
    projectId: "instagram-tu-f0742",
    storageBucket: "instagram-tu-f0742.appspot.com",
    messagingSenderId: "53665440944",
    appId: "1:53665440944:web:c40e5455f46b66d8fa8775"
      ),
  );
  } else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
          ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
     
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              return const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(), 
                
                );
            } else if(snapshot.hasError){
                return Center(
                  child: Text('${snapshot.error}'),
    
                );
              
            }
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              )
            );
          }
    
          return const LoginScreen();
        },
       ),
      
      ),
    );
  }
}

