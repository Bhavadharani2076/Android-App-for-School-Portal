import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolportal/common.dart';

class PaymentPage extends StatefulWidget {
  @override
  _ParentPaymentPageState createState() => _ParentPaymentPageState();
}

class _ParentPaymentPageState extends State<PaymentPage> {
  List<Map<String, dynamic>> _tuitionFees = [];
  List<Map<String, dynamic>> _transportFees = [];
  List<Map<String, dynamic>> _activityFees = [];
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fetchFeeDetails();
  }

  Future<void> fetchFeeDetails() async {
    String admissionNo = user;
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Financial Report',
            style: TextStyle(
              color: Colors.white,
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
                end: Alignment.centerLeft,
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
      ),
    );
  }

  Widget _buildFeeList(List<Map<String, dynamic>> feeList) {
    return ListView.builder(
      itemCount: feeList.length,
      itemBuilder: (context, index) {
        var fee = feeList[index];
        return ListTile(
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
}
