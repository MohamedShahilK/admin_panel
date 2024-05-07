import 'package:admin_panel/screens/dashboard/components/header.dart';
import 'package:admin_panel/utils/custom_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({
    super.key,
  });

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  var isLoading = true;

  @override
  void didChangeDependencies() {
    customLoader(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () => setState(() {
          isLoading = false;
          Loader.hide();
        }),
      );
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        // padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            // const SizedBox(height: defaultPadding * 3),
          ],
        ),
      ),
    );
  }
}
