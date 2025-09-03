import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatelessWidget {
  final BuildContext ctx;
  final int index;

  const BottomBar(this.index, this.ctx, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedIndex = index;
    List<String> screens = [
      'HomeScreen',
      'CartScreen',
      'OrderScreen',
      'UserPrdouctScreen',
    ];
    void onTapItemSubmit(int idx) {
      ctx.goNamed(screens[idx]);
    }

    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,

      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Carts',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Orders'),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_business),
          label: 'Menage',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onTapItemSubmit,
    );
  }
}
