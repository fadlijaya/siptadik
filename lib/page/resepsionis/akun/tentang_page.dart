import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:siptadik/utils/constants.dart';

import '../../../theme/colors.dart';
import '../../../theme/padding.dart';

class TentangPage extends StatefulWidget {
  const TentangPage({Key? key}) : super(key: key);

  @override
  State<TentangPage> createState() => _TentangPageState();
}

class _TentangPageState extends State<TentangPage> {
  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;

  initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appName = info.appName;
      packageName = info.packageName;
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildIconBack(), buildTextPage(), buildInfoTentangApp()],
        ),
      )),
    );
  }

  Widget buildIconBack() {
    return IconButton(
        padding: const EdgeInsets.all(padding),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          color: kGreen2,
        ));
  }

  Widget buildTextPage() {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
          child: Text(
            titleTentang,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildInfoTentangApp() {
    return Container(
      padding: const EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kGrey.withOpacity(0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "App Name",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text("$appName")
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kGrey.withOpacity(0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Version",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text("$version")
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kGrey.withOpacity(0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Package Name",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text("$packageName")
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kGrey.withOpacity(0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Build Number",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text("$buildNumber")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
