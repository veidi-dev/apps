import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:VEIDI/constant/constant.dart';
import 'package:VEIDI/constant/show_toast_dialog.dart';
import 'package:VEIDI/model/user_model.dart';
import 'package:VEIDI/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ContactUsController extends GetxController {
  @override
  void onInit() {
    getUsrData();
    super.onInit();
  }

  String name = "";
  String userCat = "";

  getUsrData() async {
    UserModel userModel = Constant.getUserData();
    name = "${userModel.data!.prenom!} ${userModel.data!.nom!}";
    userCat = userModel.data!.userCat!;
  }

  Future<dynamic> contactUsSend(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Aguarde");
      final response = await http.post(Uri.parse(API.contactUs),
          headers: API.header, body: jsonEncode(bodyParams));

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
