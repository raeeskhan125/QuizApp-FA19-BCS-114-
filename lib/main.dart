// ignore_for_file: missing_return

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/contact-us.dart';
import 'package:quizapp/mdlresult.dart';
import 'package:quizapp/result.dart';
import 'package:quizapp/splash.dart';
import 'quiz_brain.dart';
import 'package:percent_indicator/percent_indicator.dart';

QuizBrain quizBrain;
void main() => runApp(MaterialApp(
      home: Splash(),
    ));

class QuizApp extends StatefulWidget {
  //const QuizApp({ Key? key }) : super(key: key);
  QuizApp() {
    quizBrain = QuizBrain();
  }

  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  List<Icon> scoreKeeper = [];
  List<MdlResult> record = [];
  int attempted = 0;
  getnextQuestion() {
    setState(() {
      if (quizBrain.isFinished()) {
        time.cancel();
        sec = 5;
        _dispDialog();
        quizBrain.reset();
        scoreKeeper = [];
      } else {
        quizBrain.nextQuestion();
        setState(() {});
      }
    });
  }

  _dispDialog() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Result(record, attempted),
      ),
    );
  }

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();
    attempted++;

    setState(() {
      if (quizBrain.isFinished() == true) {
        time.cancel();
        sec = 5;
        _dispDialog();

        quizBrain.reset();
        scoreKeeper = [];
      } else {
        if (userPickedAnswer == correctAnswer) {
          sec = 5;
          scoreKeeper.add(Icon(
            Icons.check,
            color: Colors.green,
          ));
        } else {
          record.add(
              MdlResult(quizBrain.question, userPickedAnswer, correctAnswer));
          sec = 5;
          scoreKeeper.add(
            Icon(
              Icons.close,
              color: Colors.red,
            ),
          );
        }
        quizBrain.nextQuestion();
      }
    });
  }

  int sec = 5;
  Timer time;
  bool first = true;
  _startTimer() {
    time = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        setState(() {
          if (this.sec > 0) {
            this.sec = this.sec - 1;
          } else {
            this.sec = 5;
            getnextQuestion();
            setState(() {});
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (first) {
      first = false;
      _startTimer();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          title: Text("Quiz App"),
          bottomOpacity: 0,
          backgroundColor: Colors.tealAccent,
          toolbarOpacity: 0.9,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("Muhammad Raees"),
                accountEmail: Text("raeeskhancuii@gmail.com"),
                currentAccountPicture: Image(image: AssetImage("images/R.png")),
              ),
              // DrawerHeader(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       CircleAvatar(
              //         radius: 40,
              //         backgroundColor: Colors.amber[400],
              //       ),
              //       SizedBox(
              //         height: 5,
              //       ),
              //       Text(
              //         "Quiz App",
              //         style: TextStyle(fontSize: 20),
              //       ),
              //     ],
              //   ),

              //   // decoration: BoxDecoration(color: Colors.black54),
              // ),

              ListTile(
                subtitle: Text(
                  "Total Questions: 10",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ListTile(
                subtitle: Text(
                  "Remaining Questions: ${10 - attempted}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ListTile(
                subtitle: Text(
                  "Total Correct Answers:${attempted - record.length}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ListTile(
                subtitle: Text(
                  "Total Wrong Answers: ${record.length}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Divider(
                thickness: 3,
                indent: 40,
                endIndent: 40,
                color: Colors.blueGrey.shade600,
              ),
              SizedBox(
                height: 50,
              ),
              ListTile(
                leading: Icon(Icons.contact_mail_sharp),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Contact(),
                      ));
                },
                title: Text(
                  "Contact Us",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: CircularPercentIndicator(
                    // animation: true,
                    radius: 100.0,
                    lineWidth: 7.0,
                    percent: (sec / 10) * 2,
                    linearGradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.red]),

                    center: new Text(
                      sec.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //progressColor: Colors.green,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        quizBrain.getQuestionText(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.all(15.0),
                    child: FlatButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text(
                        'True',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        checkAnswer(true);
                        //The user picked true.
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: FlatButton(
                      color: Colors.red,
                      child: Text(
                        'False',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        checkAnswer(false);
                        //The user picked false.
                      },
                    ),
                  ),
                ),
                Row(
                  children: scoreKeeper,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
