import 'dart:convert';
import 'package:activities_search_engine/api/venue.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class Api {
  static final String venuesUrl =
      'https://api.foursquare.com/v2/venues/explore';
  static final String venueUrl = 'https://api.foursquare.com/v2/venues';

  static Future<List<Venue>> searchVenues(String cityName, String activity,
      [int limit = 10, int page = 1, int rayon]) async {
    await DotEnv().load('.env');

    List<Venue> venues = new List();
    final response = await get(
        '${venuesUrl}?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323&near=${cityName}&query=${activity}');

    Map<String, dynamic> jsonResponse = json.decode(response.body)['response'];

    List<dynamic> groups = jsonResponse['groups'];

    print('Load all Venues from ${venuesUrl}?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323&near=${cityName}&query=${activity}');

    if (groups != null) {
      for (int i = 0; i < groups.length; i++) {
        List<dynamic> items = groups[i]['items'];

        if (items != null) {
          for (int j = 0; j < items.length; j++) {
            Venue venue = await getVenue(items[j]['venue']['id']);
            if (venue != null) venues.add(venue);
          }
        } else {
          print('JSON invalid ${groups.toString()}');
        }
      }
    } else {
      print('JSON invalid ${groups.toString()}');
    }

    return venues;
  }

  static Future<Venue> getVenue(String id) async {
    await DotEnv().load('.env');

    final response = await get(
        '${venueUrl}/${id}?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323');

    print('Load Venue from ${venueUrl}/${id}?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323');

    if (json.decode(response.body)['meta'] != null && json.decode(response.body)['meta']['code'].toString() != '200') {
      print('Failed load Venue ${json.decode(response.body)}');
      return null;
    }

    return Venue.fromJson(json.decode(response.body)['response']['venue']);
  }
}

// TODO
class QuotaExceededException extends Exception {
  QuotaExceededException(String message) {
    Ece(message);
  }
}