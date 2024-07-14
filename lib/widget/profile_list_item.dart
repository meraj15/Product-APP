import 'package:flutter/material.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String subText;

  const ProfileListItem({
    super.key,
    required this.icon,
    required this.text,
    required this.subText,
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
              color: Colors.grey,
            ),
          ),
          trailing:const Icon(Icons.arrow_forward_ios, color: Colors.black),
          onTap: () {},
        ),
       const Divider(),
      ],
    );
  }
}
