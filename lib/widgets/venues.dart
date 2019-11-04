import 'package:activities_search_engine/api/api.dart';
import 'package:activities_search_engine/api/venue.dart';
import 'package:activities_search_engine/widgets/venue-view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Venues extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _Venues();
}

class _Venues extends State<Venues> {
  final String widgetName = "Activities";
  List<Venue> venues = [];

  @override
  void initState() {
    Api.searchVenues("Nantes", "Kebab").then((List<Venue> _venues) {
      setState(() {
        venues = _venues;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(widgetName),
        ),
        body: new Center(
            child: ListView(
                children: venues.map((venue) {
          if (venue != null)
            return new Card(
                child: new ListTile(
                  leading: Image.network(venue.iconUrl != null ? venue.iconUrl : ''),
                  title: new Text(venue.name),
                  subtitle: new Text(venue.formattedAdress.join("\n")),
                  onTap:  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VenueView(venue)),
                    );
                  }
            ));

          return new Card(
            child: new ListTile(
              title: new Text('Failed to load data'),
            ),
          );
        }).toList())));
  }
}
