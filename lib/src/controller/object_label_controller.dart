import 'package:get/get.dart';

class LabelController extends GetxController {
  static LabelController get instance => Get.find();
  RxMap<String, int> objectLabels = <String, int>{}.obs;
}
