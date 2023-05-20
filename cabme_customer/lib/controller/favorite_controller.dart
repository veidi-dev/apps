import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:VEIDI/constant/show_toast_dialog.dart';
import 'package:VEIDI/model/favorite_model.dart';
import 'package:VEIDI/service/api.dart';
import 'package:VEIDI/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FavoriteController extends GetxController {
  var isLoading = true.obs;
  var favouriteList = <Data>[].obs;

  @override
  void onInit() {
    favouriteData();
    super.onInit();
  }

  Future<dynamic> favouriteData() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${API.favorite}?id_user_app=${Preferences.getInt(Preferences.userId)}"),
          headers: API.header);

      log(response.request.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        isLoading.value = false;
        FavoriteModel model = FavoriteModel.fromJson(responseBody);
        favouriteList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
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

  Future<dynamic> deleteFavouriteRide(String favId) async {
    try {
      ShowToastDialog.showLoader("Aguarde");
      final response = await http.get(
          Uri.parse("${API.deleteFavouriteRide}?id_ride_fav=$favId"),
          headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Algo correu mal. Tente mais tarde');
        throw Exception('Não foi possível carregar informações');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
