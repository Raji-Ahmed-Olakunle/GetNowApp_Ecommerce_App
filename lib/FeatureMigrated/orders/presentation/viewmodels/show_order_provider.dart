import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowOrderNotifier extends StateNotifier<bool> {
  ShowOrderNotifier() : super(false);

  void toggleOrder() {
    state = !state;
  }
}

final showOrderProvider = StateNotifierProvider<ShowOrderNotifier, bool>((ref) => ShowOrderNotifier()); 