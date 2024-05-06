import 'package:admin_panel/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'components/header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            // const SizedBox(height: defaultPadding * 3),
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  color: secondaryColor,
                  height: 170,
                ),

                //
                const Positioned(
                  bottom: -40,
                  // left: ,
                  child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _DashTopCard(title: 'Today Check In', svgIcon: 'assets/icons/checkin.svg', count: '22'),
                      _DashTopCard(title: 'Today Check Out', svgIcon: 'assets/icons/checkout.svg', count: '15'),
                      _DashTopCard(title: 'Current Inventory', svgIcon: 'assets/icons/inventory.svg', count: '1584'),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _DashTopCard extends StatelessWidget {
  const _DashTopCard({
    super.key,
    required this.title,
    required this.svgIcon,
    required this.count,
  });

  final String title;
  final String svgIcon;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 5,
      height: 150,
      margin: const EdgeInsets.only(right: 45),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey[400]!, offset: const Offset(1, 1), spreadRadius: 2)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: primaryColor.withOpacity(.5), borderRadius: BorderRadius.circular(15)),
                child: SvgPicture.asset(
                  svgIcon,
                  // color: Colors.white54,
                  colorFilter: ColorFilter.mode(secondaryColor.withOpacity(.7), BlendMode.srcIn),
                  height: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            count,
            style: const TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.w800),
          )
        ],
      ),
    );
  }
}
