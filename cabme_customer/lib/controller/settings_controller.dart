import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:VEIDI/constant/constant.dart';
import 'package:VEIDI/constant/show_toast_dialog.dart';
import 'package:VEIDI/model/settings_model.dart';
import 'package:VEIDI/service/api.dart';
import 'package:VEIDI/themes/constant_colors.dart';
import 'package:VEIDI/utils/Preferences.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SettingsController extends GetxController {
  @override
  void onInit() {
    API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);
    getSettingsData();
    super.onInit();
  }

  Future<SettingsModel?> getSettingsData() async {
    try {
      ShowToastDialog.showLoader("Aguarde");
      final response = await http.get(
        Uri.parse(API.settings),
        headers: API.authheader,
      );

      Map<String, dynamic> responseBody = json.decode(response.body);
      log(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        SettingsModel model = SettingsModel.fromJson(responseBody);

        ConstantColors.primary = Color(
            int.parse(model.data!.websiteColor!.replaceFirst("#", "0xff")));
        Constant.distanceUnit = model.data!.deliveryDistance!;
        Constant.appVersion = model.data!.appVersion.toString();
        Constant.decimal = model.data!.decimalDigit!;
        Constant.taxType = model.data!.taxType!;
        Constant.taxName = model.data!.taxName!;
        Constant.taxValue = model.data!.taxValue!;
        Constant.currency = model.data!.currency!;
        Constant.kGoogleApiKey = model.data!.googleMapApiKey!;
        Constant.contactUsEmail = model.data!.contactUsEmail!;
        Constant.contactUsAddress = model.data!.contactUsAddress!;
        Constant.contactUsPhone = model.data!.contactUsPhone!;
        Constant.rideOtp = model.data!.showRideOtp!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Algo correu mal. Tente mais tarde');
        throw Exception('Não foi possível carregar informações');
      }
    } on TimeoutException catch (e) {
      print(e.toString());
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      print(e.toString());
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      print(e.toString());
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      print(e.toString());
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
