import 'dart:convert';

import 'package:VEIDI_driver/constant/constant.dart';
import 'package:VEIDI_driver/constant/show_toast_dialog.dart';
import 'package:VEIDI_driver/controller/dash_board_controller.dart';
import 'package:VEIDI_driver/controller/new_ride_controller.dart';
import 'package:VEIDI_driver/model/ride_model.dart';
import 'package:VEIDI_driver/page/complaint/add_complaint_screen.dart';
import 'package:VEIDI_driver/page/completed/trip_history_screen.dart';
import 'package:VEIDI_driver/page/review_screens/add_review_screen.dart';
import 'package:VEIDI_driver/page/route_view_screen/route_view_screen.dart';
import 'package:VEIDI_driver/themes/button_them.dart';
import 'package:VEIDI_driver/themes/constant_colors.dart';
import 'package:VEIDI_driver/themes/custom_alert_dialog.dart';
import 'package:VEIDI_driver/themes/custom_dialog_box.dart';
import 'package:VEIDI_driver/utils/Preferences.dart';
import 'package:VEIDI_driver/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:text_scroll/text_scroll.dart';

class NewRideScreen extends StatelessWidget {
  NewRideScreen({Key? key}) : super(key: key);

  final controllerDashBoard = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return GetX<NewRideController>(
      init: NewRideController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: ConstantColors.background,
            body: RefreshIndicator(
              onRefresh: () => controller.getNewRide(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: controller.isLoading.value
                    ? Constant.loader()
                    : controller.rideList.isEmpty
                        ? Constant.emptyView("Your don't have any ride booked.")
                        : ListView.builder(
                            itemCount: controller.rideList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return newRideWidgets(context,
                                  controller.rideList[index], controller);
                            }),
              ),
            ));
      },
    );
  }

  Widget newRideWidgets(
      BuildContext context, RideData data, NewRideController controller) {
    return InkWell(
      onTap: () async {
        if (data.statut == "completed") {
          var isDone = await Get.to(const TripHistoryScreen(), arguments: {
            "rideData": data,
          });
          if (isDone != null) {
            controller.getNewRide();
          }
        } else {
          var argumentData = {'type': data.statut, 'data': data};
          Get.to(const RouteViewScreen(), arguments: argumentData)!
              .then((value) {});
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/ic_pic_drop_location.png",
                          height: 60,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.departName.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Divider(),
                                Text(
                                  data.destinationName.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/passenger.png',
                                          height: 22,
                                          width: 22,
                                          color: ConstantColors.yellow,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                              " ${data.numberPoeple.toString()}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black54)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Column(
                                      children: [
                                        Text(
                                          Constant.currency.toString(),
                                          style: TextStyle(
                                            color: ConstantColors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        // Image.asset(
                                        //   'assets/icons/price.png',
                                        //   height: 22,
                                        //   width: 22,
                                        //   color: ConstantColors.yellow,
                                        // ),
                                        Text(
                                          "${Constant.currency}${double.parse(data.montant!.toString()).toStringAsFixed(int.parse(Constant.decimal.toString()))}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/ic_distance.png',
                                          height: 22,
                                          width: 22,
                                          color: ConstantColors.yellow,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                              "${data.distance.toString()} ${Constant.distanceUnit}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black54)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/time.png',
                                          height: 22,
                                          width: 22,
                                          color: ConstantColors.yellow,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: TextScroll(
                                              data.duree.toString(),
                                              mode: TextScrollMode.bouncing,
                                              pauseBetween:
                                                  const Duration(seconds: 2),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black54)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: data.photoPath.toString(),
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${data.prenom} ${data.nom}',
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600)),
                                  StarRating(
                                      size: 18,
                                      rating: double.parse(
                                          data.moyenneDriver.toString()),
                                      color: ConstantColors.yellow),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Constant.makePhoneCall(data.phone.toString());
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.all(
                                      6), // <-- Splash color
                                ),
                                child: const Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              Text(data.dateRetour.toString(),
                                  style: const TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.w600)),
                            ],
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: data.statut == "completed",
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: ButtonThem.buildButton(context,
                                    btnHeight: 40,
                                    title: data.statutPaiement == "yes"
                                        ? "Paid"
                                        : "Not paid",
                                    btnColor: data.statutPaiement == "yes"
                                        ? Colors.green
                                        : ConstantColors.primary,
                                    txtColor: Colors.white, onPress: () {
                              // if (data.payment == "Cash") {
                              //   controller.conformPaymentByCache(data.id.toString()).then((value) {
                              //     if (value != null) {
                              //       showDialog(
                              //           context: context,
                              //           builder: (BuildContext context) {
                              //             return CustomDialogBox(
                              //               title: "Payment by cash",
                              //               descriptions: "Payment collected successfully",
                              //               text: "Ok",
                              //               onPress: () {
                              //                 Get.back();
                              //                 controller.getCompletedRide();
                              //               },
                              //               img: Image.asset('assets/images/green_checked.png'),
                              //             );
                              //           });
                              //     }
                              //   });
                              // } else {}
                            })),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: ButtonThem.buildBorderButton(
                                    context,
                                    title: 'Add Review'.tr,
                                    btnWidthRatio: 0.8,
                                    btnHeight: 40,
                                    btnColor: Colors.white,
                                    txtColor: ConstantColors.primary,
                                    btnBorderColor: ConstantColors.primary,
                                    onPress: () async {
                                      Get.to(const AddReviewScreen(),
                                          arguments: {
                                            'rideData': data,
                                          });
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: data.statut == "completed",
                      child: ButtonThem.buildBorderButton(
                        context,
                        title: 'Add Complaint'.tr,
                        btnHeight: 40,
                        btnColor: Colors.white,
                        txtColor: ConstantColors.primary,
                        btnBorderColor: ConstantColors.primary,
                        onPress: () async {
                          Get.to(AddComplaintScreen(), arguments: {
                            'rideData': data,
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Visibility(
                            visible: data.statut == "new" ||
                                    data.statut == "confirmed"
                                ? true
                                : false,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: ButtonThem.buildBorderButton(
                                  context,
                                  title: 'REJECT'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: Colors.white,
                                  txtColor: Colors.black.withOpacity(0.60),
                                  btnBorderColor:
                                      Colors.black.withOpacity(0.20),
                                  onPress: () async {
                                    buildShowBottomSheet(
                                        context, data, controller);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: data.statut == "new" ? true : false,
                            child: Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5, left: 10),
                                child: ButtonThem.buildButton(
                                  context,
                                  title: 'ACCEPT'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: ConstantColors.primary,
                                  txtColor: Colors.black,
                                  onPress: () async {
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title:
                                              "Do you want to confirm this booking?",
                                          onPressNegative: () {
                                            Get.back();
                                          },
                                          negativeButtonText: 'No'.tr,
                                          positiveButtonText: 'Yes'.tr,
                                          onPressPositive: () {
                                            Map<String, String> bodyParams = {
                                              'id_ride': data.id.toString(),
                                              'id_user':
                                                  data.idUserApp.toString(),
                                              'driver_name':
                                                  '${data.prenomConducteur.toString()} ${data.nomConducteur.toString()}',
                                              'lat_conducteur': data
                                                  .latitudeDepart
                                                  .toString(),
                                              'lng_conducteur': data
                                                  .longitudeDepart
                                                  .toString(),
                                              'lat_client': data.latitudeArrivee
                                                  .toString(),
                                              'lng_client': data
                                                  .longitudeArrivee
                                                  .toString(),
                                              'from_id': Preferences.getInt(
                                                      Preferences.userId)
                                                  .toString(),
                                            };

                                            controller
                                                .confirmedRide(bodyParams)
                                                .then((value) {
                                              if (value != null) {
                                                Get.back();
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CustomDialogBox(
                                                        title:
                                                            "Confirmed Successfully",
                                                        descriptions:
                                                            "Ride Successfully confirmed.",
                                                        text: "Ok",
                                                        onPress: () {
                                                          Get.back();
                                                          controller
                                                              .getNewRide();

                                                          Preferences.setString(
                                                              Preferences
                                                                  .currentRideData,
                                                              jsonEncode(data
                                                                  .toJson()));
                                                          controllerDashBoard
                                                              .updateCurrentLocation();
                                                        },
                                                        img: Image.asset(
                                                            'assets/images/green_checked.png'),
                                                      );
                                                    });
                                              }
                                            });
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: data.statut == "confirmed" ? true : false,
                            child: Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5, left: 10),
                                child: ButtonThem.buildButton(
                                  context,
                                  title: 'On ride'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: ConstantColors.primary,
                                  txtColor: Colors.black,
                                  onPress: () async {
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title:
                                              "Do you want to on ride this ride?",
                                          negativeButtonText: 'No'.tr,
                                          positiveButtonText: 'Yes'.tr,
                                          onPressNegative: () {
                                            Get.back();
                                          },
                                          onPressPositive: () {
                                            Get.back();
                                            if (Constant.rideOtp.toString() !=
                                                    'yes' &&
                                                data.otp!.isEmpty) {
                                              Map<String, String> bodyParams = {
                                                'id_ride': data.id.toString(),
                                                'id_user':
                                                    data.idUserApp.toString(),
                                                'use_name':
                                                    '${data.prenomConducteur.toString()} ${data.nomConducteur.toString()}',
                                                'from_id': Preferences.getInt(
                                                        Preferences.userId)
                                                    .toString(),
                                              };
                                              controller
                                                  .setOnRideRequest(bodyParams)
                                                  .then((value) {
                                                if (value != null) {
                                                  Get.back();
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomDialogBox(
                                                          title:
                                                              "On ride Successfully",
                                                          descriptions:
                                                              "Ride Successfully On ride.",
                                                          text: "Ok",
                                                          onPress: () {
                                                            Preferences.setString(
                                                                Preferences
                                                                    .currentRideData,
                                                                jsonEncode(data
                                                                    .toJson()));
                                                            controllerDashBoard
                                                                .updateCurrentLocation();
                                                            controller
                                                                .getNewRide();
                                                          },
                                                          img: Image.asset(
                                                              'assets/images/green_checked.png'),
                                                        );
                                                      });
                                                }
                                              });
                                            } else {
                                              controller.otpController =
                                                  TextEditingController();
                                              showDialog(
                                                barrierColor: Colors.black26,
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Container(
                                                      height: 200,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 20,
                                                              right: 10,
                                                              bottom: 20),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black,
                                                                offset: Offset(
                                                                    0, 10),
                                                                blurRadius: 10),
                                                          ]),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "Enter OTP",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.60)),
                                                          ),
                                                          PinCodeTextField(
                                                            length: 6,
                                                            appContext: context,
                                                            keyboardType:
                                                                TextInputType
                                                                    .phone,
                                                            pinTheme: PinTheme(
                                                              fieldHeight: 40,
                                                              fieldWidth: 40,
                                                              activeColor:
                                                                  ConstantColors
                                                                      .textFieldBoarderColor,
                                                              selectedColor:
                                                                  ConstantColors
                                                                      .textFieldBoarderColor,
                                                              inactiveColor:
                                                                  ConstantColors
                                                                      .textFieldBoarderColor,
                                                              activeFillColor:
                                                                  Colors.white,
                                                              inactiveFillColor:
                                                                  Colors.white,
                                                              selectedFillColor:
                                                                  Colors.white,
                                                              shape:
                                                                  PinCodeFieldShape
                                                                      .box,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            enableActiveFill:
                                                                true,
                                                            cursorColor:
                                                                ConstantColors
                                                                    .primary,
                                                            controller: controller
                                                                .otpController,
                                                            onCompleted:
                                                                (v) async {},
                                                            onChanged: (value) {
                                                              debugPrint(value);
                                                            },
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: ButtonThem
                                                                    .buildButton(
                                                                  context,
                                                                  title:
                                                                      'Done'.tr,
                                                                  btnHeight: 45,
                                                                  btnWidthRatio:
                                                                      0.8,
                                                                  btnColor:
                                                                      ConstantColors
                                                                          .primary,
                                                                  txtColor:
                                                                      Colors
                                                                          .white,
                                                                  onPress: () {
                                                                    if (controller
                                                                            .otpController
                                                                            .text
                                                                            .toString()
                                                                            .length ==
                                                                        6) {
                                                                      controller
                                                                          .verifyOTP(
                                                                        userId: data
                                                                            .idUserApp!
                                                                            .toString(),
                                                                        rideId: data
                                                                            .id!
                                                                            .toString(),
                                                                      )
                                                                          .then(
                                                                              (value) {
                                                                        if (value !=
                                                                                null &&
                                                                            value['success'] ==
                                                                                "success") {
                                                                          Map<String, String>
                                                                              bodyParams =
                                                                              {
                                                                            'id_ride':
                                                                                data.id.toString(),
                                                                            'id_user':
                                                                                data.idUserApp.toString(),
                                                                            'use_name':
                                                                                '${data.prenomConducteur.toString()} ${data.nomConducteur.toString()}',
                                                                            'from_id':
                                                                                Preferences.getInt(Preferences.userId).toString(),
                                                                          };
                                                                          controller
                                                                              .setOnRideRequest(bodyParams)
                                                                              .then((value) {
                                                                            if (value !=
                                                                                null) {
                                                                              Get.back();
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return CustomDialogBox(
                                                                                      title: "On ride Successfully",
                                                                                      descriptions: "Ride Successfully On ride.",
                                                                                      text: "Ok",
                                                                                      onPress: () {
                                                                                        Get.back();
                                                                                        Preferences.setString(Preferences.currentRideData, jsonEncode(data.toJson()));
                                                                                        controllerDashBoard.updateCurrentLocation();
                                                                                        controller.getNewRide();
                                                                                      },
                                                                                      img: Image.asset('assets/images/green_checked.png'),
                                                                                    );
                                                                                  });
                                                                            }
                                                                          });
                                                                        }
                                                                      });
                                                                    } else {
                                                                      ShowToastDialog
                                                                          .showToast(
                                                                              'Please Enter OTP');
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: ButtonThem
                                                                    .buildBorderButton(
                                                                  context,
                                                                  title:
                                                                      'Cancel'
                                                                          .tr,
                                                                  btnHeight: 45,
                                                                  btnWidthRatio:
                                                                      0.8,
                                                                  btnColor:
                                                                      Colors
                                                                          .white,
                                                                  txtColor: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.60),
                                                                  btnBorderColor: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.20),
                                                                  onPress: () {
                                                                    Get.back();
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                            // if (data.carDriverConfirmed == 1) {
                                            //
                                            // } else if (data.carDriverConfirmed == 2) {
                                            //   Get.back();
                                            //   ShowToastDialog.showToast("Customer decline the confirmation of driver and car information.");
                                            // } else if (data.carDriverConfirmed == 0) {
                                            //   Get.back();
                                            //   ShowToastDialog.showToast("Customer needs to verify driver and car before you can start trip.");
                                            // }
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: data.statut == "on ride" ? true : false,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: ButtonThem.buildBorderButton(
                                  context,
                                  title: 'START RIDE'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: Colors.white,
                                  txtColor: Colors.black.withOpacity(0.60),
                                  btnBorderColor:
                                      Colors.black.withOpacity(0.20),
                                  onPress: () async {
                                    Constant.launchMapURl(data.latitudeArrivee,
                                        data.longitudeArrivee);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: data.statut == "on ride" ? true : false,
                            child: Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5, left: 10),
                                child: ButtonThem.buildButton(
                                  context,
                                  title: 'COMPLETE'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: ConstantColors.primary,
                                  txtColor: Colors.black,
                                  onPress: () async {
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title:
                                              "Do you want to complete this ride?",
                                          onPressNegative: () {
                                            Get.back();
                                          },
                                          negativeButtonText: 'No'.tr,
                                          positiveButtonText: 'Yes'.tr,
                                          onPressPositive: () {
                                            Map<String, String> bodyParams = {
                                              'id_ride': data.id.toString(),
                                              'id_user':
                                                  data.idUserApp.toString(),
                                              'driver_name':
                                                  '${data.prenomConducteur.toString()} ${data.nomConducteur.toString()}',
                                              'from_id': Preferences.getInt(
                                                      Preferences.userId)
                                                  .toString(),
                                            };
                                            controller
                                                .setCompletedRequest(bodyParams)
                                                .then((value) {
                                              if (value != null) {
                                                Get.back();
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CustomDialogBox(
                                                        title:
                                                            "Completed Successfully",
                                                        descriptions:
                                                            "Ride Successfully completed.",
                                                        text: "Ok",
                                                        onPress: () {
                                                          Get.back();
                                                          controller
                                                              .getNewRide();
                                                        },
                                                        img: Image.asset(
                                                            'assets/images/green_checked.png'),
                                                      );
                                                    });
                                              }
                                            });
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              right: 0,
              child: Image.asset(
                data.statut == "new"
                    ? 'assets/images/new.png'
                    : data.statut == "confirmed"
                        ? 'assets/images/conformed.png'
                        : data.statut == "on ride"
                            ? 'assets/images/onride.png'
                            : data.statut == "completed"
                                ? 'assets/images/completed.png'
                                : 'assets/images/rejected.png',
                height: 120,
                width: 120,
              )),
        ],
      ),
    );
  }

  final resonController = TextEditingController();

  buildShowBottomSheet(
      BuildContext context, RideData data, NewRideController controller) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Cancel Trip",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Write a reason for trip cancellation",
                        style: TextStyle(color: Colors.black.withOpacity(0.50)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: resonController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'Cancel Trip'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white,
                                onPress: () async {
                                  if (resonController.text.isNotEmpty) {
                                    Get.back();
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title:
                                              "Do you want to reject this booking?",
                                          onPressNegative: () {
                                            Get.back();
                                          },
                                          negativeButtonText: 'No'.tr,
                                          positiveButtonText: 'Yes'.tr,
                                          onPressPositive: () {
                                            Map<String, String> bodyParams = {
                                              'id_ride': data.id.toString(),
                                              'id_user':
                                                  data.idUserApp.toString(),
                                              'name':
                                                  '${data.prenomConducteur.toString()} ${data.nomConducteur.toString()}',
                                              'from_id': Preferences.getInt(
                                                      Preferences.userId)
                                                  .toString(),
                                              'user_cat': controller
                                                  .userModel!.userData!.userCat
                                                  .toString(),
                                              'reason': resonController.text
                                                  .toString(),
                                            };
                                            controller
                                                .canceledRide(bodyParams)
                                                .then((value) {
                                              Get.back();
                                              if (value != null) {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CustomDialogBox(
                                                        title:
                                                            "Reject Successfully",
                                                        descriptions:
                                                            "Ride Successfully rejected.",
                                                        text: "Ok",
                                                        onPress: () {
                                                          Get.back();
                                                          controller
                                                              .getNewRide();
                                                        },
                                                        img: Image.asset(
                                                            'assets/images/green_checked.png'),
                                                      );
                                                    });
                                              }
                                            });
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    ShowToastDialog.showToast(
                                        "Please enter a reason");
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, left: 10),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'Close'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: Colors.white,
                                txtColor: ConstantColors.primary,
                                btnBorderColor: ConstantColors.primary,
                                onPress: () async {
                                  Get.back();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
