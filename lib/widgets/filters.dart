import 'package:myapp/widgets/results.dart';

class FilterState {
  int id;
  String key;
  bool order;
  int Function(ListItem, ListItem, bool) compare;

  FilterState(this.id, this.key, this.order, this.compare);
}

List<FilterState> filters = [
  FilterState(
      0,
      'Date',
      false,
      (a, b, order) => order == true
          ? a.start.compareTo(b.start)
          : b.start.compareTo(a.start)),
  FilterState(
      1,
      'Name',
      false,
      (a, b, order) => order == true
          ? a.title.compareTo(b.title)
          : b.title.compareTo(a.title)),
];
