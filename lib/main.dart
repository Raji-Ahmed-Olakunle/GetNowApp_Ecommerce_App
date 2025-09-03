import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:getnowshopapp/Providers/ModeProvider.dart';

//import 'Providers/routerprovider.dart';
import 'FeatureMigrated/router/router_provider.dart';
import 'core/utils/ModeProvider.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // name: 'secondaryApp',
    options: DefaultFirebaseOptions.currentPlatform,
    //   options: FirebaseOptions(
    //     apiKey: 'AIzaSyA-nuA6bnChNsNVgfJ6RecmlySG95WDED4',
    //     appId: '1:234310655964:android:d14229ed89a15deed37919',
    //     messagingSenderId: '234310655964',
    //     projectId: 'brew-crew-88205',
    //   ),
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp();

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // GoRouter? _router;
  //
  // @override
  // void initState() {
  //   _router = GoRouter(
  //     redirect: (context, state) {
  //       final Auth = ref.watch(AuthNotifier).value;
  //       final bool? isTokenValid = Auth?.expiryDate?.isAfter(DateTime.now());
  //
  //       if (Auth?.token == null) {
  //         return '/AuthScreen';
  //       }
  //       if (Auth?.token != null && isTokenValid!) {
  //         return '/HomeScreen';
  //       }
  //     },
  //
  //     routes: [
  //       GoRoute(
  //         name: 'AuthScreen',
  //         path: '/AuthScreen',
  //         builder: (context, state) => Authscreen(),
  //       ),
  //       GoRoute(
  //         name: 'HomeScreen',
  //         path: '/HomeScreen',
  //         builder: (context, state) => HomePage(),
  //       ),
  //       GoRoute(
  //         name: 'CartScreen',
  //         path: '/CartScreen',
  //         builder: (context, state) => CartScreen(),
  //       ),
  //       GoRoute(
  //         name: 'productDetailScreen',
  //
  //         path: '/productDetailScreen/:prodId',
  //         builder: (context, state) => ProductsDetailScreen(),
  //       ),
  //
  //       GoRoute(
  //         name: 'OrderScreen',
  //         path: '/OrderScreen',
  //         builder: (context, state) => OrderScreen(),
  //       ),
  //       GoRoute(
  //         name: 'UserPrdouctScreen',
  //         path: '/UserProductScreen',
  //         builder: (context, state) => Userproductscreen(),
  //       ),
  //       GoRoute(path: '/AuthScreen', builder: (context, state) => Authscreen()),
  //       GoRoute(
  //         name: 'ForgetPasswordScreen',
  //         path: '/ForgetPasswordScreen',
  //         builder: (context, state) => Forgetpassword(),
  //       ),
  //       GoRoute(
  //         name: 'ShowMoreScreen',
  //         path: '/ShowMoreScreen/:ForType/:Title',
  //
  //         builder: (context, state) {
  //           //String
  //           return Showmorescreen();
  //         },
  //       ),
  //       GoRoute(
  //         name: 'OnBoardScreen',
  //         path: '/OnBoardScreen',
  //         builder: (context, state) => OnBoardScreen(),
  //       ),
  //     ],
  //   );
  //   super.initState();
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _router = ref.watch(routerProvider);
    final LigthColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF7B61FF),
      onPrimary: Colors.white,
      secondary: Color(0xFFF1Edff),
      onSecondary: Colors.black,
      error: Colors.red.shade700,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black87,
    );
    final DarkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF9cc88ff),
      onPrimary: Colors.black,
      secondary: Color(0xFF2b2540),
      onSecondary: Colors.white,
      error: Colors.red.shade300,
      onError: Colors.black,
      surface: Color(0xff2c2840),
      onSurface: Colors.white70,
    );
    ThemeData lightTheme = ThemeData(
      // scaffoldBackgroundColor: Color(0xFFFF6F61),
      useMaterial3: true,
      colorScheme: LigthColorScheme,
    );
    ThemeData darkTheme = ThemeData(
      // scaffoldBackgroundColor: Color(0xFF1F1F1F),
      useMaterial3: true,
      colorScheme: DarkColorScheme,
    );

    return MaterialApp.router(
      routerConfig: _router,
      theme: lightTheme,
      darkTheme: darkTheme,

      themeMode:
          ref.watch(ModeProvider).value! ? ThemeMode.light : ThemeMode.dark,

      // routes: {
      //   '/HomeScreen': (ctx) => HomePage(),
      //   '/CartScreen': (ctx) => CartScreen(),
      //   '/productDetailScreen': (ctx) => ProductsDetailScreen(),
      //   '/OrderScreen': (ctx) => OrderScreen(),
      //   '/UserProductScreen': (ctx) => Userproductscreen(),
      //   '/AuthScreen': (ctx) => Authscreen(),
      //   '/ForgetPasswordScreen': (ctx) => Forgetpassword(),
      //   '/ShowMoreScreen': (ctx) => Showmorescreen('Latest Product', "Latest"),
      //   '/OnBoardScreen': (ctx) => OnBoardScreen(),
      // },
      title: 'Flutter Demo',
      // theme: ThemeData(
      //  fontFamily: 'Lato',
      //  primarySwatch:Colors.purple,//MaterialColor(Colors.blue as int, Colors.deepOrange as Map<int, Color>) ,
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      // home: ref
      //     .watch(AuthNotifier)
      //     .when(
      //       data:
      //           (auth) =>
      //               //Homeshimmer()
      //               //   OnBoardScreen()
      //               auth.token != null ? HomePage() : Authscreen(),
      //       //    HomePage()
      //       error: (e, st) {
      //         print(e);
      //       },
      //       loading:
      //           () =>
      //               Scaffold(body: Center(child: CircularProgressIndicator())),
      //     ),
      // ref.read(AuthNotifier).value?.token!=null?HomePage():Authscreen(),
    );
  }
}
