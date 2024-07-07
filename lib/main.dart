import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:utip/providers/ThemeSelectorModel.dart';
import 'package:utip/providers/TipCalculatorModel.dart';
import 'package:utip/widgets/person_counter.dart';


void main() {
  runApp(

      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ( context) => Tipcalculatormodel() ),
          ChangeNotifierProvider(create: (context) => ThemeSelectorModel() )

        ],
          child: const MyApp()),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final themeToggle = Provider.of<ThemeSelectorModel>(context);

    return MaterialApp(
      title: 'UTip',
      //darkTheme: ThemeData.dark(),
      theme: themeToggle.themeData,
      // theme: ThemeData(
      //   // This is the theme of your application.
      //   //
      //   // TRY THIS: Try running your application with "flutter run". You'll see
      //   // the application has a purple toolbar. Then, without quitting the app,
      //   // try changing the seedColor in the colorScheme below to Colors.green
      //   // and then invoke "hot reload" (save your changes or press the "hot
      //   // reload" button in a Flutter-supported IDE, or press "r" if you used
      //   // the command line to start the app).
      //   //
      //   // Notice that the counter didn't reset back to zero; the application
      //   // state is not lost during the reload. To reset the state, use hot
      //   // restart instead.
      //   //
      //   // This works for code too, not just values: Most code changes can be
      //   // tested with just a hot reload.
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: const UTip(title: 'Flutter Demo Home Page'),
    );
  }
}

class UTip extends StatefulWidget {
  const UTip({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<UTip> createState() => _UTipState();
}

class _UTipState extends State<UTip> {
  int _counter = 1;
  var _tipPercentage = 0.0;
  double _billTotal = 0;


  void setBillAmountActionCallBack(String value){
    setState(() {
      _billTotal = double.parse(value);
    });

  }


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }



  double _calculateFullBill(){
    //return  ( (_billTotal) + (_billTotal*(_tipPercentage ))/_counter) ?? 0;
    double percentageAgainstTotalBill = _getTipAmount();
    return  ( (_billTotal + percentageAgainstTotalBill)/(_counter.toDouble())) ?? 0.0;
  }

  double _getTipAmount() {
    var percentageAgainstTotalBill = (_tipPercentage) * _billTotal;
    return percentageAgainstTotalBill;
  }

  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_counter > 1) {
      _counter--;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.fff
    var theme = Theme.of(context);
    final model = Provider.of<Tipcalculatormodel>(context);
    final themeToggle = Provider.of<ThemeSelectorModel>(context);

    final style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold
    );
    double overallTotal = _calculateFullBill();
    double totalTip = _getTipAmount();


    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the UTip object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('UTip'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Checkbox(value: themeToggle.selectedThemeGlobal  , onChanged: (value) => {
            themeToggle.setToggleTheme()
          }),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      "Total per Person",
                      style: style,
                    ),
                    Text(model.totalPerPerson.toStringAsFixed(2),
                    style: style.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontSize: theme.textTheme.displaySmall?.fontSize
                    ),

                    )

                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2
                )
              ),
              child:  Column(
              children: [
                BillAmountField(setBillAmountActionCallBack: (value) {
                  model.updateBillTotal(double.parse(value));
                }),
                PersonCounter(theme: theme, counter: model.personCount,
                  onDecrement: () {
                    if(model.personCount > 1){
                      model.updatePersonCount(model.personCount-1);
                    }
                  } ,
                  onIncrement: () {
                  model.updatePersonCount(model.personCount + 1 );
                  }
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tip",
                    style: theme.textTheme.titleMedium
                    ),
                    Text("\$ ${ (model.tipPercentage * 100 ).toStringAsFixed(2)}",
                    style: theme.textTheme.titleMedium)
                  ],
                ),
                // slider text
                Text("${(model.tipPercentage * 100).round()} %"),
                TipSlider(tipPercentage: model.tipPercentage, onChanged: (double value) {
                  model.updateTipPercentage(value);
                  }, )
              ],
            ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BillAmountField extends StatelessWidget {
  const BillAmountField({
    super.key,
    required this.setBillAmountActionCallBack,
  });

  final ValueChanged<String> setBillAmountActionCallBack;


  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.attach_money),
        labelText: "Bill Amount"),
        keyboardType: TextInputType.number,
        inputFormatters:  [FilteringTextInputFormatter.digitsOnly] ,
      onChanged: setBillAmountActionCallBack,
      );
  }
}

class TipSlider extends StatelessWidget {
  const TipSlider({
    super.key,
    required double tipPercentage,
    required this.onChanged,
  }) : _tipPercentage = tipPercentage;

  final double _tipPercentage;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Slider(min: 0.0,
        max: 0.50,
        divisions: 50,
        label: "${(_tipPercentage * 100).round()}",
        value: _tipPercentage,
        onChanged: onChanged

    );
  }
}

