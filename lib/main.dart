import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.black26,
                        width: 1)),
                textStyle: TextStyle(fontSize: 28))),
        colorScheme: ColorScheme.dark(primary: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _previousNumber = '0';
  String _currentNumber = '0';
  String _mathSymbol = '';
  int _displayMaxLength = 16;
  bool _isCalculated = false;

  void _appendNumber(String additionNumber) {
    if (_currentNumber.length == _displayMaxLength) {
      return;
    }
    setState(() {
      if (_currentNumber == '0' || _isCalculated) {
        _currentNumber = additionNumber;
        _isCalculated = false;
      } else {
        _currentNumber += additionNumber;
      }
    });
  }

  void _addFraction() {
    if (!_currentNumber.contains('.') && !_isCalculated) {
      setState(() {
        _currentNumber += '.';
      });
    }
  }

  void _removeDigit() {
    setState(() {
      if (_currentNumber == '0') {
        _previousNumber = '0';
      }

      if (_currentNumber.length == 1 ||
          (_currentNumber.contains('-') && _currentNumber.length == 2) ||
          _isCalculated) {
        _currentNumber = '0';
      } else if (_currentNumber != '0') {
        _currentNumber = _currentNumber.substring(0, _currentNumber.length - 1);
      }
    });
  }

  void _addDoubleZero() {
    if (_isCalculated) {
      return;
    }
    setState(() {
      if (_currentNumber != '0' &&
          _currentNumber.length < _displayMaxLength - 1) {
        _currentNumber += '00';
      }
    });
  }

  void _setNegative() {
    setState(() {
      if (_currentNumber != '0' && !_currentNumber.contains('-')) {
        _currentNumber = '-$_currentNumber';
      } else if (_currentNumber.contains('-')) {
        _currentNumber = _currentNumber.replaceAll('-', '');
      }
    });
  }

  void _calculatePercentage() {
    if (_currentNumber == '0') {
      return;
    }

    Decimal result =
        (Decimal.parse(_currentNumber) / Decimal.fromInt(100)).toDecimal();

    setState(() {
      _isCalculated = true;
      _currentNumber = result.toString().length <= _displayMaxLength
          ? result.toString()
          : result.toStringAsExponential();
    });
  }

  void _setOperator(String operator) {
    setState(() {
      _mathSymbol = operator;
      _previousNumber = _currentNumber;
      _isCalculated = true;
    });
  }

  void _calculate() {
    late Decimal result;

    switch (_mathSymbol) {
      case '+':
        result = Decimal.parse(_previousNumber) + Decimal.parse(_currentNumber);
      case '-':
        result = Decimal.parse(_previousNumber) - Decimal.parse(_currentNumber);

      case '*':
        result = Decimal.parse(_previousNumber) * Decimal.parse(_currentNumber);

      case '/':
        if (_currentNumber == '0') {
          setState(() {
            _isCalculated = true;
            _currentNumber = 'DMM';
          });
          return;
        }
        result =
            (Decimal.parse(_previousNumber) / Decimal.parse(_currentNumber))
                .toDecimal(scaleOnInfinitePrecision: _displayMaxLength);
    }

    setState(() {
      _isCalculated = true;
      _currentNumber = result.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: AutoSizeText(
                        _currentNumber,
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white),
                        minFontSize: 48,
                        maxFontSize: 64,
                        wrapWords: false,
                        maxLines: 1,
                        stepGranularity: 0.5,
                        strutStyle: StrutStyle(
                          height: MediaQuery.of(context).size.height / 80,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _removeDigit(),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.grey),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          child: Text(_currentNumber == '0' ? 'AC' : 'C'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _setNegative(),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.grey),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          child: Text('+/-'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _calculatePercentage(),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.grey),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          child: Text('%'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _setOperator('/'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          child: Text('÷'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _appendNumber('7'),
                          child: Text('7'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _appendNumber('8'),
                          child: Text('8'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _appendNumber('9'),
                          child: Text('9'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _setOperator('*'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          child: Text('x'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _appendNumber('4'),
                          child: Text('4'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _appendNumber('5'),
                          child: Text('5'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _appendNumber('6'),
                          child: Text('6'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _setOperator('-'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          child: Text('-'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _appendNumber('1'),
                          child: Text('1'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _appendNumber('2'),
                          child: Text('2'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _appendNumber('3'),
                          child: Text('3'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _setOperator('+'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          child: Text('+'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _appendNumber('0'),
                          child: Text('0'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _addDoubleZero(),
                          child: Text('00'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _addFraction(),
                          child: Text('.'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _calculate(),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          child: Text('='),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
