import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Emergency {
  var caseNumber;
  var endTime;
  var userLocation;
  var audioRecording;

  get getCaseNumber => this.caseNumber;

  set setCaseNumber(caseNumber) => this.caseNumber = caseNumber;

  get getEndTime => this.endTime;

  set setEndTime(endTime) => this.endTime = endTime;

  get getUserLocation => this.userLocation;

  set setUserLocation(userLocation) => this.userLocation = userLocation;

  get getAudioRecording => this.audioRecording;

  set setAudioRecording(audioRecording) => this.audioRecording = audioRecording;

  Emergency({
    this.caseNumber,
    this.endTime,
    this.userLocation,
    this.audioRecording,
  }) {
    caseNumber = this.caseNumber;
    endTime = this.endTime;
    userLocation = this.userLocation;
    audioRecording = this.audioRecording;
  }

  // receiving data from server
  //factory => create the emergency case
  factory Emergency.fromMap(map) {
    return Emergency(
      caseNumber: map['caseNumber'],
      endTime: map['endTime'],
      userLocation: map['userLocation'],
      audioRecording: map['audioRecording'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap(String uid) {
    return {
      'caseNumber': caseNumber,
      'endTime': endTime,
      'userLocation': userLocation,
      'audioRecording': audioRecording,
      'user': uid,
    };
  }

  sendMail(List<dynamic> recipients, String subject, String msg) async {
    try {
      // from where the email will be sent
      String username = 'redflagapp.8@gmail.com';
      String password = 'Redflag123';

      final smtpServer = gmail(username, password);

      // content of the email
      final message = Message()
        ..from = Address(username)
        ..ccRecipients.addAll(recipients)
        ..subject = '$subject :::: ${DateTime.now()}'
        ..html = '$msg';

      // send the email
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      print(recipients);
    } on SmtpClientAuthenticationException catch (e) {
      // This exception is thrown when the username and password is incorrect.
      Fluttertoast.showToast(
          msg:
              'The Notifying message has been not sent.\nThrer is somthing wrong with the email or the password of the sender.\nContact Redflag team on redflagapp.8@gmail.com', // message
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 5
          // duration
          );
      print(
          'The Notifying message has been not sent.\nThrer is somthing wrong with the email or the password of the sender.\nContact Redflag team on redflagapp.8@gmail.com');
    }
  }
}
