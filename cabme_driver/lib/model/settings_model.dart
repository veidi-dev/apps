class SettingsModel {
  String? success;
  String? error;
  String? message;
  Data? data;

  SettingsModel({this.success, this.error, this.message, this.data});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? footer;
  String? email;
  String? websiteColor;
  String? driverappColor;
  String? adminpanelColor;
  String? appLogo;
  String? appLogoSmall;
  String? googleMapApiKey;
  String? isSocialMedia;
  String? driverRadios;
  String? userRideScheduleTimeMinute;
  String? tripAcceptRejectDriverTimeSec;
  String? showRideWithoutDestination;
  String? showRideOtp;
  String? showRideLater;
  String? deliveryDistance;
  String? appVersion;
  String? webVersion;
  String? contactUsAddress;
  String? contactUsPhone;
  String? contactUsEmail;
  String? creer;
  String? modifier;
  String? currency;
  String? decimalDigit;
  String? taxName;
  String? taxType;
  String? taxValue;

  Data(
      {this.id,
      this.title,
      this.footer,
      this.email,
      this.websiteColor,
      this.driverappColor,
      this.adminpanelColor,
      this.appLogo,
      this.appLogoSmall,
      this.googleMapApiKey,
      this.isSocialMedia,
      this.driverRadios,
      this.userRideScheduleTimeMinute,
      this.tripAcceptRejectDriverTimeSec,
      this.showRideWithoutDestination,
      this.showRideOtp,
      this.showRideLater,
      this.deliveryDistance,
      this.appVersion,
      this.webVersion,
      this.contactUsAddress,
      this.contactUsPhone,
      this.contactUsEmail,
      this.creer,
      this.modifier,
      this.currency,
      this.decimalDigit,
      this.taxName,
      this.taxType,
      this.taxValue});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    footer = json['footer'];
    email = json['email'];
    websiteColor = json['website_color'];
    driverappColor = json['driverapp_color'];
    adminpanelColor = json['adminpanel_color'];
    appLogo = json['app_logo'];
    appLogoSmall = json['app_logo_small'];
    googleMapApiKey = json['google_map_api_key'];
    isSocialMedia = json['is_social_media'];
    driverRadios = json['driver_radios'];
    userRideScheduleTimeMinute = json['user_ride_schedule_time_minute'];
    tripAcceptRejectDriverTimeSec = json['trip_accept_reject_driver_time_sec'];
    showRideWithoutDestination = json['show_ride_without_destination'];
    showRideOtp = json['show_ride_otp'];
    showRideLater = json['show_ride_later'];
    deliveryDistance = json['delivery_distance'];
    appVersion = json['app_version'];
    webVersion = json['web_version'];
    contactUsAddress = json['contact_us_address'];
    contactUsPhone = json['contact_us_phone'];
    contactUsEmail = json['contact_us_email'];
    creer = json['creer'];
    modifier = json['modifier'];
    currency = json['currency'];
    decimalDigit = json['decimal_digit'];
    taxName = json['tax_name'] ?? '';
    taxType = json['tax_type'] ?? '';
    taxValue = json['tax_value'] ?? '0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['footer'] = footer;
    data['email'] = email;
    data['website_color'] = websiteColor;
    data['driverapp_color'] = driverappColor;
    data['adminpanel_color'] = adminpanelColor;
    data['app_logo'] = appLogo;
    data['app_logo_small'] = appLogoSmall;
    data['google_map_api_key'] = googleMapApiKey;
    data['is_social_media'] = isSocialMedia;
    data['driver_radios'] = driverRadios;
    data['user_ride_schedule_time_minute'] = userRideScheduleTimeMinute;
    data['trip_accept_reject_driver_time_sec'] = tripAcceptRejectDriverTimeSec;
    data['show_ride_without_destination'] = showRideWithoutDestination;
    data['show_ride_otp'] = showRideOtp;
    data['show_ride_later'] = showRideLater;
    data['delivery_distance'] = deliveryDistance;
    data['app_version'] = appVersion;
    data['web_version'] = webVersion;
    data['contact_us_address'] = contactUsAddress;
    data['contact_us_phone'] = contactUsPhone;
    data['contact_us_email'] = contactUsEmail;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['currency'] = currency;
    data['decimal_digit'] = decimalDigit;
    data['tax_name'] = taxName;
    data['tax_type'] = taxType;
    data['tax_value'] = taxValue;
    return data;
  }
}
