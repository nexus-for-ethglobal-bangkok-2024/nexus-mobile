import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nexus_mobile/login_screen.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _result = '';
  bool logoutVisible = false;
  String rpcUrl = 'https://rpc.ankr.com/eth_sepolia';
  // TextEditingController for handling input from the text field
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    // This is important to trigger the on Android.
    if (state == AppLifecycleState.resumed) {
      Web3AuthFlutter.setCustomTabsClosed();
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Uri redirectUrl;
    String clientId =
        'BKjUQ9w3wTF9yngCfvxvI4wt78l8FJdCJt6w_vBnlDQG7xAPWobxTovvXReaUA_5c-_kBG8H27M1azZ8jF9MW0U';
    if (Platform.isAndroid) {
      redirectUrl = Uri.parse('w3a://com.example.nexus_mobile');
    } else if (Platform.isIOS) {
      redirectUrl = Uri.parse('com.example.nexus_mobile://auth');
    } else {
      throw UnKnownException('Unknown platform');
    }

    await Web3AuthFlutter.init(Web3AuthOptions(
      clientId: clientId,
      network: Network.sapphire_devnet,
      redirectUrl: redirectUrl,
      buildEnv: BuildEnv.production,
      sessionTime: 259200,
    ));

    await Web3AuthFlutter.initialize();

    final String res = await Web3AuthFlutter.getPrivKey();
    log(res);
    if (res.isNotEmpty) {
      setState(() {
        logoutVisible = true;
      });
    }
  }

  Future<void> _login(Future<Web3AuthResponse> Function() method) async {
    try {
      final Web3AuthResponse response = await method();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('privateKey', response.privKey.toString());
      setState(() {
        _result = response.toString();
        logoutVisible = true;
      });
    } on UserCancelledException {
      log("User cancelled.");
    } on UnKnownException {
      log("Unknown exception occurred");
    }
  }

  VoidCallback _logout() {
    return () async {
      try {
        setState(() {
          _result = '';
          logoutVisible = false;
        });
        await Web3AuthFlutter.logout();
      } on UserCancelledException {
        log("User cancelled.");
      } on UnKnownException {
        log("Unknown exception occurred");
      }
    };
  }

  Future<Web3AuthResponse> _withEmailPasswordless(String userEmail) async {
    try {
      log(userEmail);
      return await Web3AuthFlutter.login(LoginParams(
        loginProvider: Provider.email_passwordless,
        extraLoginOptions: ExtraLoginOptions(login_hint: userEmail),
      ));
    } catch (e) {
      log("Error during email/passwordless login: $e");
      // Handle the error as needed
      // You might want to show a user-friendly message or log the error
      return Future.error("Login failed");
    }
  }

  Future<TorusUserInfo> _getUserInfo() async {
    try {
      TorusUserInfo userInfo = await Web3AuthFlutter.getUserInfo();
      log(userInfo.toString());
      setState(() {
        _result = userInfo.toString();
      });
      return userInfo;
    } catch (e) {
      log("Error during email/passwordless login: $e");
      // Handle the error as needed
      // You might want to show a user-friendly message or log the error
      return Future.error("Login failed");
    }
  }

  Future<String> _getAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final privateKey = prefs.getString('privateKey') ?? '0';

    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address;
    log("Account, ${address.hexEip55}");
    setState(() {
      _result = address.hexEip55.toString();
    });
    return address.hexEip55;
  }

  Future<EtherAmount> _getBalance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final privateKey = prefs.getString('privateKey') ?? '0';

      final client = Web3Client(rpcUrl, Client());
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address;

      // Get the balance in wei
      final weiBalance = await client.getBalance(address);

      // Convert wei to ether
      final etherBalance = EtherAmount.fromBigInt(
        EtherUnit.ether,
        weiBalance.getInEther,
      );

      log(etherBalance.toString());

      setState(() {
        _result = etherBalance.toString();
      });

      return etherBalance;
    } catch (e) {
      // Handle errors as needed
      log("Error getting balance: $e");
      return EtherAmount.zero();
    }
  }

  Future<String> _sendTransaction() async {
    final prefs = await SharedPreferences.getInstance();
    final privateKey = prefs.getString('privateKey') ?? '0';

    final client = Web3Client(rpcUrl, Client());
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address;
    try {
      final receipt = await client.sendTransaction(
        credentials,
        Transaction(
          from: address,
          to: EthereumAddress.fromHex(
            '0xeaA8Af602b2eDE45922818AE5f9f7FdE50cFa1A8',
          ),
          // gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 100),
          value: EtherAmount.fromInt(
            EtherUnit.gwei,
            5000000,
          ), // 0.005 ETH
        ),
        chainId: 11155111,
      );
      log(receipt);
      setState(() {
        _result = receipt;
      });
      return receipt;
    } catch (e) {
      setState(() {
        _result = e.toString();
      });
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Visibility(
                    visible: !logoutVisible,
                    child: LoginScreen(
                      emailController: emailController,
                      loginFunction: () {
                        _login(
                          () => _withEmailPasswordless(emailController.text),
                        );
                      },
                    )),
                ElevatedButtonTheme(
                  data: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 195, 47, 233),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  child: Visibility(
                    visible: logoutVisible,
                    child: Column(
                      children: [
                        Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[600],
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _logout(),
                              child: const Column(
                                children: [
                                  Text('Logout'),
                                ],
                              )),
                        ),
                        const Text(
                          'Blockchain calls',
                          style: TextStyle(fontSize: 20),
                        ),
                        ElevatedButton(
                          onPressed: _getUserInfo,
                          child: const Text('Get UserInfo'),
                        ),
                        ElevatedButton(
                          onPressed: _getAddress,
                          child: const Text('Get Address'),
                        ),
                        ElevatedButton(
                          onPressed: _getBalance,
                          child: const Text('Get Balance'),
                        ),
                        ElevatedButton(
                          onPressed: _sendTransaction,
                          child: const Text('Send Transaction'),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_result),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
