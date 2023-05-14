import 'package:flutter/material.dart';

class DrawerLinks extends StatelessWidget {
  final String? title;
  final Widget? icon;
  final bool isLogout;
  final Widget onTapWidget;

  const DrawerLinks(
      {super.key,
      required this.title,
      required this.icon,
      required this.isLogout,
      required this.onTapWidget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>onTapWidget));
      },
      child: Container(
          height: 50,
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: icon,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        title!,
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.yellowAccent,
              )
            ],
          )),
    );
  }
}
