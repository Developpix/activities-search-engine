import 'dart:convert';
import 'package:activities_search_engine/api/venue.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

/// Factory Api pour réaliser les recherches.
class Api {
  /// Constante pour l'URL de récupération des activités.
  static final String venuesUrl =
      'https://api.foursquare.com/v2/venues/explore';
  /// Constante pour l'URL de récupération des informations sur une activité.
  static final String venueUrl = 'https://api.foursquare.com/v2/venues';

  /// Rechercher des activités.
  /// [cityName] Le nom de la ville.
  /// [activity] Un ou des mot(s) clé(s) pour l'activité.
  /// [limit] Le nombre de résultat par défaut 10.
  /// [page] Le numéro de la page par défaut 10.
  /// [limit] Le nombre de résultat par défaut 10.
  static Future<List<Venue>> searchVenues(String cityName, String activity,
      [int limit = 10, int page = 1, int rayon]) async {
    // On charge les variables d'environnement.
    await DotEnv().load('.env');

    // On appel le web service de recherche des activités et on stock le résultat.
    var response;
    if (rayon != null)
      response = await get(
          '${venuesUrl}?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323&near=${cityName}&query=${activity}&limit=${limit}&rayon=${rayon}');
    else
      response = await get(
          '${venuesUrl}?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323&near=${cityName}&query=${activity}&limit=${limit}');

    // On traduit le JSON de réponse en Map.
    Map<String, dynamic> jsonResponse = json.decode(response.body)['response'];

    // On stock la liste des groupes dans une liste.
    List<dynamic> groups = jsonResponse['groups'];

    // On affiche un message de log.
    print(
        'Load all Venues from ${venuesUrl}?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323&near=${cityName}&query=${activity}');

    // On créer une liste d'activités par défaut vide.
    List<Venue> venues = new List();
    // Si on a des groupes on les parcours.
    if (groups != null) {
      for (int i = 0; i < groups.length; i++) {
        // Pour chaque groupe on récupère les items et si il y en a on parcours la liste.
        List<dynamic> items = groups[i]['items'];
        if (items != null) {
          for (int j = 0; j < items.length; j++) {
            // Pour chaque item ou recupère l'activité avec ses informations.
            Venue venue = await getVenue(items[j]['venue']['id']);
            // Si l'on a bien une activité on l'ajoute à la liste.
            venues.add(venue);
          }
        }
      }
    }

    // On  retourne les activités.
    return venues;
  }

  /// Recupérer les informations sur une activité.
  /// [id] L'ID de l'activité.
  static Future<Venue> getVenue(String id) async {
    // On charge les variables d'environnement.
    await DotEnv().load('.env');

    // On appel le web service pour les informations sur l'activité et on stock la réponse.
    final response = await get(
        '${venueUrl}/${id}?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323');

    // On affiche un message de log.
    print(
        'Load Venue from ${venueUrl}/${id}?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323');

    // Si le web service ne nous a pas renvoyé une réponse valide,
    // on affiche un message de log et on retourne null.
    if (json.decode(response.body)['meta'] != null &&
        json.decode(response.body)['meta']['code'].toString() != '200') {
      print('Failed load Venue ${json.decode(response.body)}');
      return null;
    }

    // On appel le web service pour les photos sur l'activité et on stock la réponse.
    final photosResponse = json.decode((await get(
            'https://api.foursquare.com/v2/venues/${id}/photos?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323'))
        .body);
    List<String> photosUrl = [];
    if (photosResponse['response'] != null &&
        photosResponse['response']['photos'] != null &&
        photosResponse['response']['photos']['items'] != null) {
      for (final item in photosResponse['response']['photos']['items']) {
          photosUrl.add(
              '${item['prefix']}${item['width']}x${item['height']}${item['suffix']}');
      }
    }

    // On appel le web service pour les commentaires sur l'activité et on stock la réponse.
    final tipsResponse = json.decode((await get(
            'https://api.foursquare.com/v2/venues/${id}/tips?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323'))
        .body);
    List<String> tips = [];
    if (tipsResponse['response'] != null &&
        tipsResponse['response']['tips'] != null &&
        tipsResponse['response']['tips']['items'] != null) {
      for (final item in tipsResponse['response']['tips']['items']) {
        tips.add('${item['text']}');
      }
    }

    // On retourne l'activité créer à partir des ses informations
    // au format JSON.
    return Venue.fromJson(
        json.decode(response.body)['response']['venue'], photosUrl, tips);
  }
}
