import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_db/db/task_db_helper.dart';
import 'package:todo_db/screens/home_page.dart';
import 'package:todo_db/screens/theme.dart';
import 'package:todo_db/services/theme_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DBHelper.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      themeMode: THemeService().theme,
      darkTheme: Themes.dark,
      home: const HomePage(),
    );
  }
}
