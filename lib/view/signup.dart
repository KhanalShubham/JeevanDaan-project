import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Map userData = {};
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.blueGrey),
                  ),
                  child: Image.asset(
                    'assets/lottie/images/logo.png',
                    height: 30,
                    width: 20,
                  ),
                ),
              ),

              //for name feild
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Name",
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    ),
                    errorStyle: TextStyle(fontSize: 18.0),
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Enter your Full Name"),
                    PatternValidator(r'^[a-zA-Z ]+$', errorText: "Name must contain only alphabets and spaces"),

                  ]),
                ),
              ),
              //for email feild 
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    ),
                    errorStyle: TextStyle(fontSize: 18.0),
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Enter email address"),
                    EmailValidator(errorText: "Enter a valid email address example: someone@gmail.com"),
                  ]),
                ),
              ),
              //for phone number feild 
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    ),
                    errorStyle: TextStyle(fontSize: 18.0),
                  ),
                  validator: MultiValidator([
                     RequiredValidator(errorText: "Enter your phone number"),
                     PatternValidator(r'^[0-9]{10}$', errorText: "Enter a valid 10-digit phone number"),
                  ]),
                ),
              ),
              //for password feild 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                child: TextFormField(
                  obscureText: true,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Please enter your password"),
                    MinLengthValidator(8, errorText: "Password must be at least 8 characters"),
                    PatternValidator(r'(?=.*?[#!@$%^&*-])', errorText: "Password must have at least one special character"),
                  ]),
                  decoration: InputDecoration(
                    hintText: "Password",
                    labelText: "Password",
                    prefixIcon: Icon(Icons.key, color: Colors.black),
                    errorStyle: TextStyle(fontSize: 18.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    ),
                  ),
                ),
              ),
              Padding(
              padding: const EdgeInsets.all(28.0),
              child: Container(
                width: double.infinity, // to stretch button full width — optional
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      print("Form submitted");
                    }
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                
              ),
              
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0,30,0,0),
                child: Center(
                  child: Text(
                    "Or Sign Up using !",
                    style: TextStyle(
                      fontSize: 18,color: Colors.black
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0,20,0,0),
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      "assets/lottie/images/google.png",
                      
                      fit: BoxFit.cover,
                    ),
                    
                  ),
                  
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,20,0,0),
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      "assets/lottie/images/facebook.png",
                      
                      fit: BoxFit.cover,
                    ),
                    
                  ),
                  
                ),
                Center(
                  child: Container( 
                          padding: EdgeInsets.only(top: 50), 
                          child: Text( 
                            'Already have an account click here ', 
                            style: TextStyle( 
                              fontSize: 20, 
                              
                              // Bold text.
                              fontWeight: FontWeight.w700, 
                              
                              // Text color.
                              color: Colors.lightBlue, 
                            ), 
                          ), 
                        ),
                )
              ],
            )
              
            ],
          ),
        ),
      ),

    );
  }
}