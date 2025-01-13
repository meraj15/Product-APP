import 'package:flutter/material.dart';
import 'package:product_app/routes/app_routes.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String subText;
  final int index;

  const ProfileListItem({
    super.key,
    required this.icon,
    required this.text,
    required this.subText,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(
            text,
            style:const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subText,
            style:const TextStyle(
              fontSize: 13,
               color: Color(0xff9B9B9B),
            ),
          ),
          trailing:const Icon(Icons.arrow_forward_ios, color: Color(0xff9B9B9B),size: 18,),
          onTap: () {
            switch (index) {
              case  1:
                Navigator.of(context).pushNamed(AppRoutes.myorderScreen);
                break;
                case 2:
                Navigator.of(context).pushNamed(AppRoutes.addressForm);
                break;
                case 4:
                Navigator.of(context).pushNamed(AppRoutes.myallreviews);
              default:
            }
          },
        ),
       const Divider(color: Color(0xff9B9B9B),),
      ],
    );
  }
}
