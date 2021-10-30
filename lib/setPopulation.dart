import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:population/contract_linking.dart';
import 'package:provider/provider.dart';

class SetPopulation extends StatefulWidget {
  @override
  _SetPopulationState createState() => _SetPopulationState();
}

class _SetPopulationState extends State<SetPopulation> {
  Country _selectedCountry = CountryPickerUtils.getCountryByIsoCode('AF');

  TextEditingController countryNameController =
      TextEditingController(text: "Unknown");
  TextEditingController populationController = TextEditingController();
  TextEditingController vaccinatedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLinking>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Set Population"),
          actions: [
            TextButton(
                onPressed: () {
                  contractLink.addDataAll(
                      countryNameController.text,
                      BigInt.from(int.parse(populationController.text)), BigInt.from(int.parse(vaccinatedController.text)));
                  Navigator.pop(context);
                },
                child: Text(
                  "SAVE",
                  style: TextStyle(
                      color: Colors.brown, fontWeight: FontWeight.bold),
                ))
          ],
        ),
        body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  stackCard(countryFlagPicker(), countryFlag()),
                  stackCard(populationTextfield(), countryFlag()),
                  stackCard(vaccinationTextfield(), countryFlag()),

                ],
              ),
            ),
          ),
        ));
  }

  Widget stackCard(Widget widget1, Widget widget2) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.0, left: 54),
          child: Container(
            height: 120,
            child: Card(
              color: Colors.cyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [widget1],
              ),
            ),
          ),
        ),
        widget2
      ],
    );
  }

  Widget countryFlag() {
    return Positioned(
      top: 15,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Container(
                width: 80,
                height: 50,
                child:
                    CountryPickerUtils.getDefaultFlagImage(_selectedCountry))),
      ),
    );
  }

  Widget countryFlagPicker() {
    return CountryPickerDropdown(
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onValuePicked: (Country country) {
        print("${country.name}");
        setState(() {
          _selectedCountry = country;
          countryNameController.text = country.isoCode;
        });
      },
      itemBuilder: (Country country) {
        return Row(
          children: <Widget>[
            SizedBox(width: 48.0),
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 8.0),
            Expanded(
                child: Text(
              country.name,
              style: TextStyle(
                  color: Colors.brown,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )),
          ],
        );
      },
      icon: Icon(
        Icons.arrow_downward,
        color: Colors.white,
        size: 50,
      ),
      itemHeight: null,
      isExpanded: true,
    );
  }

  Widget populationTextfield() {
    return Padding(
      padding: EdgeInsets.only(left: 48.0, right: 5),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black,
            focusedBorder: OutlineInputBorder(),
            labelText: "Population",
            labelStyle: TextStyle(color: Colors.white),
            hintText: "Enter Population",
            prefixIcon: Icon(Icons.person_pin_outlined)),
        keyboardType: TextInputType.number,
        controller: populationController,
      ),
    );
  }

  Widget vaccinationTextfield() {
    return Padding(
      padding: EdgeInsets.only(left: 48.0, right: 5),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black,
            focusedBorder: OutlineInputBorder(),
            labelText: "Vaccinated",
            labelStyle: TextStyle(color: Colors.white),
            hintText: "Enter vaccinated",
            prefixIcon: Icon(Icons.person_pin_outlined)),
        keyboardType: TextInputType.number,
        controller: vaccinatedController,
      ),
    );
  }
}
