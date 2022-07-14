import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_db/controllers/task_controller.dart';
import 'package:todo_db/models/task.dart';
import 'package:todo_db/screens/theme.dart';
import 'package:todo_db/screens/widgets/button.dart';
import 'package:todo_db/screens/widgets/input_fied.dart';
import 'package:todo_db/services/theme_services.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _endTime = "09:30 AM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  int _selectReminder = 5;
  List<int> _reminderList = [5, 10, 15, 20];

  String _selectedRpt = "None";
  List<String> _repeatedRptList = ["None", "Daily", "Weekly", "Monthly"];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInput(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              MyInput(
                title: "Note",
                hint: "Enter your note",
                controller: _noteController,
              ),
              MyInput(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInput(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartedTime: true);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: MyInput(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartedTime: false);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              MyInput(
                title: "Remind",
                hint: "$_selectReminder minutes early",
                widget: DropdownButton(
                  items:
                      _reminderList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? changedValue) {
                    setState(() {
                      _selectReminder = int.parse(changedValue!);
                    });
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  elevation: 4,
                  iconSize: 32,
                  style: subTitleStyle,
                ),
              ),
              MyInput(
                title: "Repeat",
                hint: _selectedRpt,
                widget: DropdownButton(
                  items: _repeatedRptList
                      .map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value!,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? changedValue) {
                    setState(() {
                      _selectedRpt = changedValue!;
                    });
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  elevation: 4,
                  iconSize: 32,
                  style: subTitleStyle,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _selectedColorPallete(),
                  MyButton(
                      label: "Create Task",
                      onTap: () {
                        _validateData();
                      }),
                ],
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
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

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime(2050),
    );

    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
        print(_selectedDate);
      });
    } else {
      print("Its null, Something went wrong");
    }
  }

  _getTimeFromUser({required bool isStartedTime}) async {
    var _pickedTime =
        await _showTime(); //change to TimeOfDay(hours: 9, minutes:30)

    String _formatTime = _pickedTime.format(context);

    if (_pickedTime == null) {
      print("Time picker is null");
    } else if (isStartedTime == true) {
      setState(() {
        _startTime = _formatTime;
      });
    } else if (isStartedTime == false) {
      setState(() {
        _endTime = _formatTime;
      });
    }
  }

  _showTime() => showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
          // starttime ---> 09:00 AM
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0])));

  _selectedColorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: _selectedColor == index
                      ? Icon(
                          Icons.done,
                          size: 16,
                          color: Colors.white,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      // save to database
      _addTaskToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: Icon(Icons.warning_amber_rounded));
    }
  }

  _addTaskToDB() {
    _taskController.addTask(
        task: Task(
      note: _noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectReminder,
      repeat: _selectedRpt,
      isComplete: 0,
    ));
  }
}
