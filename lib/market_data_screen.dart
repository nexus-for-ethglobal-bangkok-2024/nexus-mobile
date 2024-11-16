// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';

class MarketDataScreen extends StatelessWidget {
  const MarketDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(tabs: [
                  Tab(
                    child: Text(
                      'Crypto Market',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Stocks Market',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ]),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: TabBarView(children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView(
                          children: [
                            analyticWidget(
                                context,
                                "assets/images/btc.png",
                                "BitCoin",
                                90988,
                                1371.85,
                                "2024-11-16T13:37:39.183Z",
                                1,
                                1798307639057,
                                22011656204),
                            analyticWidget(
                                context,
                                "assets/images/ethereum.png",
                                "Ethereum",
                                3176.52,
                                87.02,
                                "2024-11-16T13:37:31.168Z",
                                2,
                                382684018639,
                                9704788533),
                            analyticWidget(
                                context,
                                "assets/images/tether.png",
                                "Tether",
                                0.999895,
                                0.00180225,
                                "2024-11-16T13:37:38.320Z",
                                3,
                                127360358833,
                                306186321)
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView(
                          children: [
                            stockAnalyticWidget(
                                context,
                                "A",
                                "Agilent Technologies Inc.",
                                "stocks",
                                "CS",
                                true,
                                "usd",
                                "2024-08-21T00:00:00Z"),
                            stockAnalyticWidget(
                                context,
                                "AA",
                                "Alcoa Corporation",
                                "stocks",
                                "CS",
                                true,
                                "usd",
                                "2024-11-14T00:00:00Z"),
                            stockAnalyticWidget(
                                context,
                                "AAA",
                                "Alternative Access First Priority CLO Bond ETF",
                                "stocks",
                                "ETF",
                                true,
                                "usd",
                                "2024-08-21T00:00:00Z"),
                          ],
                        )),
                  ]))
            ],
          ),
        ),
      )),
    );
  }

  Widget analyticWidget(
      BuildContext context,
      String cryptoImage,
      String name,
      double currentPrice,
      double priceChange,
      String lastUpdate,
      int rank,
      int cap,
      int capChange) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      cryptoImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.purple, Colors.blue, Colors.red])
                      .createShader(bounds),
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.black),
            width: double.infinity,
            child: Column(
              children: [
                infoWidget(
                    "Current Price : $currentPrice", "assets/images/usd.png"),
                const SizedBox(
                  height: 3,
                ),
                infoWidget("Price-Changes-24hr : $priceChange",
                    "assets/images/price.png"),
                const SizedBox(
                  height: 3,
                ),
                infoWidget(
                    "Last Update: $lastUpdate}", "assets/images/time.png"),
                const Divider(
                  height: 20,
                  thickness: 1,
                  endIndent: 8,
                  indent: 8,
                  color: Color.fromARGB(255, 78, 78, 78),
                ),
                infoWidget("Market Rank : ${rank}", "assets/images/rank.png"),
                const SizedBox(
                  height: 3,
                ),
                infoWidget("Capitalization : ${cap}", "assets/images/cap.png"),
                const SizedBox(
                  height: 3,
                ),
                infoWidget("Cap-Changes-24hr : ${capChange}",
                    "assets/images/trade.png"),
              ],
            ),
          )
        ],
      ),
    );
  }

  /*

  */

  Widget infoWidget(String title, String image) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, bottom: 2),
          width: 25,
          height: 25,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget stockAnalyticWidget(
      BuildContext context,
      String ticker,
      String name,
      String market,
      String type,
      bool active,
      String currencyName,
      String lastUpdate) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.purple, Colors.blue, Colors.red])
                        .createShader(bounds),
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.black),
            width: double.infinity,
            child: Column(
              children: [
                stockInfoWidget(
                    "Ticker : ${ticker}", "assets/images/trade.png"),
                const SizedBox(
                  height: 3,
                ),
                stockInfoWidget("Market : ${market}", "assets/images/rank.png"),
                const SizedBox(
                  height: 3,
                ),
                infoTextWidget("Type : ${type}"),
                const Divider(
                  height: 20,
                  thickness: 1,
                  endIndent: 8,
                  indent: 8,
                  color: Color.fromARGB(255, 78, 78, 78),
                ),
                infoTextWidget(
                  "Active : ${active}",
                ),
                const SizedBox(
                  height: 3,
                ),
                infoTextWidget(
                  "Currency Name : ${currencyName}",
                ),
                const SizedBox(
                  height: 3,
                ),
                stockInfoWidget(
                    "Last Update : ${lastUpdate}", "assets/images/time.png"),
              ],
            ),
          )
        ],
      ),
    );
  }

  /*

  */

  Widget stockInfoWidget(String title, String image) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, bottom: 2),
          width: 25,
          height: 25,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget infoTextWidget(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: Colors.white),
        ),
      ],
    );
  }
}
