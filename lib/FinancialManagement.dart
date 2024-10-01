import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Management',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          color: Colors.green,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          color: Colors.grey[900],
        ),
      ),
      themeMode: ThemeMode.system,
      home: const FinancialManagement(),
    );
  }
}

class FinancialManagement extends StatefulWidget {
  const FinancialManagement({super.key});

  @override
  _FinancialManagementState createState() => _FinancialManagementState();
}

class _FinancialManagementState extends State<FinancialManagement> {
  final TextEditingController _expenseController = TextEditingController();
  List<Map<String, String>> _expenses = [];
  final List<Map<String, String>> _loans = [
    {'name': 'Loan A', 'details': 'Low interest, short term'},
    {'name': 'Loan B', 'details': 'High amount, long term'},
  ];
  double _totalExpenses = 0;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expenseData = prefs.getStringList('expenses') ?? [];
    setState(() {
      _expenses = expenseData.map((e) {
        final parts = e.split(';');
        return {'date': parts[0], 'amount': parts[1]};
      }).toList();
      _totalExpenses = _expenses.fold(
          0, (sum, item) => sum + double.parse(item['amount']!));
    });
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expenseData = _expenses.map((e) => '${e['date']};${e['amount']}').toList();
    await prefs.setStringList('expenses', expenseData);
  }

  void _addExpense() {
    final amountStr = _expenseController.text;
    final amount = double.tryParse(amountStr);

    if (amount != null) {
      setState(() {
        _expenses.add({
          'date': DateTime.now().toString(),
          'amount': amount.toStringAsFixed(2),
        });
        _totalExpenses += amount;
        _expenseController.clear();
        _saveExpenses();
      });
    }
  }

  void _removeExpense(int index) {
    setState(() {
      _totalExpenses -= double.parse(_expenses[index]['amount']!);
      _expenses.removeAt(index);
      _saveExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Management'),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.green,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: isDarkMode ? Colors.grey[800] : Colors.green.withOpacity(0.1),
        child: ListView(
          children: [
            // Expense Tracking
            TextField(
              controller: _expenseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Add Expense',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addExpense,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Expenses: ₹${_totalExpenses.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Expense List
            Text(
              'Expense List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            ..._expenses.asMap().entries.map((entry) {
              final index = entry.key;
              final expense = entry.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    '₹${expense['amount']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    expense['date']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeExpense(index),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Crop Profitability Analysis
            Text(
              'Crop Profitability Analysis',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  'Analyze Profitability',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Text(
                  'Calculate the profitability of your crops based on expenses and yields.',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                trailing: Icon(Icons.analytics, color: isDarkMode ? Colors.white : Colors.black),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfitabilityAnalysis()),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Agricultural Loans
            Text(
              'Agricultural Loans',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            ..._loans.map((loan) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    loan['name']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    loan['details']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  trailing: Icon(Icons.monetization_on, color: isDarkMode ? Colors.white : Colors.black),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoanDetails(loan: loan),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ProfitabilityAnalysis extends StatelessWidget {
  const ProfitabilityAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profitability Analysis'),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.green,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Center(
        child: Text(
          'Crop Profitability Analysis will be implemented here.',
          style: TextStyle(
            fontSize: 18,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class LoanDetails extends StatelessWidget {
  final Map<String, String> loan;

  const LoanDetails({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(loan['name']!),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.green,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loan Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: ${loan['name']}',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Details: ${loan['details']}',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
