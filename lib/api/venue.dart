import 'package:http/http.dart';

/// Une activité.
class Venue {
  /// Identifiant de l'activité.
  final String id;

  /// Nom de l'activité.
  final String name;

  /// Description de l'activité.
  final String description;

  /// Adresse de l'activité.
  final String address;

  /// Adresse formattée de l'activité.
  final List<dynamic> formattedAdress;

  /// Code postal de l'activité.
  String postalCode;

  /// Nom de la ville de l'activité.
  final String cityName;

  /// Nom de l'état de l'activité.
  final String state;

  /// Nom du pays de l'activité.
  final String countryName;

  /// Latitude de l'activité.
  final String latitude;

  /// Longitude de l'activité.
  final String longitude;

  /// URL de la page sur foursquare.com.
  final String canonicalUrl;

  /// URL des photos de l'activité.
  final List<String> photosUrl;

  /// Commentaires de l'activité.
  final List<String> tips;

  /// URL de l'icône de l'activité.
  String iconUrl;

  /// Constructeur de l'activité.
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
      this.longitude,
      this.canonicalUrl,
      this.photosUrl,
      this.tips});

  /// Factory pour créer l'activité à partir de ses informations au format JSON.
  factory Venue.fromJson(Map<String, dynamic> json, List<String> photosUrl, List<String> tips) {
    // Création de l'activité.
    Venue venue = Venue(
        id: json['id'],
        name: json['name'],
        address: json['location']['address'],
        description: json['description'] != null
            ? json['description']
            : 'No description found',
        formattedAdress: json['location']['formattedAddress'] != null
            ? json['location']['formattedAddress']
            : ['No adress found'],
        postalCode: json['location']['postalCode'],
        cityName: json['location']['city'],
        state: json['location']['state'],
        countryName: json['location']['country'],
        latitude: json['location']['lat'].toString(),
        longitude: json['location']['lng'].toString(),
        canonicalUrl: json['canonicalUrl'],
        photosUrl: photosUrl,
        tips: tips);

    // Si elle a une meilleur photo on défini son URL.
    if (json['bestPhoto'] != null)
      venue.iconUrl =
          '${json['bestPhoto']['prefix']}${json['bestPhoto']['width']}x${json['bestPhoto']['height']}${json['bestPhoto']['suffix']}';

    // On retourne l'activité créée.
    return venue;
  }

  @override
  String toString() {
    return 'Venue{id: $id, name: $name, description: $description, address: $address, formattedAdress: $formattedAdress, postalCode: $postalCode, cityName: $cityName, state: $state, countryName: $countryName, latitude: $latitude, longitude: $longitude, canonicalUrl: $canonicalUrl, photosUrl: $photosUrl, iconUrl: $iconUrl}';
  }
}
