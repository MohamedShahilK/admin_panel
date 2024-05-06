import 'package:admin_panel/constants.dart';
import 'package:admin_panel/controllers/MenuController.dart';
import 'package:admin_panel/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: const Icon(Icons.menu, color: secondaryColor),
              onPressed: context.read<CustomMenuController>().controlMenu,
            ),
          if (!Responsive.isMobile(context))
            Text(
              "Dashboard",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          if (!Responsive.isMobile(context))
            Spacer(
              flex: Responsive.isDesktop(context) ? 2 : 1,
            ),
          // const Expanded(
          //   child:  SearchField(),
          // ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(100),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: badges.Badge(
                badgeContent: const Text(
                  '54',
                  softWrap: true,
                  style: TextStyle(fontSize: 10),
                ),
                badgeStyle: const badges.BadgeStyle(badgeColor: primaryColor),
                child: SvgPicture.asset(
                  'assets/icons/notification.svg',
                  colorFilter: const ColorFilter.mode(secondaryColor, BlendMode.srcIn),
                  width: 25,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(100),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: badges.Badge(
                badgeContent: const Text(
                  '10',
                  softWrap: true,
                  style: TextStyle(fontSize: 10),
                ),
                badgeStyle: const badges.BadgeStyle(badgeColor: primaryColor),
                child: SvgPicture.asset(
                  'assets/icons/car_ontheway.svg',
                  colorFilter: const ColorFilter.mode(secondaryColor, BlendMode.srcIn),
                  width: 25,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const ProfileCard(),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          // Image.asset(
          //   "assets/images/profile_pic.png",
          //   height: 38,
          // ),
          Container(
            height: 38,
            width: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage("assets/images/avatar.jpg"), fit: BoxFit.cover),
            ),
          ),
          if (!Responsive.isMobile(context))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text("Angelina Joli"),
            ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
