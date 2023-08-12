import 'package:flutter/material.dart';
import 'package:todoaholic/components/app_drawer.dart';
import '../constants.dart';

class ScaffoldWrapper extends StatelessWidget {
  final String title;
  final AppBar? appBar;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool? resizeToAvoidBottomInset;

  const ScaffoldWrapper({
    Key? key,
    required this.title,
    this.appBar,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool hideTrailingIcon = screenWidth < drawerBreakPoint ? false : true;

    AppBar appBar = this.appBar ??
        AppBar(
          title: Align(
            alignment: Alignment.topCenter,
            child: Text(title),
          ),
          actions: actions,
          leading: hideTrailingIcon ? const SizedBox.shrink() : null,
        );

    if (screenWidth < drawerBreakPoint) {
      return Scaffold(
          drawer: const AppDrawer(),
          appBar: appBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: body);
    } else {
      return Scaffold(
          appBar: appBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: Row(children: [
            const AppDrawer(),
            Expanded(
                child: Align(
              alignment: Alignment.topCenter,
              child: body,
            ))
          ]));
    }
  }
}
