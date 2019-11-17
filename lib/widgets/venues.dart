import 'package:activities_search_engine/api/api.dart';
import 'package:activities_search_engine/api/venue.dart';
import 'package:activities_search_engine/widgets/venue-view.dart';
import 'package:activities_search_engine/widgets/venues-form.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  /// Clé global identifiant le formulaire.
  final GlobalKey _venuesFormKey = new GlobalKey<FormState>();

  /// Liste des activités.
  List<Venue> venues = [];

  @override
  Widget build(BuildContext context) {
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
                        leading: venue.iconUrl != null
                            ? new CachedNetworkImage(
                                imageUrl: venue.iconUrl,
                                placeholder: (context, url) =>
                                    new CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error))
                            : new Icon(Icons.block, size: 42.0),
                        title: new Text(venue.name),
                        subtitle: new Text(venue.formattedAdress.join("\n")),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VenueView(venue)),
                          );
                        }));

              // Sinon on retourne une carte pour informer qu'un activité à été trouvé
              // mais que ses infos n'ont pas pu être récupérer suis au blocage de Foursquare.
              return new Card(
                child: new ListTile(
                  title: new Text('Failed to load data (quota exceeded)'),
                ),
              );
            }));
          }

          return children;
        }())));
  }

  /// Méthode de mise à jour des informations sur les activités.
  updateState(String cityName, String activity) {
    // On affiche un message de log.
    print('Search ${activity} in ${cityName}');

    // On défini une liste vide avant de rafraichir la liste.
    setState(() {
      this.venues = [];
    });

    // On récupère les activités auprès du web service et on les définis dans l'état du widget.
    Api.searchVenues(cityName, activity).then((List<Venue> _venues) {
      setState(() {
        this.venues = _venues;
      });
    });
  }
}
