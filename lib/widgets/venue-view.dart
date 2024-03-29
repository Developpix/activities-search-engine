import 'package:activities_search_engine/api/venue.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget affichant les détails d'une activité.
class VenueView extends StatelessWidget {
  /// L'activité associée.
  final Venue venue;

  /// Constructeur du Widget.
  VenueView(this.venue);

  @override
  Widget build(BuildContext context) {
    //Image.network(venue.iconUrl != null ? venue.iconUrl : '')
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 256,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  venue.iconUrl != null
                      ? Image.network(venue.iconUrl)
                      : new Icon(Icons.block, size: 128.0),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                          ),
                          Text(
                            this.venue.name,
                            style: Theme.of(context).textTheme.title,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.venue.formattedAdress.join("\n"),
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 24.0),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: () {
                    // Les widget enfants de base affichant les informations
                    // de base sur l'activité.
                    var children = <Widget>[
                      Text(
                        "Description",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(this.venue.description),
                      ),
                      Text(
                        "Locations",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(this.venue.formattedAdress.join("\n")),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: new Row(
                            children: <Widget>[
                              new IconButton(
                                icon: Icon(Icons.map),
                                onPressed: () {
                                  String googleUrl =
                                      'https://www.google.com/maps/search/?api=1&query=${venue.latitude},${venue.longitude}';
                                  if (canLaunch(googleUrl) != null) {
                                    launch(googleUrl);
                                  } else {
                                    throw 'Could not open the map.';
                                  }
                                },
                              ),
                              new IconButton(
                                icon: Icon(Icons.open_in_browser),
                                onPressed: () {
                                  if (canLaunch(venue.canonicalUrl) != null) {
                                    launch(venue.canonicalUrl);
                                  } else {
                                    throw 'Could not open the web page.';
                                  }
                                },
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: new Container(
                          height: venue.photosUrl.length > 0 ? 256.0 : 0.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: venue.photosUrl.map((photoUrl) {
                              print(photoUrl);
                              print(venue.id);
                              return new Container(
                                  child: new CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      imageUrl: photoUrl,
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error)));
                            }).toList(),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: new Text("Comments",
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(fontSize: 20))),
                    ];

                    // On ajoute les commentaires.
                    for (final tip in venue.tips) {
                      children.add(new Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: new Text(tip ?? ''),
                      ));
                    }

                    // On retourne les widgets enfant contenant les informations sur l'activité.
                    return children;
                  }()),
            ),
          ]))
        ],
      ),
    );
  }
}
