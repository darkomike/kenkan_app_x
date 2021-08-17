import 'dart:math';
import 'package:kenkan_app_x/constants/names.dart';
import 'package:kenkan_app_x/db/diction_db/a.dart';
import 'package:kenkan_app_x/db/diction_db/b.dart';
import 'package:kenkan_app_x/db/diction_db/c.dart';
import 'package:kenkan_app_x/db/diction_db/d.dart';
import 'package:kenkan_app_x/db/diction_db/e.dart';
import 'package:kenkan_app_x/db/diction_db/f.dart';
import 'package:kenkan_app_x/db/diction_db/g.dart';
import 'package:kenkan_app_x/db/diction_db/h.dart';
import 'package:kenkan_app_x/db/diction_db/i.dart';
import 'package:kenkan_app_x/db/diction_db/j.dart';
import 'package:kenkan_app_x/db/diction_db/k.dart';
import 'package:kenkan_app_x/db/diction_db/l.dart';
import 'package:kenkan_app_x/db/diction_db/m.dart';
import 'package:kenkan_app_x/db/diction_db/n.dart';
import 'package:kenkan_app_x/db/diction_db/o.dart';
import 'package:kenkan_app_x/db/diction_db/p.dart';
import 'package:kenkan_app_x/db/diction_db/q.dart';
import 'package:kenkan_app_x/db/diction_db/r.dart';
import 'package:kenkan_app_x/db/diction_db/s.dart';
import 'package:kenkan_app_x/db/diction_db/t.dart';
import 'package:kenkan_app_x/db/diction_db/u.dart';
import 'package:kenkan_app_x/db/diction_db/v.dart';
import 'package:kenkan_app_x/db/diction_db/w.dart';
import 'package:kenkan_app_x/db/diction_db/x.dart';
import 'package:kenkan_app_x/db/diction_db/y.dart';
import 'package:kenkan_app_x/db/diction_db/z.dart';
import 'package:kenkan_app_x/helpers/reader_functions.dart';
import 'package:kenkan_app_x/models/wordModel.dart';
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
