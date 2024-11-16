// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  const WalletScreen({
    super.key,
  });

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

  Future<void> _transferTokens(String recipient, double amount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final privateKey = prefs.getString('privateKey') ?? '0';
      final web3Client =
          Web3Client("https://rpc.ankr.com/eth_sepolia", Client());
      final credentials = EthPrivateKey.fromHex(privateKey);

      final weiAmount = BigInt.from(amount * 1e18);

      final txHash = await web3Client.sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(recipient),
          value: EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount),
        ),
        chainId: 11155111,
      );
      print("Transaction successful: $txHash");
      await _getBalance();
    } catch (e) {
      print("Error transferring tokens: $e");
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

  Future<double> _getBalance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final privateKey = prefs.getString('privateKey') ?? '0';

      final client = Web3Client("https://rpc.ankr.com/eth_sepolia", Client());
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address;

      final weiBalance = await client.getBalance(address);

      final etherBalance = weiBalance.getValueInUnit(EtherUnit.ether);

      log("Balance: $etherBalance SepoliaETH");

      setState(() {
        walletBalance =
            "${etherBalance.toString().length > 6 ? etherBalance.toString().substring(0, 6) : etherBalance.toString()} SepoliaETH";
      });

      return etherBalance;
    } catch (e) {
      log("Error getting balance: $e");
      return 0.0;
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
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color.fromRGBO(43, 72, 123, 1),
                              Color.fromRGBO(46, 71, 111, 1),
                              Color.fromRGBO(48, 70, 103, 1),
                              Color.fromRGBO(49, 68, 101, 1),
                              Color.fromRGBO(51, 67, 96, 1),
                              Color.fromRGBO(53, 67, 87, 1),
                              Color.fromRGBO(53, 67, 87, 1),
                              Color.fromRGBO(53, 67, 87, 1),
                              Color.fromRGBO(48, 69, 103, 1),
                              Color.fromRGBO(43, 72, 119, 1),
                              Color.fromRGBO(39, 75, 133, 1),
                              Color.fromRGBO(36, 77, 143, 1),
                              Color.fromRGBO(35, 78, 147, 1),
                            ], // Gradient from https://learnui.design/tools/gradient-generator.html
                            tileMode: TileMode.mirror,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${walletAddress.substring(0, 7)}...${walletAddress.substring(37)}",
                                style: TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: walletAddress));
                                  },
                                  icon: Icon(
                                    Icons.copy_rounded,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                          Text(
                            walletBalance,
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    _transferTokens(
                                        "0x756f70d15C7dC0C4e50bB067FCa4038A7F417DD7",
                                        0.089999944525287);
                                  },
                                  child: button("Send", Icons.arrow_upward)),
                              button("Receive", Icons.arrow_downward),
                              button("Buy", Icons.add),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget button(String name, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 52, 119, 235),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
