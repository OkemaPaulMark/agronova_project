import 'package:agronova/splash_screen.dart';
import 'package:flutter/material.dart';
import 'diagnosis_page.dart';
import 'home_page.dart';
import 'insights_page.dart';
import 'learn_page.dart';
import 'settings_page.dart';
import 'chat_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';  // or main.dart if DefaultPage is in there
import 'signin_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const SplashScreen(),
    );
  }
}

class DefaultPage extends StatefulWidget {
  final String title;

   const DefaultPage({super.key, this.title = 'Home Page'});

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  int _currentIndex = 0;

  //generate a list of pages for each tab
  final List<Widget> _pages = [
    const HomePage(),
    const DiagnosisPage(),
    const InsightsPage(), 
    const LearnPage(),
    const SettingsPage(),
    ];
  //  const NotificationPage(title: 'Notifications'),
  //  const ProfilesPage(title: 'Profile'),
  //  const SettingsPage(title: 'Settings'),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Colors.green,
      fixedColor: const Color.fromARGB(255, 27, 92, 29),
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,

        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt), 
            label: 'Dianosis'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_down),
            label: 'Insights'),
          BottomNavigationBarItem(
            icon: Icon(Icons.school), 
            label: 'Learn'),
             BottomNavigationBarItem(
            icon: Icon(Icons.settings), 
            label: 'Settings'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        },
        child: const Icon(Icons.chat_bubble, color: Colors.white, size: 30,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return const DefaultPage();
        } else {
          return const SignInScreen();
        }
      },
    );
  }
}


