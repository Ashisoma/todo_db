import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_db/controllers/task_controller.dart';
import 'package:todo_db/models/task.dart';
import 'package:todo_db/screens/add_task.dart';
import 'package:todo_db/screens/theme.dart';
import 'package:todo_db/screens/widgets/button.dart';
import 'package:todo_db/screens/widgets/task_tile.dart';
import 'package:todo_db/services/notifications_services.dart';
import 'package:todo_db/services/theme_services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotificationServiceHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          _addTaskBar(),
          _dateTimeBar(),
          const SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  Container _dateTimeBar() {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text("Today", style: headingStyle),
              ],
            ),
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Get.to(AddTaskPage());
                // page refresher
                _taskController.getTask();
              })
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          THemeService().changeMyTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body:
                Get.isDarkMode ? "Activated Light Mode" : "Activated Dark Mode",
          );
          notifyHelper.scheduledNotification(
            title: "Theme Changed notification 5s later",
            body:
                Get.isDarkMode ? "Activated Light Mode" : "Activated Dark Mode",
          );
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.jpg"),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _showTasks() {
    print(_taskController.getTask());
    // print("\n\n No of tasks : " + _taskController.taskList.length.toString());
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            print("\n\n No of tasks :");
            print(_taskController.taskList.length);
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onDoubleTap: () {
                            _showBottomSheet(
                                context, _taskController.taskList[index]);
                          },
                          child: TaskTile(_taskController.taskList[index]),
                        )
                      ],
                    ),
                  ),
                ));
          });
    }));
  }

  _bottomSheetBtn(
      {required String label,
      required Function()? onTap,
      required Color clr,
      bool iClosed = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: iClosed == true
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
          borderRadius: BorderRadius.circular(20),
          color: iClosed == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                iClosed ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isComplete == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyhClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
          ),
          // Spacer(),
          task.isComplete == 1
              ? Container()
              : _bottomSheetBtn(
                  label: "Task Completed",
                  onTap: () {
                    Get.back();
                  },
                  clr: primaryClr,
                  context: context),

          _bottomSheetBtn(
            label: "Delete Task",
            onTap: () {
              Get.back();
            },
            clr: Colors.red[300]!,
            context: context,
          ),
          const SizedBox(
            height: 10,
          ),
          _bottomSheetBtn(
              label: "Close",
              iClosed: true,
              onTap: () {
                Get.back();
              },
              clr: Colors.white,
              context: context),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    ));
  }
}
