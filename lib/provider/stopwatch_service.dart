import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:myapp/widgets/results.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TimerStatus { stopped, started, paused }

class StopWatchService extends ChangeNotifier {
  Stopwatch _watch = Stopwatch();
  Timer? _timer;

  DateTime? startDate;
  DateTime? endDate;

  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;

  final List<ResultItem> _results = [];
  UnmodifiableListView<ResultItem> get results =>
      UnmodifiableListView(_results);

  TimerStatus get timerStatus => _timer != null
      ? _timer!.isActive
          ? TimerStatus.started
          : TimerStatus.paused
      : TimerStatus.stopped;

  CollectionReference resultCollection =
      FirebaseFirestore.instance.collection('results');

  StopWatchService() {
    _watch = Stopwatch();
  }

  void _onTick(Timer timer) {
    _currentDuration = _watch.elapsed;
    notifyListeners();
  }

  void start() {
    if (_timer == null || _timer?.isActive == false) {
      _timer = Timer.periodic(const Duration(milliseconds: 150), _onTick);
      _watch.start();
      startDate = DateTime.now();
      notifyListeners();
    }
  }

  void stop() {
    if (_timer != null) {
      _timer!.cancel();
    }
    endDate = DateTime.now();
    _watch.stop();
    _currentDuration = _watch.elapsed;
    notifyListeners();
  }

  void reset() {
    stop();
    _timer = null;
    _watch.reset();
    add(ResultItem(
        start: startDate ?? DateTime.now(),
        end: endDate ?? DateTime.now(),
        duration: _currentDuration));
    _currentDuration = Duration.zero;
    notifyListeners();
  }

  void add(ResultItem resultItem) {
    _results.add(resultItem);
    addResult(resultItem);
    notifyListeners();
  }

  void remove(ResultItem resultItem) {
    if (_results.contains(resultItem) == true) {
      _results.remove(resultItem);
    }
    notifyListeners();
  }

  void clear() {
    _results.clear();
    notifyListeners();
  }

  void sort([int Function(ResultItem, ResultItem)? compare]) {
    _results.sort(compare);
    notifyListeners();
  }

  Future<void> addResult(ResultItem item) {
    return resultCollection
        .add({
          'id': item.id,
          'start': item.start,
          'end': item.end,
          'title': item.title
        })
        .then((r) => print('Yay $r'))
        .catchError((err) => print('Error $err'));
  }
}
