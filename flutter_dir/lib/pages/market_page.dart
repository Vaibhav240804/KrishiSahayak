import 'package:flutter/material.dart';
import 'package:krishi_sahayak/providers/providers.dart';
import 'package:krishi_sahayak/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MarketPlace extends StatefulWidget {
  const MarketPlace({super.key});

  @override
  State<MarketPlace> createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ModifiedCommodityPrices(),
    );
  }
}

class ModifiedCommodityPrices extends StatelessWidget {
  const ModifiedCommodityPrices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: FutureBuilder<void>(
          future: _fetchCommodityRecords(context),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error} '));
            } else {
              // Access the MarketProvider using Provider.of
              MarketProvider marketProvider =
                  Provider.of<MarketProvider>(context, listen: false);

              // Access the state-wise commodity records from the provider
              List<CommodityRecord> stateWiseRecords =
                  marketProvider.statewizeRecords;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Statewize prices of commodities',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.justify,
                  ),
                  const Divider(
                    height: 10,
                  ),
                  SizedBox(
                    height: 600,
                    width: double.maxFinite,
                    child: stateWiseRecords.isEmpty
                        ? const Center(
                            child: Text('No records found'),
                          )
                        : ListView.builder(
                            itemCount: stateWiseRecords.length > 7
                                ? stateWiseRecords.length
                                : stateWiseRecords.length,
                            itemBuilder: (BuildContext context, int index) {
                              CommodityRecord currentRecord =
                                  stateWiseRecords[index];
                              return ListTile(
                                style: ListTileStyle.list,
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        currentRecord.state,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ),
                                  ],
                                ),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentRecord.commodity,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                                subtitle: Text(currentRecord.market),
                                shape: const RoundedRectangleBorder(),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹ ${currentRecord.modalPrice.toString()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {},
                                horizontalTitleGap: 4,
                                minVerticalPadding: 4,
                              );
                            },
                          ),
                  ),
                ],
              );
            }
          }),
    );
  }

  Future<void> _fetchCommodityRecords(BuildContext context) async {
    // Access the MarketProvider using Provider.of
    MarketProvider marketProvider =
        Provider.of<MarketProvider>(context, listen: false);
    if (marketProvider.statewizeRecords.isEmpty) {
      try {
        await marketProvider.getCommodityRecords(
            Provider.of<UserProvider>(context).user!.state);
      } catch (e) {
        SnackBar(content: Text('Error fetching all commodity records: $e'));
      }
    }
  }
}
