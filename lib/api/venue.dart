class Venue {
  final String id;
  final String name;
  final String description;
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
      this.description,
      this.address,
      this.formattedAdress,
      this.postalCode,
      this.cityName,
      this.state,
      this.countryName,
      this.latitude,
      this.longitude});

  factory Venue.fromJson(Map<String, dynamic> json) {
    print(json);

    Venue venue = Venue(
        id: json['id'],
        name: json['name'],
        address: json['location']['address'],
        description: json['description'] != null ? json['description'] : 'No description found',
        formattedAdress: json['location']['formattedAddress'] != null ? json['location']['formattedAddress'] : ['No adress found'],
        postalCode: json['location']['postalCode'],
        cityName: json['location']['city'],
        state: json['location']['state'],
        countryName: json['location']['country'],
        latitude: json['location']['lat'].toString(),
        longitude: json['location']['lng'].toString());

    if (json['bestPhoto'] != null)
      venue.iconUrl =
          '${json['bestPhoto']['prefix']}${json['bestPhoto']['width']}x${json['bestPhoto']['height']}${json['bestPhoto']['suffix']}';

    return venue;
  }

  @override
  String toString() {
    return 'Venue{id: $id, name: $name, address: $address, postalCode: $postalCode, cityName: $cityName, state: $state, countryName: $countryName}';
  }
}
