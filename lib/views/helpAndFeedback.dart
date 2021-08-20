import 'package:flutter/material.dart';
import 'package:kenkan_app_x/constants/other_names.dart';
import 'package:kenkan_app_x/constants/sytle.dart';
import 'package:kenkan_app_x/helpers/app_functions.dart';
import 'package:kenkan_app_x/widgets/app_drawer.dart';


import '../reader_homepage.dart';

class HelpAndFeedback extends StatefulWidget {
  const HelpAndFeedback({Key? key}) : super(key: key);

  @override
  _HelpAndFeedbackState createState() => _HelpAndFeedbackState();
}

class _HelpAndFeedbackState extends State<HelpAndFeedback> {
  Future<void>? _launched;

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReaderHomepage(),
        ));
    return true;
  }

  @override
  Widget build(BuildContext context) {
        Color color = Theme.of(context).iconTheme.color!;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.0,
          title: Text(
            "Help & Feedback",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        drawer: AppDrawer(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListView(
            children: [
              Text(BodyNames.feedbackMessageBody, style: Theme.of(context).textTheme.headline3,),
              SizedBox(height: 20,),
              ListTile(
                leading: Icon(
                  Icons.email_rounded,
                  color: color,
                  size: Theme.of(context).iconTheme.size,
                ),
                title: Text("Email Us",
                    style: Theme.of(context).textTheme.headline3),
                onTap: () {
                  setState(() {
                    _launched = AppFunctions.launchIn(LinkNames.toEmail);
                  });
                },
                subtitle: Text("Send us a feedback via an email"),
              ),
              Divider(height: 0.5,),
              ListTile(
                leading: Icon(
                  Icons.call,
                  color: color,
                  size: Theme.of(context).iconTheme.size,
                ),
                title: Text("Phone Us",
                    style: Theme.of(context).textTheme.headline3),
                onTap: () {
                  setState(() {
                    _launched = AppFunctions.launchIn(LinkNames.toTelephone);
                  });
                },
                subtitle: Text("Send us a feedback via a phone call"),
              ),
              Divider(height: 0.5,),
              ListTile(
                leading: Icon(
                  Icons.sms,
                  color: color,
                  size: Theme.of(context).iconTheme.size,
                ),
                title: Text("SMS",
                    style: Theme.of(context).textTheme.headline3),
                onTap: () {
                  setState(() {
                    _launched = AppFunctions.launchIn(LinkNames.toSms);
                  });
                },
                subtitle: Text("Send us a feedback via sms"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
