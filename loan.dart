import 'package:flutter/material.dart';
import 'package:payment/components/btn.dart';
import 'package:payment/constants/constants.dart';
import 'package:payment/utils/help.dart';

class Loan extends StatefulWidget {
  const Loan({super.key});

  @override
  State<Loan> createState() => _LoanState();
}

class _LoanState extends State<Loan> {
  final TextEditingController _pp = TextEditingController();
  final TextEditingController _dp = TextEditingController();
  final TextEditingController _fa = TextEditingController();
  final TextEditingController _ir = TextEditingController();
  final TextEditingController _t = TextEditingController();
  String _conPP = "";
  String _conDP = "";
  double downPayment = 0;

  void _showDialog(BuildContext? ctx) {
// check the value is not null or empty before show up
    if (_pp.text.isEmpty ||
        _dp.text.isEmpty ||
        _ir.text.isEmpty ||
        _t.text.isEmpty) {
      // show the error message snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // calculate the down payment

    double principal = double.parse(_pp.text.replaceAll(',', '')) -
        double.parse(_dp.text.replaceAll(',', ''));

    double monthly = principal / int.parse(_t.text);
    double interest = (principal * double.parse(_ir.text)) / 100;
    double totalInterest = interest * int.parse(_t.text);

    // bottome sheet
    showModalBottomSheet(
        context: ctx!,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Loan Amount"),
                  trailing: Text(formatNumber(_pp.text.replaceAll(',', ''))),
                ),
                ListTile(
                  title: const Text("Down Payment"),
                  trailing: Text(formatNumber(_dp.text.replaceAll(',', ''))),
                ),
                ListTile(
                  title: const Text("Principal"),
                  trailing: Text(formatNumber(principal.toStringAsFixed(0))),
                ),
                ListTile(
                  title: const Text("Interest Rest"),
                  trailing: Text("${_ir.text}%"),
                ),
                ListTile(
                  title: const Text("Loan Term"),
                  trailing: Text(_t.text),
                ),
                ListTile(
                  title: const Text("Term Payment"),
                  trailing: Text(formatNumber(monthly.toStringAsFixed(0))),
                ),
                ListTile(
                  title: const Text("interest term"),
                  trailing: Text(formatNumber(interest.toStringAsFixed(0))),
                ),
                ListTile(
                  title: const Text("Total Interest"),
                  trailing:
                      Text(formatNumber(totalInterest.toStringAsFixed(0))),
                ),
                ListTile(
                  title: const Text("Total Payment"),
                  trailing: Text(
                      formatNumber((monthly + interest).toStringAsFixed(0))),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Caclulator"),
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: MyButton(
          onTap: () => _showDialog(context),
          text: "Calculate",
        ),
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: _pp,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Loan Amount',
                suffixText: "USD"),
            onChanged: (String? string) {
              if (string!.isEmpty) {
                // clear data
                _dp.clear();
                _fa.clear();
                _ir.clear();
                _t.clear();
                setState(() {
                  downPayment = 0.0;
                });
                return;
              }
              _conPP = string.replaceAll(',', '');
              string = toMoney(string.replaceAll(',', ''));
              _pp.value = TextEditingValue(
                  text: string,
                  selection: TextSelection.collapsed(offset: string.length));
              if (_conPP != "" && _conDP != "") {
                String total =
                    (int.parse(_conPP) - int.parse(_conDP)).toString();
                _fa.value = TextEditingValue(
                    text: toMoney(total),
                    selection: TextSelection.collapsed(offset: total.length));
              }
            },
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          Text("Down Payment (${downPayment.toStringAsFixed(0)}%)"),
          Slider(
              value: downPayment,
              min: 0,
              max: 100,
              divisions: 100,
              label: "${downPayment.toStringAsFixed(0)}%",
              onChanged: (double? value) {
                int pp = int.parse(_pp.text.replaceAll(',', ''));
                int dp = (pp * value! / 100).round();
                setState(() {
                  downPayment = value;
                  _dp.text = toMoney(dp.toString().replaceAll(',', ''));
                });
              }),
          const SizedBox(
            height: kDefaultPadding,
          ),
          TextField(
            controller: _dp,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Down Payment',
            ),
            onChanged: (String? string) {
              if (string!.isEmpty) return;
              if (int.parse(string.replaceAll(',', '')) > int.parse(_conPP)) {
                _dp.text = _conPP;
                return;
              }
              _conDP = string.replaceAll(',', '');
              string = toMoney(string.replaceAll(',', ''));
              _dp.value = TextEditingValue(
                  text: string,
                  selection: TextSelection.collapsed(offset: string.length));
              // check if the down payment is not empty
              if (_conDP != "") {
                // check if the loan amount is not empty
                if (_conPP != "") {
                  // calculate the percentage of down payment
                  double dp = int.parse(_conDP) / int.parse(_conPP) * 100;
                  setState(() {
                    downPayment = dp;
                  });
                } else {
                  // check if the loan amount is empty
                  String total =
                      (int.parse(_conDP) / downPayment * 100).toString();
                  _conPP = total.replaceAll('.', '');
                  _pp.text = toMoney(total.replaceAll('.', ''));
                }
              }
            },
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          TextField(
            controller: _ir,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Interest Rate',
                suffixIcon: Icon(Icons.percent_outlined)),
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          TextField(
            controller: _t,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Loan Term (Month)',
                suffixIcon: Icon(Icons.calendar_month_outlined)),
          )
        ]),
      ),
    );
  }
}
