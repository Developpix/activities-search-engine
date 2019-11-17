import 'package:activities_search_engine/api/api.dart';
import 'package:activities_search_engine/api/venue.dart';
import 'package:activities_search_engine/widgets/venue-view.dart';
import 'package:activities_search_engine/widgets/venues-form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Widget d'affichage et de recherche des activités.
class Venues extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _Venues();
}

/// État du widget des activités.
class _Venues extends State<Venues> {
  /// Nom du de la page.
  final String widgetName = "Activities";
  final GlobalKey _venuesFormKey = new GlobalKey<FormState>();

  /// Liste des activités.
  List<Venue> venues = [];

  @override
  Widget build(BuildContext context) {
    print('Build Venues');
    print(venues);

    return Scaffold(
        appBar: new AppBar(
          title: new Text(widgetName),
        ),
        body: new Center(child: new ListView(children: () {
          var children = <Widget>[new VenuesForm(updateState)];

          // Si il y a des activités, on ajoute leurs cartes correspondantes dans la liste.
          if (venues.isNotEmpty) {
            children.addAll(venues.map((venue) {
              // Si l'activité n'est pas null on ajoute une carte avec ses informations.
              if (venue != null)
                return new Card(
                    child: new ListTile(
                        leading: venue.iconUrl != null ? Image.network(venue.iconUrl) : new Icon(Icons.block, size: 42.0),
                        title: new Text(venue.name),
                        subtitle: new Text(venue.formattedAdress.join("\n")),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VenueView(venue)),
                          );
                        }));

              return new Card(
                child: new ListTile(
                  title: new Text('Failed to load data'),
                ),
              );
            }));
          }

          return children;
        }())));
  }

  updateState(String cityName, String activity) {
    print('Search ${activity} in ${cityName}');
    Api.searchVenues(cityName, activity).then((List<Venue> _venues) {
      setState(() {
        this.venues = _venues;
      });
    });
  }
}
