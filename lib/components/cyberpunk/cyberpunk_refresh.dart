import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';

class CyberpunkRefresh extends StatefulWidget {
  const CyberpunkRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  State<CyberpunkRefresh> createState() => _CyberpunkRefreshState();
}

class _CyberpunkRefreshState extends State<CyberpunkRefresh> {
  final EasyRefreshController _controller = EasyRefreshController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      header: CyberpunkRefreshHeader(),
      controller: _controller,
      onRefresh: widget.onRefresh,
      child: widget.child,
    );
  }
}

class CyberpunkRefreshHeader extends Header {
  @override
  double get extent => 5.0;

  @override
  double get triggerDistance => 60.0;

  @override
  Duration get completeDuration => const Duration(milliseconds: 2000);

  @override
  bool get enableInfiniteRefresh => false;

  @override
  Widget contentBuilder(
    BuildContext context,
    RefreshMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
    AxisDirection axisDirection,
    bool float,
    Duration? completeDuration,
    bool enableInfiniteRefresh,
    bool success,
    bool noMore,
  ) {
    return CyberpunkGlitch(
      chance: 100,
      child: Container(
        alignment: Alignment.center,
        child: LinearProgressIndicator(),
      ),
    );
  }
}
