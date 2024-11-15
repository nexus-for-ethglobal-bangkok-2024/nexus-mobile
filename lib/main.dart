import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_mobile/controller.dart';
import 'package:nexus_mobile/login_screen.dart';
import 'package:nexus_mobile/navigator_screen.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _appController = Get.put(AppController());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String rpcUrl = 'https://rpc.ankr.com/eth_sepolia';

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
    if (state == AppLifecycleState.resumed) {
      Web3AuthFlutter.setCustomTabsClosed();
    }
  }

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
      _appController.logoutVisible.value = true;
    }
  }

  Future<Web3AuthResponse> _loginWithGoogle() async {
    try {
      return await Web3AuthFlutter.login(LoginParams(
        loginProvider: Provider.google,
      ));
    } catch (e) {
      return Future.error("Login failed");
    }
  }

  Future<Web3AuthResponse> _loginWithDiscord() async {
    try {
      return await Web3AuthFlutter.login(LoginParams(
        loginProvider: Provider.discord,
      ));
    } catch (e) {
      return Future.error("Login failed");
    }
  }

  Future<Web3AuthResponse> _loginWithGitHub() async {
    try {
      return await Web3AuthFlutter.login(LoginParams(
        loginProvider: Provider.github,
      ));
    } catch (e) {
      return Future.error("Login failed");
    }
  }

  Future<void> _login(Future<Web3AuthResponse> Function() method) async {
    try {
      final Web3AuthResponse response = await method();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('privateKey', response.privKey.toString());
    } on UserCancelledException {
      log("User cancelled.");
    } on UnKnownException {
      log("Unknown exception occurred");
    }
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

      return receipt;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Obx(
          () => Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                      visible: !_appController.logoutVisible.value,
                      child: LoginScreen(
                        loginWithGithub: () {
                          _login(
                            () => _loginWithGitHub(),
                          );
                        },
                        loginWithDiscord: () {
                          _login(
                            () => _loginWithDiscord(),
                          );
                        },
                        loginWithGoogle: () {
                          _login(
                            () => _loginWithGoogle(),
                          );
                        },
                        emailController: emailController,
                        loginFunction: () {
                          _login(
                            () => _withEmailPasswordless(emailController.text),
                          );
                        },
                      )),
                  Visibility(
                    visible: _appController.logoutVisible.value,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 1,
                        child: NavigatorScreen()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
