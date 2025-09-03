import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/Throttle.dart';
import '../../viewmodels/products_provider.dart';

class Heart extends ConsumerStatefulWidget {
  final int index;

  const Heart({required this.index, Key? key}) : super(key: key);

  @override
  ConsumerState<Heart> createState() => _HeartState();
}

class _HeartState extends ConsumerState<Heart>
    with SingleTickerProviderStateMixin {
  late Throttle throttle;
  AnimationController? _controller;
  Animation? _colorAnimation;
  Animation? _sizedAnimation;

  bool _isUpdating = false;

  @override
  void initState() {
    throttle = Throttle(const Duration(milliseconds: 300));

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.red,
    ).animate(_controller!);
    _sizedAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 20.0, end: 30.0),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 30.0, end: 20.0),
        weight: 50,
      ),
    ]).animate(_controller!);
    // _controller?.addListener(() {
    //   setState(() {});
    // });
    // _controller?.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     setState(() {
    //       _isFavourite = true;
    //     });
    //   } else if (status == AnimationStatus.dismissed) {
    //     setState(() {
    //       _isFavourite = false;
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync animation with current state when widget rebuilds
    final asyncProduct = ref.read(productsProvider(false)).value;
    if (asyncProduct != null) {
      final isFavourite = asyncProduct[widget.index].isFavourite;
      if (isFavourite && _controller!.value == 0) {
        _controller!.value = 1.0; // Set to favorite state
      } else if (!isFavourite && _controller!.value == 1.0) {
        _controller!.value = 0.0; // Set to non-favorite state
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    throttle.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, _) {
        return IconButton(
          onPressed: () async {
            if (_isUpdating) return; // Prevent multiple simultaneous updates

            final asyncProduct = ref.read(productsProvider(false)).value;
            if (asyncProduct == null) return;

            setState(() {
              _isUpdating = true;
            });
            if (asyncProduct![widget.index].isFavourite) {
              _controller!.reverse();
            } else {
              _controller!.forward();
            }

            throttle.call(() async {
              await ref
                  .read(productsProvider(false).notifier)
                  .toggleFavoriteStatus(
                    asyncProduct![widget.index].id,
                    asyncProduct![widget.index].isFavourite,
                  );
            });

            // await ref.refresh(productsProvider(false));
          },
          icon: Icon(
            Icons.favorite_border,
            color: _colorAnimation!.value,
            size: _sizedAnimation!.value,
          ),
        );
      },
    );
  }
}
