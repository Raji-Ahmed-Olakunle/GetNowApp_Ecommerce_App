import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/categories_provider.dart';
// import 'package:getnowshopapp/Providers/categoriesProvider.dart';

class CategoryWidget extends ConsumerWidget {
  final int index;

  const CategoryWidget({required this.index});

  @override
  Widget build(BuildContext context, ref) {
    var AllCategory = ref.read(categoriesProvider).value;
    return Container(
      width: 100,
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: Card(
        // decoration: BoxDecoration(
        //   boxShadow: [
        //     BoxShadow(
        //       // color: Colors.black.withOpacity(0.5),
        //       blurRadius: 6,
        //       offset: Offset(0, 2),
        //       spreadRadius: 0,
        //     ),
        //   ],
        // ),
        elevation: 0.05,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Container(
                width: 70,
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.10),
                ),
                child: Image.asset(
                  AllCategory![index].imageUrl,
                  fit: BoxFit.scaleDown,
                  width: 30,
                  height: 30,
                ),
              ),
            ),

            Container(
              width: 150,

              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      AllCategory![index].title,
                      // style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
