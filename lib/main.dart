import 'package:birdhelp/acceuil_page.dart';
import 'package:birdhelp/google_sign_in.dart';
import 'package:birdhelp/home_page.dart';
import 'package:birdhelp/login_page.dart';
import 'package:birdhelp/signup_page.dart';
import 'package:birdhelp/utils.dart';
import 'package:birdhelp/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    //Permet de recevoir tout les material et y accéder comme le theme etc..
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: RootPage(),
    )
    );

  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  static bool isGoogleUser = false;
  int currentPage = 0;

  List<Widget> pages = const [
    HomePage(),
    AcceuilPage(),
    SignUpPage(),
    VerifyEmailPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasError){
            return Center(child:Text("Something went wrong"),);
          }
          else if(snapshot.hasData){
            return VerifyEmailPage();
          }else{
            return HomePage();
          }
        },
      ),
    );
  }
}
