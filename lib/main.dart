  import 'package:firebase_core/firebase_core.dart';
  import 'package:flutter/material.dart';
  import 'package:mis_lab_2/screens/favorite_meals_screen.dart';

  import 'package:mis_lab_2/screens/home.dart';
  import 'package:mis_lab_2/screens/category_screen.dart';
  import 'package:mis_lab_2/screens/meal_screen.dart';
  import 'package:mis_lab_2/services/notification_service.dart';

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> main() async{
    // Firebase
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();//options: DefaultFirebaseOptions.currentPlatform,);
    await NotificationService().initFCM();

    // Local notifications
    NotificationService.navigatorKey = navigatorKey;

    NotificationService.initialize();

    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0x8DAB7F),
            dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
          ),
        ),
        navigatorKey: navigatorKey,
        initialRoute: "/",
        routes: {
          "/" : (context) => const HomePage(name: "Food App",),
          "/category" : (context) => const CategoryPage(),
          "/meal" : (context) => const MealPage(),
          "/favorites" : (context) => const FavoriteMealsPage(),
        },
      );
    }
  }