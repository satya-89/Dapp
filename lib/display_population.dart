
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:population/setPopulation.dart';
import 'package:provider/provider.dart';
import 'package:population/contract_linking.dart';

class DisplayPopulation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLinking>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Population Vs Vaccinated On Blockchain"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SetPopulation(),
                  fullscreenDialog: true));
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: contractLink.isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      contractLink.countryName == "Unknown"
                          ? Icon(
                              Icons.error,
                              size: 100,
                            )
                          : Container(
                              child: CountryPickerUtils.getDefaultFlagImage(
                                  CountryPickerUtils.getCountryByIsoCode(
                                      contractLink.countryName)),
                              width: 250,
                              height: 150,
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Country - ${contractLink.countryName}",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Population - ${contractLink.currentPopulation}",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Vaccinated - ${contractLink.currentVaccinated}",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      ),
                      contractLink.countryName == "Unknown"
                          ? Text("")
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      dialog(context, "Increase");
                                    },
                                    icon:
                                        Icon(Icons.person_add_alt_1, size: 18),
                                    label: Text("Increase"),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (contractLink.currentPopulation !=
                                          "0") {
                                        dialog(context, "Decrease");
                                      }
//                                      contractLink.currentPopulation == "0"
//                                          ? null
//                                          : dialog(context, "Decrease");
                                    },
                                    icon: Icon(Icons.person_remove_alt_1,
                                        size: 18),
                                    label: Text("Decrease"),
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  dialog(context, method) {
    final contractLink = Provider.of<ContractLinking>(context, listen: false);
    TextEditingController countController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: method == "Increase"
                  ? Text("Increase Population Vs Vaccinated")
                  : Text("Decrease Population Vs Vaccinated"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Current Population is ${contractLink.currentPopulation}"
                          "Current Vaccinated is ${contractLink.currentVaccinated}"
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: countController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: method == "Increase"
                            ? "Increase Population/ vaccinated By ..."
                            : "Decrease Population/ vaccinated By ...",
                      ),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                Row(
                  children: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: method == "Increase"
                          ? Text("Increase")
                          : Text("Decrease"),
                      onPressed: () {
                        method == "Increase"
                            ? contractLink.increasePopulation(
                                int.parse(countController.text))
                            : contractLink.decreasePopulation(
                                int.parse(countController.text));
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: method == "Increase"
                          ? Text("Increase vaccinated")
                          : Text("Decrease vaccinated"),
                      onPressed: () {
                        method == "Increase"
                            ? contractLink.increaseVaccinated(
                            int.parse(countController.text))
                            : contractLink.decreaseVaccinated(
                            int.parse(countController.text));
                        Navigator.of(context).pop();
                      },
                    ),

                  ],
                )
              ],
            ));
  }
}
