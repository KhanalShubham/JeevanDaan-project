import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:jeevandaan/view/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map userData = {};
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              // Logo Section
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
              // Email Field
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
              // Password Field
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
                    prefixIcon: Icon(Icons.key, color: Colors.green),
                    errorStyle: TextStyle(fontSize: 18.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(200,0,0,0),
                child: Text("Forget Password"),
              ),
              //login button
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
                    "Login",
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
                    "Or Sign In using !",
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container( 
                            padding: EdgeInsets.only(top: 50), 
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>Signup()),
                                );
                              },
                            
                            child: Text(
                              'SIGN UP!', 
                              style: TextStyle( 
                                fontSize: 20, 
                                
                                // Bold text.
                                fontWeight: FontWeight.w700, 
                                
                                // Text color.
                                color: Colors.lightBlue, 
                              ), 
                            ), 
                          ),
                    ),
                  )
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
