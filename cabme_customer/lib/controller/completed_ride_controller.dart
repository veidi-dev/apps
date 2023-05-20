import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:VEIDI/constant/constant.dart';
import 'package:VEIDI/constant/show_toast_dialog.dart';
import 'package:VEIDI/model/ride_model.dart';
import 'package:VEIDI/model/user_model.dart';
import 'package:VEIDI/service/api.dart';
import 'package:VEIDI/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CompletedRideController extends GetxController {
  var isLoading = true.obs;
  var rideList = <RideData>[].obs;

  @override
  void onInit() {
    getCompletedRide();
    getUsrData();
    super.onInit();
  }

  UserModel? userModel;

  getUsrData() {
    userModel = Constant.getUserData();
  }

  Future<dynamic> getCompletedRide() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${API.completedRide}?id_user_app=${Preferences.getInt(Preferences.userId)}"),
          headers: API.header);

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

// Future<dynamic> feelAsSafe(String id) async {
//   try {
//     ShowToastDialog.showLoader("Please wait");
//     Map<String, dynamic> bodyParams = {
//       'user_name': userModel!.data!.nom,
//       'user_cat': userModel!.data!.userCat,
//       'trip_id': id,
//     };
//     final response = await http.post(Uri.parse(API.feelSafeAtDestination), headers: API.header, body: jsonEncode(bodyParams));
//     print(response.request);
//     print(response.body);
//     Map<String, dynamic> responseBody = json.decode(response.body);
//     if (response.statusCode == 200) {
//       ShowToastDialog.closeLoader();
//       return responseBody;
//     } else {
//       ShowToastDialog.closeLoader();
//       ShowToastDialog.showToast('Something want wrong. Please try again later');
//       throw Exception('Failed to load album');
//     }
//   } on TimeoutException catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.message.toString());
//   } on SocketException catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.message.toString());
//   } on Error catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.toString());
//   } catch (e) {
//     ShowToastDialog.closeLoader();
//     ShowToastDialog.showToast(e.toString());
//   }
//   return null;
// }
}
