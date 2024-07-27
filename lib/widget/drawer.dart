import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/routes/app_routes.dart';

class DrawerWidget extends StatelessWidget {
  final double avatarRadius = 60;

  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 228,
            width: double.infinity,
            decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     AppColor.appMainColor,
                //     Color.fromARGB(255, 224, 79, 66)
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                color: AppColor.appMainColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 37),
                SizedBox(
                  height: 130,
                  child: Image.asset("assets/profile.png"),
                ),
                const Text(
                  "Khan Meraj",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "khanmeraj1542005@gmail.com",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
               const SizedBox(
                  height: 7,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                createDrawerItem(
                  icon: Icons.home,
                  text: 'Home',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.initialRoute);
                  },
                ),
                createDrawerItem(
                  icon: Icons.shopping_cart,
                  text: 'My Cart',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.addCardScreen);
                  },
                ),
                createDrawerItem(
                  icon: Icons.favorite,
                  text: 'Favorites',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.favoriteScreen);
                  },
                ),
                createDrawerItem(
                  icon: Icons.history,
                  text: 'Order History',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.profileScreen);
                  },
                ),
                createDrawerItem(
                  icon: Icons.person,
                  text: 'Profile',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.profileScreen);
                  },
                ),
                createDrawerItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.profileScreen);
                  },
                ),
                const Divider(),
                createDrawerItem(
                  icon: Icons.help,
                  text: 'Help & Support',
                  onTap: () {
                    Navigator.of(context).pushNamed('/help-support');
                  },
                ),
                createDrawerItem(
                  icon: Icons.logout,
                  text: 'Logout',
                  onTap: () {
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
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColor.appMainColor,
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
