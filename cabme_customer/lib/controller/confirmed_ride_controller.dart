import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:VEIDI/constant/show_toast_dialog.dart';
import 'package:VEIDI/model/ride_model.dart';
import 'package:VEIDI/service/api.dart';
import 'package:VEIDI/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ConfirmedRideController extends GetxController {
  var isLoading = true.obs;
  var rideList = <RideData>[].obs;

  @override
  void onInit() {
    getNewRide();
    super.onInit();
  }

  Future<dynamic> getNewRide() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${API.confirmedRide}?id_user_app=${Preferences.getInt(Preferences.userId)}"),
          headers: API.header);

      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        RideModel model = RideModel.fromJson(responseBody);
        rideList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        rideList.clear();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Algo correu mal. Tente mais tarde');
        throw Exception('Não foi possível carregar informações');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
