import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.email),
            title: Text("Contact Us via Email"),
            subtitle: Text("support@jeevandaan.com"),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text("Call Our Helpline"),
            subtitle: Text("+977 9800000000"),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Frequently Asked Questions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ExpansionTile(
            title: Text("How do I create a request?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    "To create a request, go to the dashboard and tap the 'Add Request' button. Fill in the required details and submit."),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Is my data secure?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    "Yes, we take data privacy very seriously. All your data is encrypted and stored securely. Please refer to our Privacy Policy for more details."),
              )
            ],
          ),
        ],
      ),
    );
  }
}