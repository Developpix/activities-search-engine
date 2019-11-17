// Create a Form widget.
import 'package:flutter/material.dart';

/// Formulaire pour la recherche des activités.
class VenuesForm extends StatefulWidget {
  /// Fonction à appeler pour mettre à jour l'état de l'application.
  final Function(String, String) updateState;

  @override
  VenuesFormState createState() {
    return VenuesFormState(updateState);
  }

  /// Constructeur du formulaire.
  VenuesForm(this.updateState);
}

/// État du formulaire de recherche des activités.
class VenuesFormState extends State<VenuesForm> {
  /// TextEditingController pour le nom de la ville.
  TextEditingController cityController = new TextEditingController();
  /// TextEditingController pour le nom de l'activité.
  TextEditingController activityController = new TextEditingController();

  /// Fonction à appeler pour mettre à jour l'état de l'application.
  final Function(String, String) updateState;

  /// Clé globale qui identifie l'état du formulaire.
  final _formKey = GlobalKey<FormState>();

  /// Constructeur pour le formulaire
  /// [updateState] La fonction à appeler pour mettre à jour l'état de l'application.
  VenuesFormState(this.updateState);

  @override
  Widget build(BuildContext context) {
    return new Form(
        key: _formKey,
        child: new Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  "City Name",
                  style: Theme.of(context).textTheme.title,
                ),
                new TextFormField(
                  controller: cityController,
                  validator: (cityName) {
                    if (cityName.isEmpty) return "Enter a city name";
                    return null;
                  },
                ),
                new Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: new Text(
                      "Activity",
                      style: Theme.of(context).textTheme.title,
                    )),
                new TextFormField(
                  controller: activityController,
                  validator: (activityName) {
                    if (activityName.isEmpty) return "Enter a activity name";
                    return null;
                  },
                ),
                new Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: new RaisedButton(
                        child: new Text("Search"),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            updateState(cityController.text, activityController.text);
                          }
                        }))
              ],
            )));
  }
}
