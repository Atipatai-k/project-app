import 'dart:async';
import 'package:app2/screen/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Graphnow extends StatefulWidget {
  final String id;
  Graphnow({required this.id, Key? key}) : super(key: ValueKey<String>(id));

  State<Graphnow> createState() => _GraphnowState();
}

class _GraphnowState extends State<Graphnow> {
  late Timer _timer;
  late final firebase2 =
      FirebaseDatabase.instance.ref('Controller/${widget.id}').onValue;
  late final humibase =
      FirebaseDatabase.instance.ref().child("Controller/${widget.id}");
  List<ChartData> _chartData = [];

  double _data = 0;
  double _data2 = 0;
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void initState() {
    super.initState();

    _chartData.add(
      ChartData(
        DateTime.now(),
        _data,
        _data2,
      ),
    );
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _chartData.add(
          ChartData(
            DateTime.now(),
            _data,
            _data2,
          ),
        );
      });
    });

    humibase.child("Humidity1").onValue.listen((event) {
      if (!mounted) return;
      setState(() {
        _data = double.parse(event.snapshot.value as String);
      });
    });
    humibase.child("Humidity2").onValue.listen((event) {
      if (!mounted) return;
      setState(() {
        _data2 = double.parse(event.snapshot.value as String);
      });
    });
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
            title: Text("กราฟความชื้นแบบเรียลไทม์ของ Con_" + '${widget.id}'),
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
            child: StreamBuilder(
                stream: firebase2,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data?.snapshot.value as Map?;
                    if (data == null) {
                      return Text('No data');
                    }
                    final humidity1 = data['Humidity1'];
                    final humidity2 = data['Humidity2'];
                    // final valveoff = data['Valve-Off'];
                    // final valveon = data['Valve-On'];
                    // double humi1 = double.parse(humidity1);
                    // double humi2 = double.parse(humidity2);
                    // double off = double.parse(valveoff);
                    // double on = double.parse(valveon);

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
                                text: "กราฟความชื้นเรียลไทม์ Con_${widget.id}",
                                textStyle: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            legend: Legend(
                              isVisible: true,
                              position: LegendPosition.top,
                              orientation: LegendItemOrientation.horizontal,
                            ),
                            primaryXAxis: DateTimeAxis(
                              minimum:
                                  DateTime.now().add(Duration(seconds: 25)),
                              dateFormat: DateFormat.Hms(),
                              maximum: DateTime.now()
                                  .subtract(Duration(seconds: 25)),
                              rangePadding: ChartRangePadding.auto,
                              title:
                                  AxisTitle(text: 'เวลา (ชั่วโมง:นาที:วินาที)'),
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
                            series: <LineSeries<ChartData, DateTime>>[
                              LineSeries<ChartData, DateTime>(
                                dataSource: _chartData,
                                name: "ค่าความชื้น1",
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y1,
                                color: Colors.blue,
                                width: 2.5,
                              ),
                              LineSeries<ChartData, DateTime>(
                                dataSource: _chartData,
                                name: "ค่าความชื้น2",
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y2,
                                color: Colors.red,
                                width: 2,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Icon(Icons.water_drop_outlined,
                                        color: Color.fromARGB(255, 0, 122, 6),
                                        size: 40),
                                    Text(
                                      humidity1 + " %",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text("ความชื้นในดิน 1")
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Icon(Icons.water_drop_outlined,
                                        color: Color.fromARGB(255, 0, 122, 6),
                                        size: 40),
                                    Text(
                                      humidity2 + " %",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text("ความชื้นในดิน 2")
                                  ],
                                ),
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
  final double y1;
  final double y2;
  ChartData(this.x, this.y1, this.y2);
}

Text text1(String key) {
  return Text(
    key,
    textAlign: TextAlign.right,
    style: TextStyle(
        fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
  );
}
