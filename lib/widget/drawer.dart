import 'package:flutter/material.dart';
import 'package:product_app/Auth/auth_service.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getUserDetail(userID);
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.watch<ProductData>();
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 228,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    const Color.fromARGB(255, 216, 91, 79)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                color: Theme.of(context).colorScheme.primary),
             child: providerRead.userDetails.isNotEmpty
    ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 37),
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                providerRead.getInitials(
                  (providerRead.userDetails.isNotEmpty && providerRead.userDetails.first.containsKey("name"))
                      ? providerRead.userDetails.first["name"] ?? "A"
                      : "A",
                ),
                style: TextStyle(
                  fontSize: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            (providerRead.userDetails.isNotEmpty && providerRead.userDetails.first.containsKey("name"))
                ? providerRead.userDetails.first["name"] ?? "Anonymous"
                : "Anonymous",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Text(
            (providerRead.userDetails.isNotEmpty && providerRead.userDetails.first.containsKey("email"))
                ? providerRead.userDetails.first["email"] ?? "No Email"
                : "No Email",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 7,
          ),
        ],
      )
    : const Center(
        child: CircularProgressIndicator(color: AppColor.whiteColor),
      ),

          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                createDrawerItem(
                  icon: Icons.home,
                  context: context,
                  text: 'Home',
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.bottemNavigationBar);
                  },
                ),
                createDrawerItem(
                  icon: Icons.shopping_cart,
                  context: context,
                  text: 'My Orders',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.myorderScreen);
                  },
                ),
                createDrawerItem(
                  icon: Icons.favorite,
                  context: context,
                  text: 'Favorites',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.favoriteScreen);
                  },
                ),
                createDrawerItem(
                  icon: Icons.person,
                  context: context,
                  text: 'Profile',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.profileScreen);
                  },
                ),
                const Divider(),
                createDrawerItem(
                  icon: Icons.logout,
                  context: context,
                  text: 'Logout',
                  onTap: () async {
                    await AuthService.logout();

                    Navigator.of(context).pushNamed("/");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback? onTap,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
