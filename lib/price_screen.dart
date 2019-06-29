import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  Map<String, String> value_for_coin = Map();

  _PriceScreenState() {
    init_crypto_list();
  }

  void init_crypto_list() {
    cryptoList.forEach((foo) {
      value_for_coin[foo] = '?';
    });
  }

  foo() {
    List<Widget> column_widgets = cryptoList.map((crypto_coin) {
      return buildPadding(crypto_coin);
    }).toList();
    column_widgets.add(Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          height: 150.0,
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom: 30.0),
          color: Colors.lightBlue,
          child: Platform.isIOS ? iOSPicker() : androidDropdown(),
        )));
    return column_widgets;
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
//          getData();
        });
      },
      children: pickerItems,
    );
  }

  String value = '?';

  void getData() {
    try {
      value_for_coin.keys.forEach((coin) async {
        double data = await CoinData().getCoinData(coin, selectedCurrency);
        setState(() {
          value_for_coin[coin] = data.toStringAsFixed(0);
          print(value_for_coin);
        });
      });
    } catch (e) {
      print(e);
    }
  }

//  List<Widget> column_widgets = List<Widget>();

  @override
  void initState() {
    super.initState();
//    getData('BTC');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: foo(),
      ),
    );
  }

  Padding buildPadding(crypto_coin) {
//    print(selectedCurrency);
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto_coin = ${value_for_coin[crypto_coin]} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
