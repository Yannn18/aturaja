import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aturaja/data/models/registration_data_model.dart'; // Sesuaikan path jika berbeda

class VerifyIdentityScreen extends StatefulWidget {
  // BERSIH: Parameter eksternal dihapus mengikuti rute baru main.dart
  const VerifyIdentityScreen({Key? key}) : super(key: key);

  @override
  State<VerifyIdentityScreen> createState() => _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState extends State<VerifyIdentityScreen> {
  final int _otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _otpValues;

  int _secondsLeft = 48;
  Timer? _timer;

  late RegistrationDataModel _registrationModel;
  bool _modelLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_modelLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is RegistrationDataModel) {
        _registrationModel = args;
        _modelLoaded = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _otpValues = List.generate(_otpLength, (_) => '');
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  String _formatTimer(int secs) {
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  String get _formattedPhone {
    if (!_modelLoaded) return "+62 812 •••• 889";
    String clean = _registrationModel.phone.replaceAll(RegExp(r'\D'), '');
    if (clean.startsWith('0')) {
      clean = '62${clean.substring(1)}';
    } else if (!clean.startsWith('62')) {
      clean = '62$clean';
    }

    final country = '+${clean.substring(0, 2)}';
    final prefix = clean.length >= 5 ? clean.substring(2, 5) : '812';
    final suffix = clean.length >= 3
        ? clean.substring(clean.length - 3)
        : '889';
    return "$country $prefix •••• $suffix";
  }

  void _handleOtpChange(String value, int index) {
    if (value.isEmpty) {
      _otpValues[index] = '';
      return;
    }

    final character = value.substring(value.length - 1);
    _otpValues[index] = character;
    _controllers[index].text = character;

    if (index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    final finalCode = _otpValues.join('');
    if (finalCode.length == _otpLength && !_otpValues.contains('')) {
      FocusScope.of(context).unfocus();
      Future.delayed(const Duration(milliseconds: 600), () {
        // OPER KOPER DATA KE SCREEN BERIKUTNYA (/scan-ktp)
        Navigator.pushReplacementNamed(
          context,
          '/scan-ktp',
          arguments: _registrationModel,
        );
      });
    }
  }

  void _handleResend() {
    if (_secondsLeft == 0) {
      setState(() {
        _secondsLeft = 59;
        _otpValues = List.generate(_otpLength, (_) => '');
        for (var controller in _controllers) {
          controller.clear();
        }
      });
      _focusNodes.first.requestFocus();
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_modelLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFFFF1F2).withOpacity(0.15),
              const Color(0xFFFECDD3).withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD31111),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD31111).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.shield, color: Colors.white, size: 32),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Verify Identity",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: "We've sent a 6-digit verification code to\n",
                      ),
                      TextSpan(
                        text: _formattedPhone,
                        style: const TextStyle(
                          color: Color(0xFF030712),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_otpLength, (index) {
                    return Expanded(
                      child: Container(
                        height: 54,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: (event) {
                            if (event is RawKeyDownEvent &&
                                event.logicalKey ==
                                    LogicalKeyboardKey.backspace) {
                              if (_controllers[index].text.isEmpty &&
                                  index > 0) {
                                _focusNodes[index - 1].requestFocus();
                                _controllers[index - 1].clear();
                              }
                            }
                          },
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "0",
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              contentPadding: EdgeInsets.zero,
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Color(0xFFF3F4F6),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD31111),
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (val) => _handleOtpChange(val, index),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Resend code in ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      _formatTimer(_secondsLeft),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD31111),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _secondsLeft > 0 ? null : _handleResend,
                  child: Text(
                    "Send code via WhatsApp instead",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _secondsLeft > 0
                          ? const Color(0xFFE5E7EB)
                          : const Color(0xFFD31111),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEF2F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: Color(0xFFD31111),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sesi Terenkripsi Aktif",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Setiap transaksi dan akses data Anda saat ini dilindungi oleh enkripsi otomatis untuk menjamin privasi tetap terjaga.",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9CA3AF),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Issues receiving the code? ",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "HELP CENTER",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD31111),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
