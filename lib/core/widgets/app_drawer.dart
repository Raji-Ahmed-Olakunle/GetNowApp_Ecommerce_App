import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../FeatureMigrated/auth/presentation/viewmodels/auth_provider.dart';
import '../../FeatureMigrated/profile/presentation/viewmodels/profile_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final auth = ref.watch(authProvider.notifier);
    return Drawer(
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.none,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.grey),
            child: Center(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child:
                          profile.value?.imageUrl != null &&
                                  profile.value!.imageUrl!.isNotEmpty
                              ? Image.network(profile.value!.imageUrl!)
                              : const Icon(Icons.person, size: 50),
                    ),
                    Text(
                      profile.value?.name ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text("Shop"),
            leading: const Icon(Icons.shop),
            onTap: () {
              GoRouter.of(context).pushNamed("HomeScreen");
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Orders"),
            leading: const Icon(Icons.payment),
            onTap: () {
              GoRouter.of(context).pushNamed("OrderScreen");
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Manage"),
            leading: const Icon(Icons.add_business),
            onTap: () {
              GoRouter.of(context).pushNamed("UserProductScreen");
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Log Out"),
            leading: const Icon(Icons.exit_to_app_outlined),
            onTap: () {
              GoRouter.of(context).pushNamed("AuthScreen");
              auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
