import 'package:VEIDI/constant/constant.dart';
import 'package:VEIDI/constant/show_toast_dialog.dart';
import 'package:VEIDI/controller/home_controller.dart';
import 'package:VEIDI/model/driver_model.dart';
import 'package:VEIDI/model/vehicle_category_model.dart';
import 'package:VEIDI/themes/button_them.dart';
import 'package:VEIDI/themes/constant_colors.dart';
import 'package:VEIDI/themes/custom_dialog_box.dart';
import 'package:VEIDI/themes/text_field_them.dart';
import 'package:VEIDI/utils/Preferences.dart';
import 'package:VEIDI/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as get_cord_address;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CameraPosition _kInitialPosition = const CameraPosition(
      target: LatLng(38.736946, -9.142685), zoom: 12.0, tilt: 0, bearing: 0);

  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  final controller = Get.put(HomeController());

  GoogleMapController? _controller;
  final Location currentLocation = Location();

  final Map<String, Marker> _markers = {};

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? taxiIcon;

  LatLng? departureLatLong;
  LatLng? destinationLatLong;

  Map<PolylineId, Polyline> polyLines = {};
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    setIcons();
    super.initState();
  }

  setIcons() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/pickup.png")
        .then((value) {
      departureIcon = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/dropoff.png")
        .then((value) {
      destinationIcon = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/ic_taxi.png")
        .then((value) {
      taxiIcon = value;
    });

    controller.getTaxiData().then((value) {
      if (value != null) {
        if (value.success == "success") {
          for (var element in value.data!) {
            if (element.latitude != null &&
                element.longitude != null &&
                element.latitude!.isNotEmpty &&
                element.longitude!.isNotEmpty &&
                element.statut == "yes") {
              _markers[element.id.toString()] = Marker(
                markerId: MarkerId(element.id.toString()),
                infoWindow: InfoWindow(
                    title: element.prenom.toString(),
                    snippet:
                        "${element.brand},${element.model},${element.numberplate}"),
                position: LatLng(double.parse(element.latitude ?? "0.0"),
                    double.parse(element.longitude ?? "0.0")),
                icon: taxiIcon!,
              );
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getCurrentLocation(bool isDepartureSet) async {
    if (isDepartureSet) {
      LocationData location = await currentLocation.getLocation();
      List<get_cord_address.Placemark> placeMarks =
          await get_cord_address.placemarkFromCoordinates(
              location.latitude ?? 0.0, location.longitude ?? 0.0);

      final address = (placeMarks.first.subLocality!.isEmpty
              ? ''
              : "${placeMarks.first.subLocality}, ") +
          (placeMarks.first.street!.isEmpty
              ? ''
              : "${placeMarks.first.street}, ") +
          (placeMarks.first.name!.isEmpty ? '' : "${placeMarks.first.name}, ") +
          (placeMarks.first.subAdministrativeArea!.isEmpty
              ? ''
              : "${placeMarks.first.subAdministrativeArea}, ") +
          (placeMarks.first.administrativeArea!.isEmpty
              ? ''
              : "${placeMarks.first.administrativeArea}, ") +
          (placeMarks.first.country!.isEmpty
              ? ''
              : "${placeMarks.first.country}, ") +
          (placeMarks.first.postalCode!.isEmpty
              ? ''
              : "${placeMarks.first.postalCode}, ");
      departureController.text = address;
      setState(() {
        setDepartureMarker(
            LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     Get.to(PaymentSelectionScreen());
      //   },
      // ),
      backgroundColor: ConstantColors.background,
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: true,
            myLocationButtonEnabled: true,
            padding: const EdgeInsets.only(
              top: 190.0,
            ),
            initialCameraPosition: _kInitialPosition,
            onMapCreated: (GoogleMapController controller) async {
              _controller = controller;
              LocationData location = await currentLocation.getLocation();
              _controller!.moveCamera(CameraUpdate.newLatLngZoom(
                  LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0),
                  14));
            },
            polylines: Set<Polyline>.of(polyLines.values),
            myLocationEnabled: true,
            markers: _markers.values.toSet(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: ElevatedButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      "assets/icons/ic_side_menu.png",
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/ic_pic_drop_location.png",
                              height: 85,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              await controller
                                                  .placeSelectAPI(context)
                                                  .then((value) {
                                                if (value != null) {
                                                  departureController.text =
                                                      value.result
                                                          .formattedAddress
                                                          .toString();
                                                  setDepartureMarker(LatLng(
                                                      value.result.geometry!
                                                          .location.lat,
                                                      value.result.geometry!
                                                          .location.lng));
                                                }
                                              });
                                            },
                                            child: buildTextField(
                                              title: "Recolha",
                                              textController:
                                                  departureController,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            getCurrentLocation(true);
                                          },
                                          autofocus: false,
                                          icon: const Icon(
                                            Icons.my_location_outlined,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    InkWell(
                                      onTap: () async {
                                        await controller
                                            .placeSelectAPI(context)
                                            .then((value) {
                                          if (value != null) {
                                            destinationController.text = value
                                                .result.formattedAddress
                                                .toString();
                                            setDestinationMarker(LatLng(
                                                value.result.geometry!.location
                                                    .lat,
                                                value.result.geometry!.location
                                                    .lng));
                                          }
                                        });
                                      },
                                      child: buildTextField(
                                        title: "Qual o destino do transporte?",
                                        textController: destinationController,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  setDepartureMarker(LatLng departure) {
    setState(() {
      _markers.remove("Departure");
      _markers['Departure'] = Marker(
        markerId: const MarkerId('Departure'),
        infoWindow: const InfoWindow(title: "Departure"),
        position: departure,
        icon: departureIcon!,
      );
      departureLatLong = departure;
      _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(departure.latitude, departure.longitude), zoom: 14)));

      // _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(departure.latitude, departure.longitude), zoom: 18)));
      if (departureLatLong != null && destinationLatLong != null) {
        getDirections();
        conformationBottomSheet(context);
      }
    });
  }

  setDestinationMarker(LatLng destination) {
    setState(() {
      _markers['Destination'] = Marker(
        markerId: const MarkerId('Destination'),
        infoWindow: const InfoWindow(title: "Destination"),
        position: destination,
        icon: destinationIcon!,
      );
      destinationLatLong = destination;

      if (departureLatLong != null && destinationLatLong != null) {
        getDirections();
        conformationBottomSheet(context);
      }
    });
  }

  Widget buildTextField(
      {required title, required TextEditingController textController}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: title,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabled: false,
        ),
      ),
    );
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    if (departureLatLong != null) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Constant.kGoogleApiKey.toString(),
        PointLatLng(departureLatLong!.latitude, departureLatLong!.longitude),
        PointLatLng(
            destinationLatLong!.latitude, destinationLatLong!.longitude),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }

      addPolyLine(polylineCoordinates);
    }
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: ConstantColors.primary,
      points: polylineCoordinates,
      width: 4,
      geodesic: true,
    );
    polyLines[id] = polyline;
    setState(() {});
  }

  conformationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ButtonThem.buildIconButton(context,
                        iconSize: 16.0,
                        icon: Icons.arrow_back_ios,
                        iconColor: Colors.black,
                        btnHeight: 40,
                        btnWidthRatio: 0.25,
                        title: "Voltar",
                        btnColor: ConstantColors.yellow,
                        txtColor: Colors.black, onPress: () {
                      Get.back();
                    }),
                  ),
                  Expanded(
                    child: ButtonThem.buildButton(context,
                        btnHeight: 40,
                        title: "Continuar".tr,
                        btnColor: ConstantColors.primary,
                        txtColor: Colors.white, onPress: () async {
                      print('entrei no processo');
                      var dist = await controller.getDurationDistance(
                          departureLatLong!, destinationLatLong!);
                      if (dist != null &&
                          double.parse(dist['rows']
                                  .first['elements']
                                  .first['distance']['text']
                                  .split(' ')[0]) >
                              45.0) {
                        Get.back();
                        ShowToastDialog.showToast(
                            "Não fazemos transportes para esse destino");
                        return;
                      }
                      await controller
                          .getDurationDistance(
                              departureLatLong!, destinationLatLong!)
                          .then((durationValue) async {
                        if (durationValue != null) {
                          await controller
                              .getUserPendingPayment()
                              .then((value) async {
                            if (value != null) {
                              if (value['success'] == "success") {
                                if (value['data']['amount'] != 0) {
                                  _pendingPaymentDialog(context);
                                } else {
                                  if (Constant.distanceUnit == "KM") {
                                    controller.distance.value =
                                        durationValue['rows']
                                                .first['elements']
                                                .first['distance']['value'] /
                                            1000.00;
                                  } else {
                                    controller.distance.value =
                                        durationValue['rows']
                                                .first['elements']
                                                .first['distance']['value'] /
                                            1609.34;
                                  }

                                  controller.duration.value =
                                      durationValue['rows']
                                          .first['elements']
                                          .first['duration']['text'];
                                  Get.back();
                                  tripOptionBottomSheet(context);
                                }
                              } else {
                                if (Constant.distanceUnit == "KM") {
                                  controller.distance.value =
                                      durationValue['rows']
                                              .first['elements']
                                              .first['distance']['value'] /
                                          1000.00;
                                } else {
                                  controller.distance.value =
                                      durationValue['rows']
                                              .first['elements']
                                              .first['distance']['value'] /
                                          1609.34;
                                }
                                controller.duration.value =
                                    durationValue['rows']
                                        .first['elements']
                                        .first['duration']['text'];
                                Get.back();
                                tripOptionBottomSheet(context);
                              }
                            }
                          });
                        }
                      });
                    }),
                  ),
                ],
              ),
            );
          });
        });
  }

  final passengerController = TextEditingController();

  tripOptionBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            margin: const EdgeInsets.all(10),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Obx(
                  () => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Opções de Transporte",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton<String>(
                                items: <String>[
                                  'Express',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ); //DropMenuItem
                                }).toList(),
                                value: controller.tripOptionCategory.value,
                                onChanged: (newValue) {
                                  controller.tripOptionCategory.value =
                                      newValue!;
                                },
                                underline: Container(),
                                //OnChange
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                        /* Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: passengerController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              hintText: 'How many passenger',
                            ),
                          ),
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.addChildList.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: controller
                                      .addChildList[index].editingController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    hintText: 'Any children ? Age of child',
                                  ),
                                ),
                              );
                            }),
                        Visibility(
                          visible: controller.addChildList.length < 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (controller.addChildList.length < 3) {
                                      controller.addChildList.add(AddChildModel(
                                          editingController:
                                              TextEditingController()));
                                    }
                                  },
                                  child: SizedBox(
                                    width: 60,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: ConstantColors.primary,
                                        ),
                                        const Text("Add"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ButtonThem.buildIconButton(context,
                                    iconSize: 16.0,
                                    icon: Icons.arrow_back_ios,
                                    iconColor: Colors.black,
                                    btnHeight: 40,
                                    btnWidthRatio: 0.25,
                                    title: "Voltar",
                                    btnColor: ConstantColors.yellow,
                                    txtColor: Colors.black, onPress: () {
                                  Get.back();
                                }),
                              ),
                              Expanded(
                                child: ButtonThem.buildButton(context,
                                    btnHeight: 40,
                                    title: "Pedir Agora".tr,
                                    btnColor: ConstantColors.primary,
                                    txtColor: Colors.white, onPress: () async {
                                  /*if (passengerController.text.isEmpty) {
                                    ShowToastDialog.showToast(
                                        "Please Enter Passenger");
                                  } else */
                                  {
                                    await controller
                                        .getVehicleCategory()
                                        .then((value) {
                                      if (value != null) {
                                        if (value.success == "Success") {
                                          Get.back();
                                          // List tripPrice = [];
                                          // for (int i = 0;
                                          //     i < value.vehicleData!.length;
                                          //     i++) {
                                          //   tripPrice.add(0.0);
                                          // }
                                          // if (value.vehicleData!.isNotEmpty) {
                                          //   for (int i = 0;
                                          //       i < value.vehicleData!.length;
                                          //       i++) {
                                          //     if (controller.distance.value >
                                          //         value.vehicleData![i]
                                          //             .minimumDeliveryChargesWithin!
                                          //             .toDouble()) {
                                          //       tripPrice.add((controller
                                          //                   .distance.value *
                                          //               value.vehicleData![i]
                                          //                   .deliveryCharges!)
                                          //           .toDouble()
                                          //           .toStringAsFixed(
                                          //               int.parse(Constant.decimal ?? "2")));
                                          //     } else {
                                          //       tripPrice.add(value
                                          //           .vehicleData![i]
                                          //           .minimumDeliveryCharges!
                                          //           .toDouble()
                                          //           .toStringAsFixed(
                                          //               int.parse(Constant.decimal ?? "2")));
                                          //     }
                                          //   }
                                          // }
                                          chooseVehicleBottomSheet(
                                            context,
                                            value,
                                          );
                                        }
                                      }
                                    });
                                  }
                                }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

  chooseVehicleBottomSheet(
    BuildContext context,
    VehicleCategoryModel vehicleCategoryModel,
  ) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            margin: const EdgeInsets.all(10),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Selecione o Motorista",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset("assets/icons/ic_distance.png",
                                  height: 24, width: 24),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text("Distância",
                                    style: TextStyle(fontSize: 16)),
                              )
                            ],
                          ),
                        ),
                        Text(
                            "${controller.distance.value.toStringAsFixed(2)} ${Constant.distanceUnit}")
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset("assets/icons/boxes.png",
                                  height: 24, width: 24),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                    "Neste serviço só poderá\ntransportar um total de 3 itens",
                                    style: TextStyle(fontSize: 16)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset("assets/icons/ic_truck.png",
                                  height: 24, width: 24),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                    "As nossas Carrinhas têm \nCapacidade Mínima de 10m3",
                                    style: TextStyle(fontSize: 16)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: 1, // vehicleCategoryModel.data!.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Obx(
                              () => InkWell(
                                onTap: () {
                                  controller.vehicleData =
                                      vehicleCategoryModel.data![index];
                                  controller.selectedVehicle.value =
                                      vehicleCategoryModel.data![index].id
                                          .toString();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: controller
                                                    .selectedVehicle.value ==
                                                vehicleCategoryModel
                                                    .data![index].id
                                                    .toString()
                                            ? ConstantColors.primary
                                            : Colors.black.withOpacity(0.10),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: vehicleCategoryModel
                                                .data![index].image
                                                .toString(),
                                            fit: BoxFit.fill,
                                            width: 80,
                                            height: 50,
                                            placeholder: (context, url) =>
                                                Constant.loader(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    /*child: Text(
                                                      vehicleCategoryModel
                                                          .data![index].libelle
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: controller
                                                                      .selectedVehicle
                                                                      .value ==
                                                                  vehicleCategoryModel
                                                                      .data![
                                                                          index]
                                                                      .id
                                                                      .toString()
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),*/
                                                    child: Text(
                                                      "Parceiro VEIDI",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: controller
                                                                    .selectedVehicle
                                                                    .value ==
                                                                vehicleCategoryModel
                                                                    .data![
                                                                        index]
                                                                    .id
                                                                    .toString()
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        controller
                                                            .duration.value,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: controller
                                                                      .selectedVehicle
                                                                      .value ==
                                                                  vehicleCategoryModel
                                                                      .data![
                                                                          index]
                                                                      .id
                                                                      .toString()
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                      // Text(
                                                      //   "${controller.currency} ${tripPrice[index]} ",
                                                      //   textAlign:
                                                      //       TextAlign.center,
                                                      //   style: TextStyle(
                                                      //     color: controller
                                                      //                 .selectedVehicle
                                                      //                 .value ==
                                                      //             vehicleCategoryModel
                                                      //                 .vehicleData![
                                                      //                     index]
                                                      //                 .id
                                                      //                 .toString()
                                                      //         ? Colors.white
                                                      //         : Colors.black,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ButtonThem.buildIconButton(context,
                                iconSize: 16.0,
                                icon: Icons.arrow_back_ios,
                                iconColor: Colors.black,
                                btnHeight: 40,
                                btnWidthRatio: 0.25,
                                title: "Voltar",
                                btnColor: ConstantColors.yellow,
                                txtColor: Colors.black, onPress: () {
                              Get.back();
                              tripOptionBottomSheet(context);
                            }),
                          ),
                          Expanded(
                            child: ButtonThem.buildButton(context,
                                btnHeight: 40,
                                title: "Pedir Agora".tr,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white, onPress: () async {
                              if (controller.selectedVehicle.value.isNotEmpty) {
                                double cout = 0.0;
                                //TO DO
                                if (controller.distance.value >
                                    double.parse(controller.vehicleData!
                                        .minimumDeliveryChargesWithin!)) {
                                  cout = (controller.distance.value *
                                          double.parse(controller
                                              .vehicleData!.deliveryCharges!))
                                      .toDouble();
                                } else {
                                  cout = double.parse(controller
                                      .vehicleData!.minimumDeliveryCharges
                                      .toString());
                                }

                                // double cout = double.parse(controller
                                //         .vehicleData!.prix
                                //         .toString()) *
                                //     controller.distance.value;

                                // if (controller.vehicleData!.statutCommission ==
                                //         "yes" &&
                                //     controller.vehicleData!
                                //             .statutCommissionPerc ==
                                //         "yes") {
                                //   double coutFixed = double.parse(controller
                                //       .vehicleData!.commission
                                //       .toString());
                                //   double coutPerc = cout +
                                //       (cout +
                                //           double.parse(controller
                                //               .vehicleData!.commissionPerc
                                //               .toString()));
                                //   cout = coutFixed + coutPerc;
                                // } else if (controller
                                //         .vehicleData!.statutCommission ==
                                //     "yes") {
                                //   cout = cout +
                                //       double.parse(controller
                                //           .vehicleData!.commission
                                //           .toString());
                                // } else {
                                //   cout = cout +
                                //       (cout +
                                //           double.parse(controller
                                //               .vehicleData!.commissionPerc
                                //               .toString()));
                                // }

                                await controller
                                    .getDriverDetails(
                                        controller.vehicleData!.id.toString(),
                                        departureLatLong!.latitude.toString(),
                                        departureLatLong!.longitude.toString())
                                    .then((value) {
                                  if (value != null) {
                                    if (value.success == "Success") {
                                      Get.back();
                                      conformDataBottomSheet(
                                          context, value, cout);
                                    } else {
                                      ShowToastDialog.showToast(
                                          "Não há motoristas disponiveis");
                                    }
                                  }
                                });
                              } else {
                                ShowToastDialog.showToast(
                                    "Selecione o motorista");
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  conformDataBottomSheet(
      BuildContext context, DriverModel driverModel, double tripPrice) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            margin: const EdgeInsets.all(10),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: driverModel.data![0].photo.toString(),
                                fit: BoxFit.cover,
                                height: 72,
                                width: 72,
                                placeholder: (context, url) =>
                                    Constant.loader(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  driverModel.data![0].prenom.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: ConstantColors.titleTextColor,
                                      fontWeight: FontWeight.w800),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: StarRating(
                                      size: 18,
                                      rating: double.parse(driverModel
                                          .data![0].moyenne
                                          .toString()),
                                      color: ConstantColors.yellow),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    "${driverModel.data![0].totalCompletedRide.toString()} Transportes",
                                    style: TextStyle(
                                      color: ConstantColors.subTitleTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Constant.makePhoneCall(
                                      driverModel.data![0].toString());
                                },
                                child: ClipOval(
                                  child: Container(
                                    color: ConstantColors.primary,
                                    child: const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.phone,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: InkWell(
                                    onTap: () {
                                      _favouriteNameDialog(context);
                                    },
                                    child: Image.asset(
                                      'assets/icons/add_fav.png',
                                      height: 32,
                                      width: 32,
                                    )),
                              ),
                            ],
                          )*/
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _paymentMethodDialog(
                                    context,
                                  );
                                },
                                child: buildDetails(
                                    title: controller.paymentMethodType.value,
                                    value: 'Pagamento'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: buildDetails(
                                    title: controller.duration.value,
                                    value: 'Duração Estimada')),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: buildDetails(
                                    title: "${Constant.currency.toString()} 65",
                                    //"${Constant.currency.toString()} ${tripPrice.toStringAsFixed(int.parse(Constant.decimal ?? "2"))}",
                                    value: 'Preço do Transporte',
                                    txtColor: ConstantColors.primary)),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade700,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Opacity(
                            opacity: 0.6,
                            child: Text(
                              "Carrinha:",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            driverModel.data![0].model.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            driverModel.data![0].brand.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            driverModel.data![0].numberplate.toString(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ButtonThem.buildIconButton(context,
                                iconSize: 16.0,
                                icon: Icons.arrow_back_ios,
                                iconColor: Colors.black,
                                btnHeight: 40,
                                btnWidthRatio: 0.25,
                                title: "Voltar",
                                btnColor: ConstantColors.yellow,
                                txtColor: Colors.black, onPress: () async {
                              await controller
                                  .getVehicleCategory()
                                  .then((value) {
                                if (value != null) {
                                  if (value.success == "Success") {
                                    Get.back();
                                    List tripPrice = [];
                                    for (int i = 0;
                                        i < value.data!.length;
                                        i++) {
                                      tripPrice.add(0.0);
                                    }
                                    if (value.data!.isNotEmpty) {
                                      for (int i = 0;
                                          i < value.data!.length;
                                          i++) {
                                        if (controller.distance.value >
                                            double.parse(value.data![i]
                                                .minimumDeliveryChargesWithin!)) {
                                          tripPrice.add(50.0);
                                          /* tripPrice.add((controller
                                                      .distance.value *
                                                  double.parse(value.data![i]
                                                      .deliveryCharges!))
                                              .toDouble()
                                              .toStringAsFixed(int.parse(
                                                  Constant.decimal ?? "2")));*/
                                        } else {
                                          tripPrice.add(50.0);
                                          /*tripPrice.add(double.parse(value
                                                  .data![i]
                                                  .minimumDeliveryCharges!)
                                              .toStringAsFixed(int.parse(
                                                  Constant.decimal ?? "2")));*/
                                        }
                                      }
                                    }
                                    chooseVehicleBottomSheet(
                                      context,
                                      value,
                                    );
                                  }
                                }
                              });
                            }),
                          ),
                          Expanded(
                            child: ButtonThem.buildButton(context,
                                btnHeight: 40,
                                title: "Pedir Veidi".tr,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white, onPress: () {
                              if (controller.paymentMethodType.value ==
                                  "Select Method") {
                                ShowToastDialog.showToast(
                                    "Selecione o meio de pagamento");
                              } else {
                                Map<String, String> bodyParams = {
                                  'user_id':
                                      Preferences.getInt(Preferences.userId)
                                          .toString(),
                                  'lat1': departureLatLong!.latitude.toString(),
                                  'lng1':
                                      departureLatLong!.longitude.toString(),
                                  'lat2':
                                      destinationLatLong!.latitude.toString(),
                                  'lng2':
                                      destinationLatLong!.longitude.toString(),
                                  'cout': "50", //tripPrice.toString(),
                                  'distance': controller.distance.toString(),
                                  'distance_unit':
                                      Constant.distanceUnit.toString(),
                                  'duree': controller.duration.toString(),
                                  'id_conducteur':
                                      driverModel.data![0].id.toString(),
                                  'id_payment':
                                      controller.paymentMethodId.value,
                                  'depart_name': departureController.text,
                                  'destination_name':
                                      destinationController.text,
                                  'place': '',
                                  'number_poeple': passengerController.text,
                                  'image': '',
                                  'image_name': "",
                                  'statut_round': 'no',
                                  'trip_objective':
                                      controller.tripOptionCategory.value,
                                  'age_children1': controller
                                      .addChildList[0].editingController.text,
                                  'age_children2':
                                      controller.addChildList.length == 2
                                          ? controller.addChildList[1]
                                              .editingController.text
                                          : "",
                                  'age_children3':
                                      controller.addChildList.length == 3
                                          ? controller.addChildList[2]
                                              .editingController.text
                                          : "",
                                };

                                controller.bookRide(bodyParams).then((value) {
                                  if (value != null) {
                                    if (value['success'] == "success") {
                                      Get.back();
                                      departureController.clear();
                                      destinationController.clear();
                                      polyLines = {};
                                      departureLatLong = null;
                                      destinationLatLong = null;
                                      passengerController.clear();
                                      tripPrice = 50.0;
                                      _markers.clear();
                                      controller.clearData();
                                      getDirections();
                                      setIcons();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                              title: "",
                                              descriptions:
                                                  "Your booking has been sent successfully",
                                              onPress: () {
                                                Get.back();
                                              },
                                              img: Image.asset(
                                                  'assets/images/green_checked.png'),
                                            );
                                          });
                                    }
                                  }
                                });
                              }
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  final favouriteNameTextController = TextEditingController();

  _favouriteNameDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Favourite Name"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldThem.buildTextField(
                  title: 'Favourite name'.tr,
                  labelText: 'Favourite name'.tr,
                  controller: favouriteNameTextController,
                  textInputType: TextInputType.text,
                  contentPadding: EdgeInsets.zero,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Text("Cancel")),
                      InkWell(
                          onTap: () {
                            Map<String, String> bodyParams = {
                              'id_user_app':
                                  Preferences.getInt(Preferences.userId)
                                      .toString(),
                              'lat1': departureLatLong!.latitude.toString(),
                              'lng1': departureLatLong!.longitude.toString(),
                              'lat2': destinationLatLong!.latitude.toString(),
                              'lng2': destinationLatLong!.longitude.toString(),
                              'distance': controller.distance.value.toString(),
                              'distance_unit': Constant.distanceUnit.toString(),
                              'depart_name': departureController.text,
                              'destination_name': destinationController.text,
                              'fav_name': favouriteNameTextController.text,
                            };
                            controller
                                .setFavouriteRide(bodyParams)
                                .then((value) {
                              if (value['success'] == "Success") {
                                Get.back();
                              } else {
                                print('Tenho um erro!!!');
                                ShowToastDialog.showToast(value['error']);
                              }
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Ok"),
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  _pendingPaymentDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Veidi"),
      content: const Text(
          "Tens Pagamentos pendentes. Completa-os antes de prosseguires"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _paymentMethodDialog(
    BuildContext context,
  ) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Selecionar Método de Pagamento"),
                      Divider(
                        color: Colors.grey.shade700,
                      ),
                      /*Visibility(
                        visible:
                            controller.paymentSettingModel.value.cash != null &&
                                    controller.paymentSettingModel.value.cash!
                                            .isEnabled ==
                                        "true"
                                ? true
                                : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: controller.cash.value ? 0 : 2,
                            child: RadioListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: controller.cash.value
                                          ? ConstantColors.primary
                                          : Colors.transparent)),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "Cash",
                              groupValue: controller.paymentMethodType.value,
                              onChanged: (String? value) {
                                controller.stripe = false.obs;
                                controller.wallet = false.obs;
                                controller.cash = true.obs;
                                controller.razorPay = false.obs;
                                controller.payTm = false.obs;
                                controller.paypal = false.obs;
                                controller.payStack = false.obs;
                                controller.flutterWave = false.obs;
                                controller.mercadoPago = false.obs;
                                controller.payFast = false.obs;
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId = controller
                                    .paymentSettingModel
                                    .value
                                    .cash!
                                    .idPaymentMethod
                                    .toString()
                                    .obs;

                                Get.back();
                              },
                              selected: controller.cash.value,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: SizedBox(
                                          width: 80,
                                          height: 35,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Image.asset(
                                              "assets/images/cash.png",
                                            ),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("Cash"),
                                ],
                              ),
                              //toggleable: true,
                            ),
                          ),
                        ),
                      ),*/
                      Visibility(
                        visible:
                            controller.paymentSettingModel.value.myWallet !=
                                        null &&
                                    controller.paymentSettingModel.value
                                            .myWallet!.isEnabled ==
                                        "true"
                                ? true
                                : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: controller.wallet.value ? 0 : 2,
                            child: RadioListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: controller.wallet.value
                                          ? ConstantColors.primary
                                          : Colors.transparent)),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "Carteira",
                              groupValue: controller.paymentMethodType.value,
                              onChanged: (String? value) {
                                controller.stripe = false.obs;
                                controller.wallet = true.obs;
                                controller.cash = false.obs;
                                controller.razorPay = false.obs;
                                controller.payTm = false.obs;
                                controller.paypal = false.obs;
                                controller.payStack = false.obs;
                                controller.flutterWave = false.obs;
                                controller.mercadoPago = false.obs;
                                controller.payFast = false.obs;
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId = controller
                                    .paymentSettingModel
                                    .value
                                    .myWallet!
                                    .idPaymentMethod
                                    .toString()
                                    .obs;
                                Get.back();
                              },
                              selected: controller.wallet.value,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: SizedBox(
                                          width: 80,
                                          height: 35,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Image.asset(
                                              "assets/icons/walltet_icons.png",
                                            ),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("Carteira"),
                                ],
                              ),
                              //toggleable: true,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.paymentSettingModel.value.strip !=
                                    null &&
                                controller.paymentSettingModel.value.strip!
                                        .isEnabled ==
                                    "true"
                            ? true
                            : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: controller.stripe.value ? 0 : 2,
                            child: RadioListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: controller.stripe.value
                                          ? ConstantColors.primary
                                          : Colors.transparent)),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "Associar cartão",
                              groupValue: controller.paymentMethodType.value,
                              onChanged: (String? value) {
                                controller.stripe = true.obs;
                                controller.wallet = false.obs;
                                controller.cash = false.obs;
                                controller.razorPay = false.obs;
                                controller.payTm = false.obs;
                                controller.paypal = false.obs;
                                controller.payStack = false.obs;
                                controller.flutterWave = false.obs;
                                controller.mercadoPago = false.obs;
                                controller.payFast = false.obs;
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId = controller
                                    .paymentSettingModel
                                    .value
                                    .strip!
                                    .idPaymentMethod
                                    .toString()
                                    .obs;
                                Get.back();
                              },
                              selected: controller.stripe.value,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: SizedBox(
                                          width: 80,
                                          height: 35,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Image.asset(
                                              "assets/images/stripe.png",
                                            ),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("Associar Cartão"),
                                ],
                              ),
                              //toggleable: true,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            controller.paymentSettingModel.value.payStack !=
                                        null &&
                                    controller.paymentSettingModel.value
                                            .payStack!.isEnabled ==
                                        "true"
                                ? true
                                : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: controller.payStack.value ? 0 : 2,
                            child: RadioListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: controller.payStack.value
                                          ? ConstantColors.primary
                                          : Colors.transparent)),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "PayStack",
                              groupValue: controller.paymentMethodType.value,
                              onChanged: (String? value) {
                                controller.stripe = false.obs;
                                controller.wallet = false.obs;
                                controller.cash = false.obs;
                                controller.razorPay = false.obs;
                                controller.payTm = false.obs;
                                controller.paypal = false.obs;
                                controller.payStack = true.obs;
                                controller.flutterWave = false.obs;
                                controller.mercadoPago = false.obs;
                                controller.payFast = false.obs;
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId = controller
                                    .paymentSettingModel
                                    .value
                                    .payStack!
                                    .idPaymentMethod
                                    .toString()
                                    .obs;
                                Get.back();
                              },
                              selected: controller.payStack.value,
                              //selectedRadioTile == "strip" ? true : false,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: SizedBox(
                                          width: 80,
                                          height: 35,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Image.asset(
                                              "assets/images/paystack.png",
                                            ),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("PayStack"),
                                ],
                              ),
                              //toggleable: true,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            controller.paymentSettingModel.value.flutterWave !=
                                        null &&
                                    controller.paymentSettingModel.value
                                            .flutterWave!.isEnabled ==
                                        "true"
                                ? true
                                : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: controller.flutterWave.value ? 0 : 2,
                            child: RadioListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: controller.flutterWave.value
                                          ? ConstantColors.primary
                                          : Colors.transparent)),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "FlutterWave",
                              groupValue: controller.paymentMethodType.value,
                              onChanged: (String? value) {
                                controller.stripe = false.obs;
                                controller.wallet = false.obs;
                                controller.cash = false.obs;
                                controller.razorPay = false.obs;
                                controller.payTm = false.obs;
                                controller.paypal = false.obs;
                                controller.payStack = false.obs;
                                controller.flutterWave = true.obs;
                                controller.mercadoPago = false.obs;
                                controller.payFast = false.obs;
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .flutterWave!
                                    .idPaymentMethod
                                    .toString();
                                Get.back();
                              },
                              selected: controller.flutterWave.value,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: SizedBox(
                                          width: 80,
                                          height: 35,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Image.asset(
                                              "assets/images/flutterwave.png",
                                            ),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("FlutterWave"),
                                ],
                              ),
                              //toggleable: true,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            controller.paymentSettingModel.value.razorpay !=
                                        null &&
                                    controller.paymentSettingModel.value
                                            .razorpay!.isEnabled ==
                                        "true"
                                ? true
                                : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: controller.razorPay.value ? 0 : 2,
                            child: RadioListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: controller.razorPay.value
                                          ? ConstantColors.primary
                                          : Colors.transparent)),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "RazorPay",
                              groupValue: controller.paymentMethodType.value,
                              onChanged: (String? value) {
                                controller.stripe = false.obs;
                                controller.wallet = false.obs;
                                controller.cash = false.obs;
                                controller.razorPay = true.obs;
                                controller.payTm = false.obs;
                                controller.paypal = false.obs;
                                controller.payStack = false.obs;
                                controller.flutterWave = false.obs;
                                controller.mercadoPago = false.obs;
                                controller.payFast = false.obs;
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .razorpay!
                                    .idPaymentMethod
                                    .toString();
                                Get.back();
                              },
                              selected: controller.razorPay.value,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0),
                                        child: SizedBox(
                                            width: 80,
                                            height: 35,
                                            child: Image.asset(
                                                "assets/images/razorpay_@3x.png")),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("RazorPay"),
                                ],
                              ),
                              //toggleable: true,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.paymentSettingModel.value.payFast !=
                                    null &&
                                controller.paymentSettingModel.value.payFast!
                                        .isEnabled ==
                                    "true"
                            ? true
                            : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: controller.payFast.value ? 0 : 2,
                            child: RadioListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: controller.payFast.value
                                          ? ConstantColors.primary
                                          : Colors.transparent)),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "PayFast",
                              groupValue: controller.paymentMethodType.value,
                              onChanged: (String? value) {
                                controller.stripe = false.obs;
                                controller.wallet = false.obs;
                                controller.cash = false.obs;
                                controller.razorPay = false.obs;
                                controller.payTm = false.obs;
                                controller.paypal = false.obs;
                                controller.payStack = false.obs;
                                controller.flutterWave = false.obs;
                                controller.mercadoPago = false.obs;
                                controller.payFast = true.obs;
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .payFast!
                                    .idPaymentMethod
                                    .toString();
                                Get.back();
                              },
                              selected: controller.payFast.value,
                              //selectedRadioTile == "strip" ? true : false,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: SizedBox(
                                          width: 80,
                                          height: 35,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Image.asset(
                                              "assets/images/payfast.png",
                                            ),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("Pay Fast"),
                                ],
                              ),
                              //toggleable: true,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.paymentSettingModel.value.paytm !=
                                    null &&
                                controller.paymentSettingModel.value.paytm!
                                        .isEnabled ==
                                    "true"
                            ? true
                            : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: controller.payTm.value ? 0 : 2,
                            child: RadioListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: controller.payTm.value
                                          ? ConstantColors.primary
                                          : Colors.transparent)),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "PayTm",
                              groupValue: controller.paymentMethodType.value,
                              onChanged: (String? value) {
                                controller.stripe = false.obs;
                                controller.wallet = false.obs;
                                controller.cash = false.obs;
                                controller.razorPay = false.obs;
                                controller.payTm = true.obs;
                                controller.paypal = false.obs;
                                controller.payStack = false.obs;
                                controller.flutterWave = false.obs;
                                controller.mercadoPago = false.obs;
                                controller.payFast = false.obs;
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .paytm!
                                    .idPaymentMethod
                                    .toString();
                                Get.back();
                              },
                              selected: controller.payTm.value,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0),
                                        child: SizedBox(
                                            width: 80,
                                            height: 35,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3.0),
                                              child: Image.asset(
                                                "assets/images/paytm_@3x.png",
                                              ),
                                            )),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("Paytm"),
                                ],
                              ),
                              //toggleable: true,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            controller.paymentSettingModel.value.mercadopago !=
                                        null &&
                                    controller.paymentSettingModel.value
                                            .mercadopago!.isEnabled ==
                                        "true"
                                ? true
                                : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: controller.mercadoPago.value ? 0 : 2,
                            child: RadioListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: controller.mercadoPago.value
                                          ? ConstantColors.primary
                                          : Colors.transparent)),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "MercadoPago",
                              groupValue: controller.paymentMethodType.value,
                              onChanged: (String? value) {
                                controller.stripe = false.obs;
                                controller.wallet = false.obs;
                                controller.cash = false.obs;
                                controller.razorPay = false.obs;
                                controller.payTm = false.obs;
                                controller.paypal = false.obs;
                                controller.payStack = false.obs;
                                controller.flutterWave = false.obs;
                                controller.mercadoPago = true.obs;
                                controller.payFast = false.obs;
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .mercadopago!
                                    .idPaymentMethod
                                    .toString();
                                Get.back();
                              },
                              selected: controller.mercadoPago.value,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: SizedBox(
                                          width: 80,
                                          height: 35,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Image.asset(
                                              "assets/images/mercadopago.png",
                                            ),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("Mercado Pago"),
                                ],
                              ),
                              //toggleable: true,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.paymentSettingModel.value.payPal !=
                                    null &&
                                controller.paymentSettingModel.value.payPal!
                                        .isEnabled ==
                                    "true"
                            ? true
                            : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: controller.paypal.value ? 0 : 2,
                            child: RadioListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color: controller.paypal.value
                                          ? ConstantColors.primary
                                          : Colors.transparent)),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: "PayPal",
                              groupValue: controller.paymentMethodType.value,
                              onChanged: (String? value) {
                                controller.stripe = false.obs;
                                controller.wallet = false.obs;
                                controller.cash = false.obs;
                                controller.razorPay = false.obs;
                                controller.payTm = false.obs;
                                controller.paypal = true.obs;
                                controller.payStack = false.obs;
                                controller.flutterWave = false.obs;
                                controller.mercadoPago = false.obs;
                                controller.payFast = false.obs;
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .payPal!
                                    .idPaymentMethod
                                    .toString();
                                Get.back();
                              },
                              selected: controller.paypal.value,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0),
                                        child: SizedBox(
                                            width: 80,
                                            height: 35,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3.0),
                                              child: Image.asset(
                                                  "assets/images/paypal_@3x.png"),
                                            )),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("PayPal"),
                                ],
                              ),
                              //toggleable: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  // _paymentMethodDialog(BuildContext context, List<PaymentMethodData>? data) {
  //   return showModalBottomSheet(
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topRight: Radius.circular(15), topLeft: Radius.circular(15))),
  //       context: context,
  //       isScrollControlled: true,
  //       isDismissible: false,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, setState) {
  //           return Padding(
  //             padding:
  //                 const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const Text("Select Payment Method1"),
  //                 Divider(
  //                   color: Colors.grey.shade700,
  //                 ),
  //                 ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: data!.length,
  //                   itemBuilder: (context, index) {
  //                     return InkWell(
  //                       onTap: () {
  //                         controller.paymentMethodData = data[index];
  //                         controller.paymentMethodType.value =
  //                             data[index].libelle.toString();
  //                         Get.back();
  //                       },
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Row(
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.symmetric(
  //                                   vertical: 8, horizontal: 5),
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.blueGrey.shade50,
  //                                   borderRadius: BorderRadius.circular(8),
  //                                 ),
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.symmetric(
  //                                       vertical: 4.0),
  //                                   child: SizedBox(
  //                                     width: 80,
  //                                     height: 35,
  //                                     child: Padding(
  //                                       padding: const EdgeInsets.symmetric(
  //                                           vertical: 6.0),
  //                                       child: CachedNetworkImage(
  //                                         imageUrl: data[index].image!,
  //                                         placeholder: (context, url) =>
  //                                             const CircularProgressIndicator(),
  //                                         errorWidget: (context, url, error) =>
  //                                             const Icon(Icons.error),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 10),
  //                               child: Text(
  //                                 data[index].libelle.toString(),
  //                                 style: const TextStyle(color: Colors.black),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 )
  //               ],
  //             ),
  //           );
  //         });
  //       });
  // }

  buildDetails({title, value, Color txtColor = Colors.black}) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.9,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15, color: txtColor, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
