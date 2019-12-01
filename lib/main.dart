import 'package:flutter/material.dart';
import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/foundation.dart' show TargetPlatform;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _appSecret;
  String _installId = 'Unknown';
  bool _areAnalyticsEnabled = false, _areCrashesEnabled = false;

  _MyAppState() {
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    _appSecret = ios ? "fa5661c8-5847-4d29-a70a-98ec1300a03e" : "9962d1ea-cdef-4be6-b57c-e7ae7457899c";
  }

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    await AppCenter.start(
        _appSecret, [AppCenterAnalytics.id, AppCenterCrashes.id]);

    if (!mounted) return;

    var installId = await AppCenter.installId;

    var areAnalyticsEnabled = await AppCenterAnalytics.isEnabled;
    var areCrashesEnabled = await AppCenterCrashes.isEnabled;

    setState(() {
      _installId = installId;
      _areAnalyticsEnabled = areAnalyticsEnabled;
      _areCrashesEnabled = areCrashesEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Appcenter plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Install identifier:\n $_installId'),
            Text('Analytics: $_areAnalyticsEnabled'),
            Text('Crashes: $_areCrashesEnabled'),
            RaisedButton(
              child: Text('Generate test crash'),
              onPressed: AppCenterCrashes.generateTestCrash,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Send events'),
                IconButton(
                  icon: Icon(Icons.map),
                  tooltip: 'map',
                  onPressed: () {
                    AppCenterAnalytics.trackEvent("map");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.casino),
                  tooltip: 'casino',
                  onPressed: () {
                    AppCenterAnalytics.trackEvent("casino", {"dollars": "10"});
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}