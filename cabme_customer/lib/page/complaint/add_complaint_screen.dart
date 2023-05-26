import 'package:VEIDI/constant/constant.dart';
import 'package:VEIDI/constant/show_toast_dialog.dart';
import 'package:VEIDI/controller/add_complaint_controller.dart';
import 'package:VEIDI/themes/button_them.dart';
import 'package:VEIDI/themes/constant_colors.dart';
import 'package:VEIDI/themes/text_field_them.dart';
import 'package:VEIDI/widget/my_separator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddComplaintScreen extends StatelessWidget {
  AddComplaintScreen({Key? key}) : super(key: key);

  static final _complaintDiscriptionController = TextEditingController();
  static final _complaintTitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetX<AddComplaintController>(
      init: AddComplaintController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.primary,
          appBar: AppBar(
              backgroundColor: ConstantColors.primary,
              elevation: 0,
              centerTitle: true,
              title: const Text("Envie o seu Feedback",
                  style: TextStyle(color: Colors.white)),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                        ),
                      )),
                ),
              )),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 42, bottom: 20),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 65),
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                    "${controller.data.value.prenomConducteur} ${controller.data.value.nomConducteur}",
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      controller.data.value.numberplate!
                                          .toUpperCase()
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                        "${controller.data.value.brand!} ${controller.data.value.model!}",
                                        style: const TextStyle(
                                            color: Colors.black38,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: MySeparator(color: Colors.grey),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              'Como correu o transporte?',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'O seu feedback vai nos ajudar \n a melhorar a experiência VEIDI',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ConstantColors.subTitleTextColor,
                                  letterSpacing: 0.8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'Comentário sobre',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ConstantColors.subTitleTextColor,
                                  letterSpacing: 0.8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "${controller.data.value.prenomConducteur.toString()} ${controller.data.value.nomConducteur.toString()}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, left: 20, right: 20),
                                  child: TextFieldThem.boxBuildTextField(
                                    hintText: 'Assunto'.tr,
                                    controller: _complaintTitleController,
                                    textInputType: TextInputType.emailAddress,
                                    contentPadding: EdgeInsets.zero,
                                    validators: (String? value) {
                                      if (value!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'Obrigatório'.tr;
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, left: 20, right: 20),
                                  child: TextFieldThem.boxBuildTextField(
                                    hintText: 'Escreva o seu comentário'.tr,
                                    controller: _complaintDiscriptionController,
                                    textInputType: TextInputType.emailAddress,
                                    maxLine: 5,
                                    contentPadding: EdgeInsets.zero,
                                    validators: (String? value) {
                                      if (value!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'obrigatório'.tr;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 20),
                            child: ButtonThem.buildButton(context,
                                btnHeight: 45,
                                title: "Enviar Feedback",
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white, onPress: () async {
                              if (_formKey.currentState!.validate()) {
                                Map<String, String> bodyParams = {
                                  'id_user_app': controller.data.value.idUserApp
                                      .toString(),
                                  'id_conducteur': controller
                                      .data.value.idConducteur
                                      .toString(),
                                  'user_type': 'customer',
                                  'description': _complaintDiscriptionController
                                      .text
                                      .toString(),
                                  'title':
                                      _complaintTitleController.text.toString(),
                                };

                                await controller
                                    .addComplaint(bodyParams)
                                    .then((value) {
                                  if (value != null) {
                                    if (value == true) {
                                      ShowToastDialog.showToast(
                                          "Obrigado! O Seu feedback foi enviado com sucesso");
                                      Get.back();
                                    } else {
                                      ShowToastDialog.showToast(
                                          "Algo correu mal, tente mais tarde");
                                    }
                                  }
                                });
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 8,
                        spreadRadius: 6,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: CachedNetworkImage(
                      imageUrl: controller.data.value.photoPath.toString(),
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Constant.loader(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
