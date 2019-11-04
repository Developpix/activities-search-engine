class Venue {
  final String id;
  final String name;
  final String address;
  final List<dynamic> formattedAdress;
  String postalCode;
  final String cityName;
  final String state;
  final String countryName;
  final String latitude;
  final String longitude;
  String iconUrl;

  Venue(
      {this.id,
      this.name,
      this.address,
        this.formattedAdress,
      this.postalCode,
      this.cityName,
      this.state,
      this.countryName,
      this.latitude,
      this.longitude});

  factory Venue.fromJson(Map<String, dynamic> json) {
    Venue venue = Venue(
        id: json['id'],
        name: json['name'],
        address: json['location']['address'],
        formattedAdress: json['location']['formattedAddress'],
        postalCode: json['location']['postalCode'],
        cityName: json['location']['city'],
        state: json['location']['state'],
        countryName: json['location']['country'],
        latitude: json['location']['lat'].toString(),
        longitude: json['location']['lng'].toString());

    if(json['photos']['groups'].length > 0
    && json['photos']['groups'][0]['items'].length > 0)
        venue.iconUrl = '${json['photos']['groups'][0]['items'][0]['prefix']}${json['photos']['groups'][0]['items'][0]['width']}x${json['photos']['groups'][0]['items'][0]['height']}${json['photos']['groups'][0]['items'][0]['suffix']}';

    return venue;
  }

  @override
  String toString() {
    return 'Venue{id: $id, name: $name, address: $address, postalCode: $postalCode, cityName: $cityName, state: $state, countryName: $countryName}';
  }
}
