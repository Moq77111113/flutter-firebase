import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/provider/stopwatch_service.dart';
import 'package:myapp/widgets/filters.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResultAppState();
}

class _ResultAppState extends State<Result> {
  void sortList(int id) {
    final filter = filters.firstWhere((element) => element.id == id,
        orElse: () => FilterState(
            1,
            'name',
            true,
            (a, b, order) => order == true
                ? a.title.compareTo(b.title)
                : b.title.compareTo(a.title)));
    filter.order = !filter.order;
    setState(() {
      final index = filters.indexWhere((element) => element.id == filter.id);
      if (index > -1) {
        filters[index] = filter;
        Provider.of<StopWatchService>(context, listen: false)
            .sort((a, b) => filter.compare(a, b, filter.order));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          buildSortBar(),
          Expanded(
            child: Consumer<StopWatchService>(
              builder: (context, stopWatchService, child) => Stack(children: [
                if (child != null) child,
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: stopWatchService.results.length,
                  itemBuilder: (context, index) {
                    final item = stopWatchService.results[index];
                    return ListTile(
                      hoverColor: Colors.grey.shade400,
                      leading: item.buildLeading(context, index),
                      title: item.buildTitle(context),
                      subtitle: item.buildSubTitle(context),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 16.0),
                      dense: true,
                    );
                  },
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSortBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        PopupMenuButton<int>(
          itemBuilder: (context) => filters
              .map((filter) => PopupMenuItem(
                    child: Text(filter.key),
                    value: filter.id,
                  ))
              .toList(),
          icon: const Icon(Icons.sort),
          onSelected: (id) => sortList(id),
        )
      ],
    );
  }
}

abstract class ListItem {
  String get id;
  String get title;
  DateTime get start;
  Widget buildLeading(BuildContext context, int index);
  Widget buildTitle(BuildContext context);
  Widget buildSubTitle(BuildContext context);
}

class ResultItem implements ListItem {
  @override
  final String id;
  @override
  final String title;
  @override
  final DateTime start;

  final DateTime end;

  final Duration duration;

  ResultItem(
      {String? id,
      String? title,
      required this.start,
      required this.end,
      required this.duration})
      : id = id ?? const Uuid().v1(),
        title = title ?? 'Run from ${DateFormat('dd.MM.yyyy').format(start)}';

  @override
  Widget buildLeading(BuildContext context, int index) => CircleAvatar(
        backgroundColor: Colors.blue,
        child: Center(
          child: Text(
            index.toString(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );

  @override
  Widget buildTitle(BuildContext context) => Text(
        title,
        style: const TextStyle(fontSize: 15.0),
      );

  @override
  Widget buildSubTitle(BuildContext context) => Text(
        '${DateFormat('dd.MM.yyyy H:mm:ss').format(start)}'
        ' - ${DateFormat('H:mm:ss').format(end)}'
        '\nDuration : ${duration.inHours}h${duration.inMinutes}mn${duration.inSeconds}s',
        style: const TextStyle(fontSize: 10.0),
      );
}
