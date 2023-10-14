import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
    home: CalcMain()
  )
  );
}

Color tintColor = const Color(0xFF02F08F);

class CalcMain extends StatefulWidget {
  const CalcMain({Key? key}) : super(key: key);

  @override
  _CalcMainState createState() => _CalcMainState();
}

class _CalcMainState extends State<CalcMain> {
  Color tintColor = const Color(0xFF02F08F);
  String txt = "";

  @override
  Widget build(BuildContext context) {
   const  mainBlue = Color(0xFF0A1436);
   const  midBorder = Color(0xFF636E8C);








    return Scaffold(
          backgroundColor: mainBlue,
          body: Column(
            children: [

              Expanded(                                        //top part taking 35% space
                flex: 35,
                child: Stack(
                  children: [
                    Positioned(
                      top: 35,
                      left: 20,
                      child: IconButton(
                        padding: EdgeInsets.zero,                 //to remove
                        constraints: const BoxConstraints(),      //extra padding
                        icon: const Icon(Icons.colorize),
                        color: Colors.white,
                        onPressed: () => pickColor(context),
                      )
                    ),

                    Positioned(
                      right: 20,
                      bottom: 10,
                      child: Text(
                          txt,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 30
                        ),

                      ),
                    )
                  ],
                ),
              ),

              const Divider(
                color: midBorder,
                height: 1,
                thickness: 2.2,
                indent: 20,     //spacing at the start of divider
                endIndent: 20,  //spacing at the end of divider
              ),

              Expanded(                                              //buttons taking 65% space
                flex: 65,
                child: GridView.count(
                  padding: EdgeInsets.zero,                          //remove padding
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: (10/9),
                  children: createButt(tintColor)
                ),
              )
            ],
          ),
    );


 }
  void pickColor(BuildContext context) => showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Center(
              child: Text(
                "Create a Color",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            content: SizedBox(
              height: 330,
              width: 250,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemCount: colors.length,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              tintColor = colors[index];
                            });
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors[index],
                            padding: const EdgeInsets.all(16),
                          ),
                          child: Container(),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

// List of colors for the buttons
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.amber,
    Colors.lime,
    Colors.indigo,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.deepOrangeAccent,
    Colors.deepPurpleAccent,
  ];



  void calculate() {
    txt = txt.replaceAll("÷", "/").replaceAll("×", "*").replaceAll("–", "-");
    try {
      Parser p = Parser();
      Expression exp = p.parse(txt);                                      //parser to evaluate strings
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      txt = result.toString();
      if (result == result.round()) {
        txt = result.round().toString();
      } else {
        txt = result.toStringAsFixed(2);
      }
    }
    catch (e) {
      txt = "";
      Fluttertoast.showToast(                                        //toast notification for error
          msg: "Error occurred in expression",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }


  List<TextButton> createButt(Color X) {       //to create buttons grid wise
    Color buttColor = Colors.white;
    const double fSize = 27;
    const List<String> symbol =
    [
      '(', ')', '%', '÷',
      '7', '8', '9', '×',
      '4', '5', '6', '–',
      '1', '2', '3', '+',
      'AC', '0', '.', '='
    ];
    List<TextButton> butts = [];

    for(int i = 0; i < 20; i++) {

      if ( i==2 || i==3 || i==7 || i == 11 || i == 15) {      //color symbols
        buttColor = X;
      }

      var butt = TextButton(                              //create actual button
        style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            foregroundColor: buttColor,
            textStyle:
            const TextStyle(
                fontSize: fSize,
                fontFamily: 'SF Text Compact Medium'
            )
        ),

        child: Text(symbol[i]),                             //button text

        onPressed: () {                                     //button actions
          setState(() {
            if (symbol[i] == "AC") {
              txt = "";
            }
            else if (symbol[i] == "=") {
              calculate();
            }
            else {
              txt += symbol[i];                            //append texts on button press
            }
          });
        },

      );

      butts.add(butt);                                    //add button to the list
      buttColor = Colors.white;

    }
    return butts;
  }
}







