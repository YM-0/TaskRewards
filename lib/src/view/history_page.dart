import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:management/src/store/history_store.dart';
import 'package:table_calendar/table_calendar.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  // ストアクラス
  final HistoryStore _historyStore = HistoryStore();

  // 日付に印をつける
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    Future(() async {
      await _historyStore.get();
      if (mounted) {
        setState(() {});
      }
    });
  }

  // カレンダーのイベント数を数字で表示
  Widget _buildEventsMarker(DateTime day, List events) {
    return Positioned(
      right: 5,
      bottom: 5,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red[300],
        ),
        width: 16.0,
        height: 16.0,
        child: Center(
          child: Text(
            '${events.length}',
            style: const TextStyle().copyWith(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: _historyStore.getHashCode,
    )..addAll(_historyStore.eventsList);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("DataPage"),
        ),
        body: Column(
          // カレンダー表示
          children: [
            TableCalendar(
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    return _buildEventsMarker(day, events);
                  }
                  return null;
                },
              ),
              headerStyle: const HeaderStyle(formatButtonVisible: false),
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              eventLoader: _getEventForDay,
              selectedDayPredicate: ((day) {
                return isSameDay(_selectedDay, day);
              }),
              // 日付フォーカス変更
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _getEventForDay(selectedDay);
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            Flexible(
                child: ListView(
              shrinkWrap: true,
              children: _getEventForDay(_selectedDay!).map((event) {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    // ID
                    //leading: Text(item.id.toString()),
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(event.color),
                      ),
                      width: 25,
                    ),
                    // 名前
                    title: Text(
                      event.name,
                    ),
                    subtitle: Text(
                      event.model,
                    ),
                    // ポイント
                    trailing: Wrap(children: [
                      Text(
                        event.point.toString() + " P",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      //Icon(Icons.more_vert),
                    ]),
                  ),
                );
              }).toList(),
            ))
          ],
        ));
  }
}
