import 'dart:convert';
import 'package:activities_search_engine/api/venue.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:developer' as developer;

class Api {
  static final String venuesUrl =
      'https://api.foursquare.com/v2/venues/explore';

  static Future<List<Venue>> searchVenues(String cityName, String activity,
      [int limit = 10, int page = 1, int rayon]) async {
    await DotEnv().load('.env');

    List<Venue> venues = new List();
    final response = await get(
        '${venuesUrl}?client_id=${DotEnv().env['CLIENT_ID']}&client_secret=${DotEnv().env['CLIENT_SECRET']}&v=20180323&near=${cityName}&query=${activity}');

    Map<String, dynamic> jsonResponse = json.decode(response.body)['response'];

    List<dynamic> groups = jsonResponse['groups'];

    if (groups != null) {
      for (int i = 0; i < groups.length; i++) {
        List<dynamic> items = groups[i]['items'];

        if (items != null) {
          for (int j = 0; j < items.length; j++) {
            venues.add(Venue.fromJson(items[j]['venue']));
          }
        } else {
          developer.debugger(when: true, message: groups.toString());
        }
      }
    } else {
      developer.debugger(when: true, message: jsonResponse.toString());
    }

    return venues;
  }
}
