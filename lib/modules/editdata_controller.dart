import 'package:get/get.dart';

class EditController extends GetxController {
  var title = "xd".obs;

  addData(data) => title = data;
}
