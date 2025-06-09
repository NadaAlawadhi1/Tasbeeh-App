import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sub7a/indicator/circular_indicator_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

int colorHex = 0xFF000000;
int _counter = 0;
int _timer = 0;
int _goal = 0;
bool isColorActive = false;

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    Color mainColor = Color(colorHex);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              resetApp(resetGoal: true);
            });
          },
          backgroundColor: mainColor,
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: mainColor,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isColorActive = !isColorActive;
                  });
                },
                child: Icon(
                  isColorActive ? Icons.color_lens_outlined : Icons.color_lens,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: mainColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      "الهدف",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          resetApp();

                          setState(() {
                            if (_goal > 0) {
                              _goal--;
                            } else {
                              _goal = 0;
                            }
                          });
                          setGoal(_goal);
                        },
                        icon: Icon(
                          Icons.remove_circle,
                        ),
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "$_goal",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          resetApp();

                          setState(() {
                            _goal++;
                          });
                          setGoal(_goal);
                        },
                        icon: Icon(
                          Icons.add_circle,
                        ),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var value in [0, 33, 100, "+100", "+1000"])
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                resetApp();

                                setState(() {
                                  if (value is int) {
                                    setGoal(_goal = value);
                                  } else if (value == "+100") {
                                    setGoal(_goal += 100);
                                  } else if (value == "+1000") {
                                    setGoal(_goal += 1000);
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(value.toString()),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(height: 10),
                Text(
                  "الاستغفار",
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "$_counter",
                  style: TextStyle(color: mainColor, fontSize: 20),
                ),
                SizedBox(height: 5),
                CircularIndicatorWidget(
                  width: 150,
                  height: 150,
                  current: _counter.toDouble(),
                  maxStep: _goal > 100 ? 100 : _goal.toDouble(),

                  //  < 100 ? _goal.toDouble() : 100,
                  widthLine: 2.5,
                  heightLine: 20,
                  curve: Curves.easeInOutCirc,
                  gradientColor: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [mainColor, Colors.orangeAccent],
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (_goal == 0) {
                          showGoalAlert(); // Show alert if goal is zero
                        } else {
                          if (_counter == _goal) {
                            _timer++;
                            _counter = 0; // Reset counter when goal is reached
                          } else {
                            _counter++; // Increment counter
                          }
                        }
                        setTime(_timer);

                        setCount(_counter);
                      });
                    },
                    icon: Icon(
                      Icons.touch_app,
                      color: mainColor,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "مرات التكرار :$_timer",
                  style: TextStyle(color: mainColor, fontSize: 15),
                ),
                SizedBox(height: 10),
                Text(
                  "المجموع :${_goal * _timer + _counter}",
                  style: TextStyle(color: mainColor, fontSize: 15),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Visibility(
                visible: isColorActive,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...[
                      0xFF4280BE,
                      0xFFBE425F,
                      0xFF9062B4,
                      0xFFBE4242,
                      0xFF429BBE,
                      0xFF000000
                    ].map((colorValue) {
                      return Radio(
                        fillColor: WidgetStateProperty.all(Color(colorValue)),
                        value: colorValue,
                        groupValue: colorHex,
                        onChanged: (val) {
                          setState(() {
                            colorHex = val!;
                            setColor(val);
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showGoalAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor:
                Color(colorHex), // Set background color to mainColor
            title: Text(
              "تنبيه",
              style:
                  TextStyle(color: Colors.white), // Change text color if needed
            ),
            content: Text(
              "يرجى تحديد هدف قبل البدء.",
              style:
                  TextStyle(color: Colors.white), // Change text color if needed
            ),
            actions: [
              TextButton(
                child: Text(
                  "موافق",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  resetApp({bool resetGoal = false}) {
    setCount(_counter = 0);
    setTime(_timer = 0);
    resetGoal == true ? setGoal(_goal = 0) : null;
  }

  setColor(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("color", value);
  }

  setCount(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("counter", value);
  }

  setTime(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("timer", value);
  }

  setGoal(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("goal", value);
  }

  getAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt("counter") ?? 0;
      _timer = prefs.getInt("timer") ?? 0;
      _goal = prefs.getInt("goal") ?? 0;
      colorHex = prefs.getInt("color") ?? 0xFF000000;
    });
  }

  @override
  void initState() {
    getAll();
    super.initState();
  }
}
