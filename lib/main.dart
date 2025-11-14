import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: InputScreen(),
      debugShowCheckedModeBanner: false,
    ));


// 🧾 Screen 1: Input Screen (Takes user input)
class InputScreen extends StatefulWidget {
  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final income = TextEditingController();
  final rent = TextEditingController();
  final food = TextEditingController();
  final transport = TextEditingController();
  final others = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Monthly Budget")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Input fields (Widgets + Layout)
              Image.asset("assets/img.png", height: 120),
              TextField(
                  controller: income,
                  decoration: InputDecoration(labelText: "Monthly Income")),
              TextField(
                  controller: rent,
                  decoration: InputDecoration(labelText: "Rent / EMI")),
              TextField(
                  controller: food,
                  decoration: InputDecoration(labelText: "Food Expenses")),
              TextField(
                  controller: transport,
                  decoration: InputDecoration(labelText: "Transport")),
              TextField(
                  controller: others,
                  decoration: InputDecoration(labelText: "Other Expenses")),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Show Result"),
                onPressed: () {
                  // Navigation + Passing Data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        income: double.tryParse(income.text) ?? 0,
                        rent: double.tryParse(rent.text) ?? 0,
                        food: double.tryParse(food.text) ?? 0,
                        transport: double.tryParse(transport.text) ?? 0,
                        others: double.tryParse(others.text) ?? 0,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// 📊 Screen 2: Result Screen (Uses ListView + Dynamic data)
class ResultScreen extends StatelessWidget {
  final double income, rent, food, transport, others;
  ResultScreen(
      {required this.income,
      required this.rent,
      required this.food,
      required this.transport,
      required this.others});

  @override
  Widget build(BuildContext context) {
    double balance = income - (rent + food + transport + others);
    bool overspending = balance < 0;

    // Dynamic data for ListView.builder
    final expenses = {
      "Rent / EMI": rent,
      "Food": food,
      "Transport": transport,
      "Others": others,
    };

    return Scaffold(
      appBar: AppBar(title: Text("Result")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Monthly Income: ₹$income",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 10),

            // ✅ Customized Dynamic ListView using ListView.builder
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  String key = expenses.keys.elementAt(index);
                  double value = expenses[key]!;
                  return Card(
                    color: Colors.blue[50],
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(key),
                      trailing: Text("₹$value"),
                    ),
                  );
                },
              ),
            ),

            Divider(),
            Text(
              "Remaining Balance: ₹${balance.toStringAsFixed(2)}",
              style: TextStyle(
                color: overspending ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              overspending
                  ? "⚠ You are overspending!"
                  : "✅ You are saving money!",
              style: TextStyle(
                color: overspending ? Colors.red : Colors.green,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
