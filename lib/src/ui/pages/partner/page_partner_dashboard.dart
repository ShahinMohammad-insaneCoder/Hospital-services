import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/constant.dart';
import '../../../models/career.dart';
import '../../../models/partner.dart';
import '../../components/cards/cards_career.dart';
import '../../components/cards/cards_partner.dart';
import '../../menuwidgets.dart';


class PartnerDashboard extends StatefulWidget {
  @override
  _PartnerDashboardState createState() => _PartnerDashboardState();
}

class _PartnerDashboardState extends State<PartnerDashboard> {
  List<Partner> partnerList = <Partner>[];
  List<Career> careerList = [];

  List<Partner> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed = json.decode(response.toString());

    return parsed != null
        ? parsed.map<Partner>((json) => Partner.fromJson(json)).toList()
        : null;
  }

  void getDummyPartner() async {
    var jsonData = await rootBundle.loadString("assets/json/partner.json");
    var decodedJson = json.decode(jsonData);

    setState(() {
      for (var line in decodedJson) {
        partnerList.add(Partner.fromJson(line));
      }
    });
  }

  void getCareers() async {
    var jsonData = await rootBundle.loadString("assets/json/career.json");
    var decodedJson = json.decode(jsonData);

    setState(() {
      for (var line in decodedJson) {
        careerList.add(Career.fromJson(line));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getDummyPartner();
    getCareers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Partner & Career",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor:colorPrimary,
        elevation: 0.0,
        leading:  const MenuWidget(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            alignment:
                Alignment.center, // Make the hint in the middle vertically
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15.0,
                    color: colorPrimary.withOpacity(0.1),
                    offset: Offset(2.0, 2.0),
                  )
                ]),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle:
                            TextStyle(color: colorPrimary.withOpacity(0.5)),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.search, color: colorPrimary),
                    onPressed: () {})
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Partner",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int id) {
                return PartnerCards(
                  partner: partnerList[id],
                );
              },
              itemCount: partnerList == null ? 0 : partnerList.length,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Career",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CareerButtonsWidget(list: careerList))
        ],
      ),
    );
  }
}
