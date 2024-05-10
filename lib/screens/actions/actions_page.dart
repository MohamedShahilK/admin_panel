import 'package:admin_panel/screens/actions/widgets/action_top_card.dart';
import 'package:admin_panel/screens/dashboard/components/header.dart';
import 'package:flutter/material.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({
    super.key,
  });

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  // var isLoading = true;

  // @override
  // void didChangeDependencies() {
  //   customLoader(context);
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     Future.delayed(
  //       const Duration(milliseconds: 300),
  //       () => setState(() {
  //         isLoading = false;
  //         Loader.hide();
  //       }),
  //     );
  //   });
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Stack(
        children: [
          //
          ActionTopCard(title: 'title', count: 'count', icon: Icons.abc, color: Colors.red),

          // Header
          Header(),
        ],
      ),
    );
  }
}
