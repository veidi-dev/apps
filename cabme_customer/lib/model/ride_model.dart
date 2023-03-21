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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  String? departName;
  String? distanceUnit;
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
  String? tripObjective;
  String? tripCategory;
  String? nom;
  String? prenom;
  String? otp;
  String? distance;
  String? phone;
  String? nomConducteur;
  String? prenomConducteur;
  String? driverPhone;
  String? photoPath;
  String? dateRetour;
  String? heureRetour;
  String? statutRound;
  String? montant;
  String? duree;
  String? statutPaiement;
  String? payment;
  String? paymentImage;
  int? idVehicule;
  String? brand;
  String? model;
  String? carMake;
  String? milage;
  String? km;
  String? color;
  String? numberplate;
  String? passenger;
  String? moyenne;
  String? moyenneDriver;

  RideData(
      {this.id,
      this.idUserApp,
      this.departName,
      this.distanceUnit,
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
      this.tripObjective,
      this.tripCategory,
      this.nom,
      this.prenom,
      this.otp,
      this.distance,
      this.phone,
      this.nomConducteur,
      this.prenomConducteur,
      this.driverPhone,
      this.photoPath,
      this.dateRetour,
      this.heureRetour,
      this.statutRound,
      this.montant,
      this.duree,
      this.statutPaiement,
      this.payment,
      this.paymentImage,
      this.idVehicule,
      this.brand,
      this.model,
      this.carMake,
      this.milage,
      this.km,
      this.color,
      this.numberplate,
      this.passenger,
      this.moyenne,
      this.moyenneDriver});

  RideData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUserApp = json['id_user_app'];
    departName = json['depart_name'];
    distanceUnit = json['distance_unit'];
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
    tripObjective = json['trip_objective'];
    tripCategory = json['trip_category'];
    nom = json['nom'];
    prenom = json['prenom'];
    otp = json['otp']??'';
    distance = json['distance'];
    phone = json['phone'];
    nomConducteur = json['nomConducteur'];
    prenomConducteur = json['prenomConducteur'];
    driverPhone = json['driverPhone'];
    photoPath = json['photo_path'];
    dateRetour = json['date_retour'];
    heureRetour = json['heure_retour'];
    statutRound = json['statut_round'];
    montant = json['montant'];
    duree = json['duree'];
    statutPaiement = json['statut_paiement'];
    payment = json['payment'];
    paymentImage = json['payment_image'];
    idVehicule = json['idVehicule'];
    brand = json['brand'];
    model = json['model'];
    carMake = json['car_make'];
    milage = json['milage'];
    km = json['km'];
    color = json['color'];
    numberplate = json['numberplate'];
    passenger = json['passenger'];
    driverPhone = json['driver_phone'];
    moyenne = json['moyenne'];
    moyenneDriver = json['moyenne_driver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['id_user_app'] = idUserApp;
    data['depart_name'] = departName;
    data['distance_unit'] = distanceUnit;
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
    data['trip_objective'] = tripObjective;
    data['trip_category'] = tripCategory;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['otp'] = otp;
    data['distance'] = distance;
    data['phone'] = phone;
    data['nomConducteur'] = nomConducteur;
    data['prenomConducteur'] = prenomConducteur;
    data['driverPhone'] = driverPhone;
    data['photo_path'] = photoPath;
    data['date_retour'] = dateRetour;
    data['heure_retour'] = heureRetour;
    data['statut_round'] = statutRound;
    data['montant'] = montant;
    data['duree'] = duree;
    data['statut_paiement'] = statutPaiement;
    data['payment'] = payment;
    data['payment_image'] = paymentImage;
    data['idVehicule'] = idVehicule;
    data['brand'] = brand;
    data['model'] = model;
    data['car_make'] = carMake;
    data['milage'] = milage;
    data['km'] = km;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['passenger'] = passenger;
    data['driver_phone'] = driverPhone;
    data['moyenne'] = moyenne;
    data['moyenne_driver'] = moyenneDriver;
    return data;
  }
}
