import 'package:flutter/material.dart';

import 'Barchart.dart';
import 'piechart.dart';

class GraphicalDetail extends StatelessWidget {
  final Map<String, double> salesDetail;
  final Map<String, double> starDetail;

  const GraphicalDetail({
    required this.salesDetail,
    required this.starDetail,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          salesDetail.isNotEmpty && (starDetail['sum'] ?? 0) != 0
              ? MediaQuery.of(context).size.height * 0.7
              : MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          if (salesDetail.isNotEmpty)
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "Sale Per Day Bar Chart",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Expanded(
                    flex: 2,
                    child: saleBarChart(saleDetail: salesDetail),
                  ),
                ],
              ),
            ),
          const Divider(),
          if ((starDetail['sum'] ?? 0) != 0)
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "Star Review Rating ",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Expanded(
                    flex: 2,
                    child: StarPieChart(starDetail: starDetail),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
