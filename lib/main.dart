import 'package:ecommerce_app/models/cart/cart_manager.dart';
import 'package:ecommerce_app/models/product/product.dart';
import 'package:ecommerce_app/models/product/product_manager.dart';
import 'package:ecommerce_app/models/user/user_manager.dart';
import 'package:ecommerce_app/screens/base/base_screen.dart';
import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/screens/login/login_screen.dart';
import 'package:ecommerce_app/screens/product/product_screen.dart';
import 'package:ecommerce_app/screens/singup/sing_up.dart';
import 'package:ecommerce_app/screens/products/products_screen.dart';
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
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager!..updateUser(userManager),
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
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch(settings.name) {
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => const SignUpScreen(),
              );
            case '/login':
              return MaterialPageRoute(
                builder: (_) => LoginScreen()
              );
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CartScreen()
              );
            case '/product':
              return MaterialPageRoute(
                builder: (_) => ProductScreen(settings.arguments as Product),
              );
            case '/':
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
              );
          }
        },
      ),
    );
  }
}
