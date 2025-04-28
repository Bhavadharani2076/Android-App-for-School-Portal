import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:schoolportal/common.dart';

class ParentPaymentPage extends StatefulWidget {
  @override
  _ParentPaymentPageState createState() => _ParentPaymentPageState();
}

class _ParentPaymentPageState extends State<ParentPaymentPage> {
  List<Map<String, dynamic>> _tuitionFees = [];
  List<Map<String, dynamic>> _transportFees = [];
  List<Map<String, dynamic>> _activityFees = [];
  double _totalAmount = 0.0;
  late Razorpay _razorpay;
  List<String> _selectedFeeTypes = [];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    fetchFeeDetails();

    // Add Razorpay listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  Future<void> fetchFeeDetails() async {
    String admissionNo = user.substring(1);
    String fetchFeesUrl = '${ip}parent_get_fee.php';
    String fetchPaymentsUrl = '${ip}fetch_payment_details.php';

    try {
      var feesResponse = await http.post(
        Uri.parse(fetchFeesUrl),
        body: {'admission_number': admissionNo},
      );
      var paymentsResponse = await http.post(
        Uri.parse(fetchPaymentsUrl),
        body: {'admission_no': admissionNo},
      );

      var feesData = jsonDecode(feesResponse.body);
      var paidData = jsonDecode(paymentsResponse.body);

      if (feesData['status'] == 'true' && paidData['status'] == true) {
        setState(() {
          _parseFees(feesData['data'], paidData['data']);
        });
      }
    } catch (e) {
      print("Error fetching fee details: $e");
    }
  }

  void _parseFees(Map<String, dynamic> feesData, List<dynamic> paidData) {
    _tuitionFees.clear();
    _transportFees.clear();
    _activityFees.clear();

    Set<String> paidFees = {};

    for (var payment in paidData) {
      if (payment['isPaid'] == true && payment['paid_fees'] is Map) {
        paidFees.addAll(payment['paid_fees'].keys.cast<String>());
      }
    }

    feesData.forEach((category, feesList) {
      if (feesList is List) {
        for (var fee in feesList) {
          bool isPaid = paidFees.contains(fee['feetype']);
          Map<String, dynamic> feeData = {
            'id': fee['id'],
            'feeType': fee['feetype'],
            'amount': double.tryParse(fee['feeamount']) ?? 0.0,
            'paid': isPaid,
            'selected': false,
          };

          if (category == 'Tution Fee') {
            _tuitionFees.add(feeData);
          } else if (category == 'Transport Fee') {
            _transportFees.add(feeData);
          } else if (category == 'Activity Fee') {
            _activityFees.add(feeData);
          }
        }
      }
    });

    setState(() {});
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    _recordPayment(response.paymentId!);
  }

  Future<void> _recordPayment(String paymentId) async {
    String recordPaymentUrl = '${ip}parent_paymentbk.php';
    String admissionNo = user.substring(1);

    try {
      // Prepare the product_id as a map with fee names and their amounts
      Map<String, dynamic> productIdMap = {};

      // Add the selected fees into the productIdMap
      for (var fee in [..._tuitionFees, ..._transportFees, ..._activityFees]) {
        if (fee['selected']) {
          productIdMap[fee['feeType']] = fee['amount'];
        }
      }

      // Send the request with the required input format
      var response = await http.post(
        Uri.parse(recordPaymentUrl),
        headers: {
          'Content-Type': 'application/json', // Specify that you're sending JSON
        },
        body: jsonEncode({
          'admission_no': admissionNo,
          'razorpay_payment_id': paymentId,
          'totalAmount': _totalAmount.toString(),
          'product_id': productIdMap,
        }),
      );

      // Print the raw response body before attempting to decode it
      print("Raw Response: ${response.body}");
      print("Response headers: ${response.headers}");

      // Check if the response has a valid JSON format
      try {
        var data = jsonDecode(response.body); // Parse the JSON response

        if (data['status'] == true) {
          fetchFeeDetails();
        } else {
          print("Error recording payment: ${data['msg']}");
        }
      } catch (e) {
        print("Failed to decode response as JSON: ${response.body}");
      }

    } catch (e) {
      print("Error recording payment: $e");
    }
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed: ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed. Please try again.")),
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet selected: ${response.walletName}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External wallet selected: ${response.walletName}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Financial Report',
            style: TextStyle(
              color: Colors.white, // Title text color set to white
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: "Tuition Fee"),
              Tab(text: "Transport Fee"),
              Tab(text: "Activity Fee"),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0FBBBF),
                  Color(0xFF40E495),
                  Color(0xFF30DD8A),
                  Color(0xFF2BB673),
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft, // Matches the `to left` direction
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: TabBarView(
          children: [
            _buildFeeList(_tuitionFees),
            _buildFeeList(_transportFees),
            _buildFeeList(_activityFees),
          ],
        ),
        bottomNavigationBar: _buildPaymentSummary(),
      ),
    );
  }

  Widget _buildFeeList(List<Map<String, dynamic>> feeList) {
    return ListView.builder(
      itemCount: feeList.length,
      itemBuilder: (context, index) {
        var fee = feeList[index];
        return ListTile(
          leading: Checkbox(
            value: fee['selected'],
            onChanged: fee['paid']
                ? null
                : (bool? value) {
              setState(() {
                fee['selected'] = value ?? false;
                _calculateTotalAmount();
              });
            },
          ),
          title: Text(fee['feeType']),
          subtitle: Text("Rs ${fee['amount']}"),
          trailing: Text(
            fee['paid'] ? "Paid" : "Not Paid",
            style: TextStyle(color: fee['paid'] ? Colors.green : Colors.red),
          ),
        );
      },
    );
  }

  Widget _buildPaymentSummary() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Rs ${_totalAmount.toStringAsFixed(2)}"),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _totalAmount > 0 ? openCheckout : null,
            child: Text("Pay Now"),
          ),
        ],
      ),
    );
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_H2UTYFN9YkS4xf',
      'amount': (_totalAmount * 100).toString(),
      'name': 'School Fees',
      'description': 'Fee Payment',
      'prefill': {'contact': '', 'email': ''},
      'theme': {'color': '#528FF0'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void _calculateTotalAmount() {
    _totalAmount = 0.0;
    _selectedFeeTypes.clear();

    for (var fee in [..._tuitionFees, ..._transportFees, ..._activityFees]) {
      if (fee['selected']) {
        _totalAmount += fee['amount'];
        _selectedFeeTypes.add(fee['feeType']);
      }
    }

    setState(() {});
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
