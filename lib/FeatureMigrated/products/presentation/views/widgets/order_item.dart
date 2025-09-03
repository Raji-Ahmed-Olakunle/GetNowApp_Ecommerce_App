import 'package:expandable_datatable/expandable_datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderItem extends ConsumerWidget {
  final List<dynamic> orderData;
  final int index;

  const OrderItem(this.orderData, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = orderData[index];
    List<ExpandableColumn<dynamic>> headers = [
      ExpandableColumn<int>(columnTitle: "No.", columnFlex: 1),
      ExpandableColumn<String>(columnTitle: "Title", columnFlex: 2),
      ExpandableColumn<double>(columnTitle: "Qty", columnFlex: 1),
      ExpandableColumn<double>(columnTitle: "Price", columnFlex: 2),
      ExpandableColumn<String>(columnTitle: "Total", columnFlex: 2),
      ExpandableColumn<String>(columnTitle: "Status", columnFlex: 2),
    ];
    int counter = 0;
    List<ExpandableRow> rows =
        orders.orderProducts.map<ExpandableRow>((e) {
          counter++;
          return ExpandableRow(
            cells: [
              ExpandableCell<int>(columnTitle: "No.", value: counter),
              ExpandableCell<String>(columnTitle: "Title", value: e.title),
              ExpandableCell<double>(columnTitle: "Qty", value: e.quantity),
              ExpandableCell<double>(columnTitle: "Price", value: e.price),
              ExpandableCell<double>(
                columnTitle: "Total",
                value: e.price * e.quantity,
              ),
              ExpandableCell<String>(columnTitle: "Status", value: "Progress"),
            ],
          );
        }).toList();
    bool showOrder = false;
    return Column(
      children: [
        ListTile(
          title: Text(orders.amount.toString()),
          subtitle: Text(
            DateFormat('dd/MM/yyyy hh:mm').format(orders.dateTime),
          ),
          trailing: IconButton(
            onPressed: () {
              showOrder = !showOrder;
            },
            icon: Icon(
              showOrder ? Icons.expand_more : Icons.expand_less,
              color: Colors.blue,
            ),
          ),
        ),
        if (showOrder)
          Container(
            height: 300,
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            child: ExpandableTheme(
              data: ExpandableThemeData(
                context,
                headerTextMaxLines: 1,
                headerTextStyle: TextStyle(),
                rowBorder: BorderSide(color: Colors.grey),
                expandedBorderColor: Colors.transparent,
              ),
              child: ExpandableDataTable(
                isEditable: false,
                rows: rows,
                headers: headers,
                visibleColumnCount: 6,
              ),
            ),
          ),
      ],
    );
  }
}
