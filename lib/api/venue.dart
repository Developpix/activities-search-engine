class Venue {
  final String id;
  final String name;
  final String address;
  final int postalCode;
  final String cityName;
  final String state;
  final String countryName;

  Venue({this.id,
    this.name,
    this.address,
    this.postalCode,
    this.cityName,
    this.state,
    this.countryName});

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
        id: json['id'],
        name: json['name'],
        address: json['location']['address'],
        postalCode: 0,
        cityName: json['location']['city'],
        state: json['location']['state'],
        countryName: json['location']['country']
    );
  }

  @override
  String toString() {
    return 'Venue{id: $id, name: $name, address: $address, postalCode: $postalCode, cityName: $cityName, state: $state, countryName: $countryName}';
  }
}
