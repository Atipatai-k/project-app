import 'dart:async';
import 'package:app2/screen/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';

class Graphpast extends StatefulWidget {
  final String id;
  Graphpast({required this.id, Key? key}) : super(key: ValueKey<String>(id));

  State<Graphpast> createState() => _GraphpastState();
}

class _GraphpastState extends State<Graphpast> {
  late final firebase2 =
      FirebaseDatabase.instance.ref('statistics/${widget.id}');

  List<SalesDetails> sales = [];

  Future<String> getJsonFormFirebase() async {
    var dataSnapshot = await firebase2.once();
    var jsonData = dataSnapshot.snapshot.value;
    return json.encode(jsonData);
  }

  Future loadSalesData() async {
    final String jsonString = await getJsonFormFirebase();
    final jsonResponse = json.decode(jsonString);
    if (jsonResponse is Map<String, dynamic>) {
      final List<dynamic> nodeList =
          jsonResponse.entries.toList(); // เปลี่ยนให้ใช้ .entries

      nodeList.sort((a, b) => a.key.compareTo(b.key)); // เรียงตามคีย์ของโหนด

      final int startIndex = nodeList.length > 8 ? nodeList.length - 8 : 0;

      for (int i = startIndex; i < nodeList.length; i++) {
        if (nodeList[i].value is Map<String, dynamic>) {
          sales.add(SalesDetails.fromJson(nodeList[i].value));
        }
      }
    }
  }

  void initState() {
    super.initState();
    loadSalesData();
  }

  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return homepage();
          }));
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/logobran.JPG'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text("กราฟความชื้นแบบย้อนหลังของ Con_" + '${widget.id}'),
            actions: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return homepage();
                  }));
                },
              )
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/backhome3.JPG'),
                fit: BoxFit.cover,
              ),
            ),
            child: FutureBuilder(
                future: getJsonFormFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "วันที่ " +
                                  DateFormat('dd-MM-yyyy')
                                      .format(DateTime.now()),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 450,
                          width: 400,
                          child: SfCartesianChart(
                            title: ChartTitle(
                                text: "กราฟความชื้นย้อนหลัง Con_${widget.id}",
                                textStyle: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            legend: Legend(
                              isVisible: true,
                              position: LegendPosition.top,
                              orientation: LegendItemOrientation.horizontal,
                            ),
                            primaryXAxis: CategoryAxis(
                              title: AxisTitle(text: 'เวลาที่บันทึก (ชั่วโมง:นาที)'),
                              labelStyle: TextStyle(color: Colors.black),
                              majorGridLines: MajorGridLines(
                                color: Colors.grey,
                                width: 1,
                              ),
                              majorTickLines:
                                  MajorTickLines(width: 1, color: Colors.black),
                            ),
                            primaryYAxis: NumericAxis(
                              minimum: 0,
                              maximum: 100,
                              interval: 10,
                              labelFormat: '',
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              labelStyle: TextStyle(color: Colors.black),
                              majorGridLines: MajorGridLines(
                                color: Colors.grey,
                                width: 1,
                              ),
                              majorTickLines:
                                  MajorTickLines(width: 1, color: Colors.black),
                            ),
                            series: <LineSeries<SalesDetails, String>>[
                              LineSeries<SalesDetails, String>(
                                dataSource: sales,
                                name: "ค่าความชื้น1",
                                xValueMapper: (SalesDetails data, _) =>
                                    data.time + ":00",
                                yValueMapper: (SalesDetails data, _) =>
                                    double.parse(data.humi1),
                                color: Colors.blue,
                                width: 2.5,
                              ),
                              LineSeries<SalesDetails, String>(
                                dataSource: sales,
                                name: "ค่าความชื้น2",
                                xValueMapper: (SalesDetails data, _) =>
                                    data.time + ":00",
                                yValueMapper: (SalesDetails data, _) =>
                                    double.parse(data.humi2),
                                color: Colors.red,
                                width: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Text(snapshot.error.toString());
                  }
                  return Text('....');
                }),
          ),
        ),
      );
}

class ChartData {
  final DateTime x;
  ChartData(this.x);
}

Text text1(String key) {
  return Text(
    key,
    textAlign: TextAlign.right,
    style: TextStyle(
        fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
  );
}

class SalesDetails {
  SalesDetails(this.time, this.humi1, this.humi2);
  final String time;
  final String humi1;
  final String humi2;

  factory SalesDetails.fromJson(Map<String, dynamic> parsedJson) {
    return SalesDetails(
      parsedJson['time'].toString(),
      parsedJson['humi1'].toString(),
      parsedJson['humi2'].toString(),
    );
  }
}
