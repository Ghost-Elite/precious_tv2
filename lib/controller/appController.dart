import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:precious_tv/services/serviceNetwork.dart';

class AppController extends GetxController{
  Services _services = Services();
  var datatloading = true.obs;
  var data;
  @override
  void onInit() {
    super.onInit();
    _services.getall();

  }
  callpostmethod() async {
    try {
      datatloading.value = true;
      var result = await _services.getall();
      data.assignAll(result);
    } finally {
      datatloading.value = false;
    }
    update();
  }
}