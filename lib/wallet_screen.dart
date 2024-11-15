// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart';

import 'package:nexus_mobile/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';
import 'package:web3dart/web3dart.dart';

final _appController = Get.put(AppController());

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String walletBalance = "";

  String walletAddress = "";

  String userProfile = "";

  Future<void> _logout() async {
    try {
      _appController.logoutVisible.value = false;
      await Web3AuthFlutter.logout();
    } on UserCancelledException {
      log("User cancelled.");
    } on UnKnownException {
      log("Unknown exception occurred");
    }
  }

  Future<TorusUserInfo> _getUserInfo() async {
    try {
      TorusUserInfo userInfo = await Web3AuthFlutter.getUserInfo();
      log(userInfo.toString());
      setState(() {
        userProfile = userInfo.profileImage ?? "";
      });
      return userInfo;
    } catch (e) {
      log("Error during email/passwordless login: $e");
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
      walletAddress = address.hexEip55.toString();
    });
    return address.hexEip55;
  }

  Future<EtherAmount> _getBalance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final privateKey = prefs.getString('privateKey') ?? '0';

      final client = Web3Client("https://rpc.ankr.com/eth_sepolia", Client());
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address;

      final weiBalance = await client.getBalance(address);

      final etherBalance = EtherAmount.fromBigInt(
        EtherUnit.ether,
        weiBalance.getInEther,
      );

      log(etherBalance.toString());

      setState(() {
        walletBalance = etherBalance.toString();
      });

      return etherBalance;
    } catch (e) {
      log("Error getting balance: $e");
      return EtherAmount.zero();
    }
  }

  void _showPopupMenu(BuildContext context, TapDownDetails details) async {
    final position = details.globalPosition;

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx, // X-coordinate
        position.dy, // Y-coordinate
        MediaQuery.of(context).size.width - position.dx, // Distance from right
        MediaQuery.of(context).size.height -
            position.dy, // Distance from bottom
      ),
      items: [
        PopupMenuItem<String>(
          value: 'Logout',
          child: Text('Logout'),
        ),
        PopupMenuItem<String>(
          value: 'See More',
          child: Text('See More'),
        ),
      ],
      elevation: 8.0,
    );

    if (result != null) {
      if (result == "Logout") {
        _logout();
      }
    }
  }

  @override
  void initState() {
    _getAddress();
    _getBalance();
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: walletAddress.isEmpty || walletBalance.isEmpty
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            "assets/images/web3_auth.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        GestureDetector(
                          onTapDown: (details) =>
                              _showPopupMenu(context, details),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(userProfile),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/*

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

*/
