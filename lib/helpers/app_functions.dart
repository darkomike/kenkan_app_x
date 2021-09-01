
import 'package:url_launcher/url_launcher.dart';


class AppFunctions {

  
  static Future<void> launchIn(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        // headers: <String, String>{'my_header_key': 'my_header_value'
        // },
      );
    } else {
      throw 'Could not launch $url';
    }
  }

// ---------------------------------------------------------------------------------------------------
  static Future<void> launchInGmail(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        // headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }


  





}
