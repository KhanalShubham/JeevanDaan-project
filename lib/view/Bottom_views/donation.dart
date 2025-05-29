import 'package:flutter/material.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  double totalDonation = 0.0;

  // List of patients with their details
  final List<Map<String, dynamic>> patients = [
    {
      'name': 'Anita Sharma',
      'condition': 'Cancer Treatment',
      'image': 'assets/patient1.jpg',
      'donationGoal': 500.0,
      'donatedAmount': 150.0,
    },
    {
      'name': 'Ramesh Thapa',
      'condition': 'Trauma Recovery',
      'image': 'assets/patient2.jpg',
      'donationGoal': 300.0,
      'donatedAmount': 100.0,
    },
    {
      'name': 'Sita Rai',
      'condition': 'Heart Surgery',
      'image': 'assets/patient3.jpg',
      'donationGoal': 700.0,
      'donatedAmount': 200.0,
    },
  ];

  void donate(double amount, int index) {
    setState(() {
      totalDonation += amount;
      patients[index]['donatedAmount'] += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate to Patients'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Total Donation Display
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Donated: \$${totalDonation.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic to process donation (e.g., payment gateway)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Donation Processed!')),
                      );
                    },
                    child: Text('Checkout'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Patients List
            Expanded(
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  final remaining = patient['donationGoal'] - patient['donatedAmount'];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(patient['image']),
                      ),
                      title: Text(
                        patient['name'],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient['condition'],
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Remaining: \$${remaining.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ],
                      ),
                      trailing: DropdownButton<double>(
                        value: 10.0, // Default value
                        items: [10.0, 20.0, 50.0].map((amount) {
                          return DropdownMenuItem<double>(
                            value: amount,
                            child: Text('\$${amount.toStringAsFixed(0)}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            donate(value, index);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}