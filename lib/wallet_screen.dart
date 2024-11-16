// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';

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
  bool isTokenOnTap = true;
  String walletBalance = "";
  String walletAddress = "";

  String userProfile = "";

  Future<void> _logout() async {
    try {
      _appController.authState.value = "LoggedOut";
      await Web3AuthFlutter.logout();
    } on UserCancelledException {
      log("User cancelled.");
    } on UnKnownException {
      log("Unknown exception occurred");
    }
  }

  Future<void> launchWallet() async {
    List<dynamic> params = [];
    // Message to be signed
    params.add("Hello, Web3Auth from Flutter!");
    // User's EOA address
    params.add(walletAddress);
    try {
      await Web3AuthFlutter.launchWalletServices(
        ChainConfig(
          chainId: "0x1",
          rpcTarget: "https://rpc.ankr.com/eth_sepolia",
        ),
      );

      await Web3AuthFlutter.request(
        ChainConfig(
          chainId: "0x1",
          rpcTarget: "https://rpc.ankr.com/eth_sepolia",
        ),
        "personal_sign",
        params,
      );

      final signResponse = await Web3AuthFlutter.getSignResponse();
      log("$signResponse");
    } on UserCancelledException {
      log("User cancelled.");
    } catch (e) {
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

  @override
  void initState() {
    _getAddress();

    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: walletAddress.isEmpty
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
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                userProfile,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
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
                              ],
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
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      await launchWallet();
                                    },
                                    child:
                                        button("Launch Wallet", Icons.wallet)),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      await _logout();
                                    },
                                    child: button("Logout", Icons.logout)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
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
          ),
        ],
      ),
    );
  }
}
