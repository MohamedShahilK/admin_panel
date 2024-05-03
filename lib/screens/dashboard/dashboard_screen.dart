import 'package:admin_panel/constants.dart';
import 'package:admin_panel/responsive.dart';
import 'package:flutter/material.dart';
import 'components/MyField.dart';
import 'components/header.dart';
import 'components/recent_Files.dart';
import 'components/storage_Details.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(children: [
          const Header(),
          const SizedBox(height: defaultPadding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    const MyField(),
                    const SizedBox(height: defaultPadding),
                    const RecentFiles(),
                    if (Responsive.isMobile(context)) const SizedBox(height: defaultPadding),
                    if (Responsive.isMobile(context)) const StorageDetails(),
                  ],
                ),
              ),
              if (!Responsive.isMobile(context)) const SizedBox(width: defaultPadding),
              if (!Responsive.isMobile(context))
                const Expanded(
                  flex: 2,
                  child: StorageDetails(),
                ),
            ],
          ),
        ]),
      ),
    );
  }
}
