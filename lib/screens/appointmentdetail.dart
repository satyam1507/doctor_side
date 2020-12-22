import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_side/models/cooler.dart';
import 'package:flutter/material.dart';

final appointRef = FirebaseFirestore.instance.collection('appointments');

class AppointmentDetail extends StatefulWidget {
  final DocumentSnapshot appointment;
  AppointmentDetail({this.appointment});

  @override
  _AppointmentDetailState createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  rejectAppointment() async {
    await appointRef.doc(widget.appointment.id).update({'status': "Cancelled"});
  }

  acceptAppointment() async {
    await appointRef.doc(widget.appointment.id).update({'status': "Confirmed"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenish,
      appBar: AppBar(
        backgroundColor: greenish,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Appointment Status',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Container(
                width: 300,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Patient Name: " + widget.appointment['patientname'],
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Patient Age: " + widget.appointment['age'],
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Appointment: " +
                              widget.appointment['status'] +
                              "\nstatus",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Appointment: " +
                              widget.appointment['datetime'] +
                              "\ndate and time",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Booking date: " +
                              widget.appointment['bookdatetime']
                                  .toString()
                                  .substring(0, 16) +
                              "\nand time",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      // Text("Patient Name:"+widget.appointment['age']),
                      //Text("Patient Name:"+widget.appointment['datetime']),
                      //Text("Patient Name:"+widget.appointment['bookdatetime'].toString()),
                    ],
                  ),
                ),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 130,
                    height: 50,
                    child: RaisedButton(
                      onPressed: () async {
                        await rejectAppointment();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Reject",
                        style: TextStyle(
                          fontFamily: "FiraSans",
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.red,
                      // color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 130,
                    height: 50,
                    child: RaisedButton(
                      onPressed: () async {
                        await acceptAppointment();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Accept",
                        style: TextStyle(
                          fontFamily: "FiraSans",
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.green,
                      // color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
