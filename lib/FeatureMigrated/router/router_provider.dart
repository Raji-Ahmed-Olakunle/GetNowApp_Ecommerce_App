import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/auth/presentation/views/auth_screen.dart';
import 'package:getnowshopapp/FeatureMigrated/cart/presentation/views/cart_screen.dart';
import 'package:getnowshopapp/FeatureMigrated/onboarding/presentation/views/onboard_screen.dart';
import 'package:getnowshopapp/FeatureMigrated/orders/presentation/views/order_screen.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/views/product_detail_screen.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/views/show_more_screen.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/views/user_product_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/presentation/viewmodels/auth_provider.dart';
import '../auth/presentation/views/forget_password_screen.dart';
import '../products/presentation/views/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    redirect: (context, state) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool('isFirstTimeUser') ?? true;
      final auth = await ref.watch(authProvider.notifier).fetchAuthDetails();
      print(auth);
      final isTokenValid =
          auth != null
              ? auth?.expiryDate?.isAfter(DateTime.now()) ?? false
              : false;
      print(auth?.id);
      print(auth?.expiryDate);
      print(auth?.token);
      final bool isLoggedIn = auth?.token != null && isTokenValid;
      //  final isAuthScreen = state.fullPath == '/HomeScreen';

      final isAuthScreen = state.fullPath == '/AuthScreen';
      print(isLoggedIn);
      print(isAuthScreen);
      print(state.fullPath);
      // If not logged in, send to Auth
      bool firstTime = true;
      if (!isLoggedIn && !isAuthScreen) {
        if (isFirstTime) {
          return '/onBoardScreen';
        }
        return '/AuthScreen';
      }
      // if (isLoggedIn && state.fullPath == null) return '/AuthScreen';

      // If logged in and trying to go to auth, send them to home
      if (isLoggedIn && !isAuthScreen) {
        if (state.fullPath!.isEmpty) {
          return '/HomeScreen';
        }

        // if (state.fullPath != 'HomeScreen') {
        //   print('gg');
        //   return null;
        // }
      }
      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        name: 'AuthScreen',
        path: '/AuthScreen',
        builder: (context, state) => Authscreen(),
      ),
      GoRoute(
        name: 'HomeScreen',
        path: '/HomeScreen',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        name: 'CartScreen',
        path: '/CartScreen',
        builder: (context, state) => CartScreen(),
      ),
      GoRoute(
        name: 'onBoardScreen',
        path: '/onBoardScreen',
        builder: (context, state) {
          return OnBoardScreen();
        },
      ),
      GoRoute(
        name: 'productDetailScreen',
        path: '/productDetailScreen/:prodId',
        builder: (context, state) {
          return ProductsDetailScreen();
        },
      ),
      GoRoute(
        name: 'OrderScreen',
        path: '/OrderScreen',
        builder: (context, state) => OrderScreen(),
      ),
      GoRoute(
        name: 'UserPrdouctScreen',
        path: '/UserProductScreen',
        builder: (context, state) => Userproductscreen(),
      ),
      GoRoute(
        name: 'ForgetPasswordScreen',
        path: '/ForgetPasswordScreen',
        builder: (context, state) => ForgetPasswordScreen(),
      ),
      GoRoute(
        name: 'ShowMoreScreen',
        path: '/ShowMoreScreen/:ForType/:Title',
        builder: (context, state) => Showmorescreen(),
      ),
      GoRoute(
        name: 'OnBoardScreen',
        path: '/OnBoardScreen',
        builder: (context, state) => OnBoardScreen(),
      ),
    ],
  );
});
