import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _matricnoController = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _matricnoFocusNode = FocusNode();

  // Decide
  void decide() {
    String name = _nameController.text;
    String matricNo = _matricnoController.text;
    List<String> matricDetails = matricNo.split("/");
    List<String> allowedDept = ["MTH", "PHY", "CSC", "GEO", "BIO"];
    Map<String, String> deptMap = {
      "MTH": "Mathematics",
      "CSC": "Computer Science",
      "PHY": "Physics",
      "GEO": "Geography",
      "BIO": "Biology",
    };

    // for (String a in matricDetails) print(a);
    // print(name);

    String deptName = deptMap[matricDetails[2].toUpperCase()] ?? "AN <INVALID>";
    bool allowed = allowedDept.contains(matricDetails[2].toUpperCase());

    String successMessage =
        "Congratulations $name from $deptName department, you have been choosen to attend the seminar";
    String failureMessage =
        "We are sorry $name from $deptName department, you are NOT choosen to attend this seminar";

    if (name == "" ||
        matricNo == "" ||
        matricDetails[1] != "18" ||
        matricDetails.length != 4) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Response"),
            content: Text("Please enter valid input\n\n" +
                "Confirm\n" +
                "1. Name or Matric No. is not empty \n2. Not in 300 Level (i.e not Kasu/18)"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Retry"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Response"),
            content: Text(allowed ? successMessage : failureMessage),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Done"),
              ),
            ],
          );
        },
      );
    }
  }

  // clears input field
  void clear() {
    setState(() {
      _nameController.text = "";
      _matricnoController.text = "";
    });
  }

  // validate matric no
  String validateMatricNo(String matricNo) {
    String matricNo = _matricnoController.text;
    List<String> matricDetails = matricNo.split("/");
    int matricDigit = int.parse(matricDetails[3]);
    //List<int> tens = List<int>.generate(99, (int index) => index + 1000);
    //List<int> twenties = List<int>.generate(99, (index) => index + 2000);

    if (matricDigit < 1001 || matricDigit > 2099)
      return "Enter valid digit e.g 1001";
    else
      return "";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text("The Seminar",
                style: TextStyle(fontSize: 28, fontFamily: "cursive")),
            centerTitle: true,
          ),
          body: Center(
            child: Container(
              height: 200,
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(1, 1),
                    color: Colors.grey[300],
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_form.currentState.validate()) decide();
                          },
                          child: Text("Decide"),
                        ),
                        SizedBox(width: 3),
                        ElevatedButton(
                          onPressed: () {
                            clear();
                          },
                          child: Text("Clear"),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).requestFocus(_matricnoFocusNode);
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _matricnoController,
                      focusNode: _matricnoFocusNode,
                      decoration: InputDecoration(
                        labelText: "Matric No.",
                        border: OutlineInputBorder(),
                        counterText: "",
                      ),
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).unfocus();
                      },
                      maxLength: 16,
                      validator: (String value) {
                        List<String> matricDetails = value.split("/");
                        int matricDigit = int.parse(matricDetails[3]);
                        //List<int> tens = List<int>.generate(99, (int index) => index + 1000);
                        //List<int> twenties = List<int>.generate(99, (index) => index + 2000);

                        if (matricDigit < 1001 || matricDigit > 2099)
                          return "Enter valid digit e.g 1001";
                        else
                          return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
