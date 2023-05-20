import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:VEIDI/constant/show_toast_dialog.dart';
import 'package:VEIDI/service/api.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;

class PrivacyPolicyController extends GetxController {
  @override
  void onInit() {
    getPrivacyPolicy();

    super.onInit();
  }

  dynamic privacyData;

  Future<dynamic> getPrivacyPolicy() async {
    try {
      ShowToastDialog.showLoader("Aguarde");
      final response = await http.get(
        Uri.parse(API.privacyPolicy),
        headers: API.header,
      );
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        privacyData = responseBody['data']['privacy_policy'];
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
    update();
    return null;
  }
}
