class RideModel {
  String? success;
  String? error;
  String? message;
  List<RideData>? data;

  RideModel({this.success, this.error, this.message, this.data});

  RideModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RideData>[];
      json['data'].forEach((v) {
        data!.add(RideData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RideData {
  int? id;
  String? idUserApp;
  String? distanceUnit;
  String? departName;
  String? destinationName;
  String? latitudeDepart;
  String? longitudeDepart;
  String? latitudeArrivee;
  String? longitudeArrivee;
  String? numberPoeple;
  String? place;
  String? statut;
  String? idConducteur;
  String? creer;
  String? trajet;
  String? feelSafeDriver;
  String? nom;
  String? prenom;
  String? distance;
  String? phone;
  String? photoPath;
  String? nomConducteur;
  String? prenomConducteur;
  String? driverPhone;
  String? dateRetour;
  String? heureRetour;
  String? statutRound;
  String? montant;
  String? duree;
  int? userId;
  String? statutPaiement;
  String? payment;
  String? paymentImage;
  String? tripObjective;
  String? ageChildren1;
  String? ageChildren2;
  String? ageChildren3;
  String? moyenne;
  String? moyenneDriver;
  int? idVehicule;
  String? brand;
  String? model;
  String? carMake;
  String? milage;
  String? km;
  String? color;
  String? numberplate;
  String? passenger;
  String? tax;
  String? discount;
  String? tipAmount;
  String? otp;

  RideData(
      {this.id,
      this.idUserApp,
      this.distanceUnit,
      this.departName,
      this.destinationName,
      this.latitudeDepart,
      this.longitudeDepart,
      this.latitudeArrivee,
      this.longitudeArrivee,
      this.numberPoeple,
      this.place,
      this.statut,
      this.idConducteur,
      this.creer,
      this.trajet,
      this.feelSafeDriver,
      this.nom,
      this.prenom,
      this.distance,
      this.phone,
      this.photoPath,
      this.nomConducteur,
      this.prenomConducteur,
      this.driverPhone,
      this.dateRetour,
      this.heureRetour,
      this.statutRound,
      this.montant,
      this.duree,
      this.userId,
      this.statutPaiement,
      this.payment,
      this.paymentImage,
      this.tripObjective,
      this.ageChildren1,
      this.ageChildren2,
      this.ageChildren3,
      this.moyenne,
      this.moyenneDriver,
      this.idVehicule,
      this.brand,
      this.model,
      this.carMake,
      this.milage,
      this.km,
      this.color,
      this.numberplate,
      this.passenger,
      this.tax,
      this.discount,
      this.tipAmount,
        this.otp,});

  RideData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUserApp = json['id_user_app'];
    distanceUnit = json['distance_unit'];
    departName = json['depart_name'];
    destinationName = json['destination_name'];
    latitudeDepart = json['latitude_depart'];
    longitudeDepart = json['longitude_depart'];
    latitudeArrivee = json['latitude_arrivee'];
    longitudeArrivee = json['longitude_arrivee'];
    numberPoeple = json['number_poeple'];
    place = json['place'];
    statut = json['statut'];
    idConducteur = json['id_conducteur'];
    creer = json['creer'];
    trajet = json['trajet'];
    feelSafeDriver = json['feel_safe_driver'];
    nom = json['nom'];
    prenom = json['prenom'];
    distance = json['distance'];
    phone = json['phone'];
    photoPath = json['photo_path'];
    nomConducteur = json['nomConducteur'];
    prenomConducteur = json['prenomConducteur'];
    driverPhone = json['driverPhone'];
    dateRetour = json['date_retour'];
    heureRetour = json['heure_retour'];
    statutRound = json['statut_round'];
    montant = json['montant'];
    duree = json['duree'];
    userId = json['userId'];
    statutPaiement = json['statut_paiement'];
    payment = json['payment'];
    paymentImage = json['payment_image'];
    tripObjective = json['trip_objective'];
    ageChildren1 = json['age_children1'];
    ageChildren2 = json['age_children2'];
    ageChildren3 = json['age_children3'];
    driverPhone = json['driver_phone'];
    moyenne = json['moyenne'];
    moyenneDriver = json['moyenne_driver'];
    idVehicule = json['idVehicule'];
    brand = json['brand'];
    model = json['model'];
    carMake = json['car_make'];
    milage = json['milage'];
    km = json['km'];
    color = json['color'];
    numberplate = json['numberplate'];
    passenger = json['passenger'];
    discount = json['discount'];
    tipAmount = json['tip_amount'];
    otp = json['otp']??'';
    tax = json['tax'] != null ? json['tax'].toString() : "0.0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_user_app'] = idUserApp;
    data['distance_unit'] = distanceUnit;
    data['depart_name'] = departName;
    data['destination_name'] = destinationName;
    data['latitude_depart'] = latitudeDepart;
    data['longitude_depart'] = longitudeDepart;
    data['latitude_arrivee'] = latitudeArrivee;
    data['longitude_arrivee'] = longitudeArrivee;
    data['number_poeple'] = numberPoeple;
    data['place'] = place;
    data['statut'] = statut;
    data['id_conducteur'] = idConducteur;
    data['creer'] = creer;
    data['trajet'] = trajet;
    data['feel_safe_driver'] = feelSafeDriver;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['distance'] = distance;
    data['phone'] = phone;
    data['photo_path'] = photoPath;
    data['nomConducteur'] = nomConducteur;
    data['prenomConducteur'] = prenomConducteur;
    data['driverPhone'] = driverPhone;
    data['date_retour'] = dateRetour;
    data['heure_retour'] = heureRetour;
    data['statut_round'] = statutRound;
    data['montant'] = montant;
    data['duree'] = duree;
    data['userId'] = userId;
    data['statut_paiement'] = statutPaiement;
    data['payment'] = payment;
    data['payment_image'] = paymentImage;
    data['trip_objective'] = tripObjective;
    data['age_children1'] = ageChildren1;
    data['age_children2'] = ageChildren2;
    data['age_children3'] = ageChildren3;
    data['driver_phone'] = driverPhone;
    data['moyenne'] = moyenne;
    data['moyenne_driver'] = moyenneDriver;
    data['idVehicule'] = idVehicule;
    data['brand'] = brand;
    data['model'] = model;
    data['car_make'] = carMake;
    data['milage'] = milage;
    data['km'] = km;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['passenger'] = passenger;
    data['tax'] = tax;
    data['discount'] = discount;
    data['tip_amount'] = tipAmount;
    data['otp'] = otp;
    return data;
  }
}
