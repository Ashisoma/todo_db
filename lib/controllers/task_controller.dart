import 'package:get/get.dart';
import 'package:todo_db/db/task_db_helper.dart';
import 'package:todo_db/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  getTask() async {
    print("Get task  funtion()");
    List<Map<String, dynamic>> tasks = await DBHelper.getTasks();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  delete(Task task) {
    DBHelper.delete(task);
  }
}
