class FavoriteModel {
  String? success;
  String? error;
  List<Data>? data;

  FavoriteModel({this.success, this.error, this.data});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? libelle;
  String? latitudeDepart;
  String? longitudeDepart;
  String? latitudeArrivee;
  String? longitudeArrivee;
  String? departName;
  String? destinationName;
  String? distance;
  String? distanceUnit;
  String? statut;
  String? creer;
  String? modifier;
  int? idUserApp;

  Data(
      {this.id,
      this.libelle,
      this.latitudeDepart,
      this.longitudeDepart,
      this.latitudeArrivee,
      this.longitudeArrivee,
      this.departName,
      this.destinationName,
      this.distance,
      this.distanceUnit,
      this.statut,
      this.creer,
      this.modifier,
      this.idUserApp});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    latitudeDepart = json['latitude_depart'];
    longitudeDepart = json['longitude_depart'];
    latitudeArrivee = json['latitude_arrivee'];
    longitudeArrivee = json['longitude_arrivee'];
    departName = json['depart_name'];
    destinationName = json['destination_name'];
    distance = json['distance'];
    distanceUnit = json['distance_unit'];
    statut = json['statut'];
    creer = json['creer'];
    modifier = json['modifier'];
    idUserApp = json['id_user_app'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['latitude_depart'] = latitudeDepart;
    data['longitude_depart'] = longitudeDepart;
    data['latitude_arrivee'] = latitudeArrivee;
    data['longitude_arrivee'] = longitudeArrivee;
    data['depart_name'] = departName;
    data['destination_name'] = destinationName;
    data['distance'] = distance;
    data['distance_unit'] = distanceUnit;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['id_user_app'] = idUserApp;
    return data;
  }
}
