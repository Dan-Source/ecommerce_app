import 'package:ecommerce_app/models/user/user_manager.dart';
import 'package:ecommerce_app/screens/base/base_screen.dart';
import 'package:ecommerce_app/screens/singup/sing_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
        ),
      ],
      child: MaterialApp(
        title: 'Prazeres de Vênus',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/base',
        onGenerateRoute: (settings) {
          switch(settings.name) {
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => const SignUpScreen()
              );
            case '/':
            default:
              return MaterialPageRoute(
                builder: (_) => const BaseScreen()
              );
          }
        },
      ),
    );
  }
}
