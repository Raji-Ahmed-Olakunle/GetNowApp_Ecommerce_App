import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../categories/presentation/viewmodels/categories_provider.dart';

class CategoryItem extends ConsumerWidget {
  final int index;

  const CategoryItem({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCategories = ref.watch(categoriesProvider);
    final category = allCategories.value?[index];
    return Container(
      width: 100,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: Card(
        elevation: 0.05,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Container(
                width: 70,
                height: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.grey.withOpacity(0.10),
                ),
                child: Image.asset(
                  category!.imageUrl,
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
                    child: Text(category.title, textAlign: TextAlign.center),
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
