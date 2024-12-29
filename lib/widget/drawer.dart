import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            decoration:  BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Theme.of(context).colorScheme.primary,
                //     Color.fromARGB(255, 224, 79, 66)
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                color: Theme.of(context).colorScheme.primary),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 37),
                SizedBox(
                  height: 130,
                  child: Image.asset("assets/images/profile.png"),
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
                  context: context,

                  text: 'Home',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.initialRoute);
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
                  icon: Icons.history,
                  context: context,

                  text: 'Order History',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.profileScreen);
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
                createDrawerItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  context: context,

                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.profileScreen);
                  },
                ),
                const Divider(),
                createDrawerItem(
                  icon: Icons.help,
                  context: context,

                  text: 'Help & Support',
                  onTap: () {
                    Navigator.of(context).pushNamed('/help-support');
                  },
                ),
                createDrawerItem(
                  icon: Icons.logout,
                  context: context,
                  text: 'Logout',
                  onTap: ()async {
                         isLogged = false;
  final SharedPreferences logged = await SharedPreferences.getInstance();
  logged.setBool("logged", isLogged);
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
