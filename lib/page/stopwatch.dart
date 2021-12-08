import 'package:flutter/material.dart';
import 'package:myapp/provider/notifications_service.dart';
import 'package:myapp/provider/stopwatch_service.dart';
import 'package:provider/provider.dart';

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({Key? key}) : super(key: key);

  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  @override
  Widget build(BuildContext context) {
    final stopWatchService = Provider.of<StopWatchService>(context);
    final notifService =
        Provider.of<NotificationService>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedBuilder(
        animation: stopWatchService,
        builder: (context, child) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTime(stopWatchService.currentDuration),
                  const SizedBox(
                    height: 80,
                  ),
                  buildButtons(stopWatchService, notifService),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTime(Duration elapsed) {
    String xDigits(int n, {int digits = 2}) =>
        n.toString().padLeft(digits, '0');
    final hours = xDigits(elapsed.inHours);
    final minutes = xDigits(elapsed.inMinutes.remainder(60));
    final seconds = xDigits(elapsed.inSeconds.remainder(60));
    final ms = xDigits(elapsed.inMilliseconds.remainder(1000), digits: 3);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours, header: 'HOURS'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: minutes, header: 'MINUTES'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: seconds, header: 'SECONDS'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: ms, header: 'MS'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(header, style: const TextStyle(color: Colors.white60)),
        ],
      );

  Widget buildButtons(StopWatchService timer, NotificationService notif) {
    List<Widget> buttons = [];
    switch (timer.timerStatus) {
      case TimerStatus.stopped:
        {
          buttons.add(startButton(() {
            timer.start();
            notif.instantNotif(Notifications.stopwatchStarted);
          }));
          buttons.add(const SizedBox(width: 12));
          break;
        }
      case TimerStatus.started:
        {
          buttons.add(stopButton(timer.stop));
          buttons.add(const SizedBox(width: 12));
          buttons.add(resetButton(timer.reset));
          break;
        }
      case TimerStatus.paused:
        {
          buttons.add(startButton(timer.start));
          buttons.add(const SizedBox(width: 12));
          buttons.add(resetButton(() {
            notif.instantNotif(Notifications.stopwatchEnded,
                extendedContext:
                    '\nDuration : ${timer.currentDuration.toString()}');
            timer.reset();
          }));

          break;
        }
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: [...buttons]);
  }

  IconButton stopButton(void Function() stop) {
    return IconButton(
      icon: const Icon(Icons.stop),
      onPressed: () => stop(),
    );
  }

  Widget startButton(void Function() start) {
    return IconButton(
      icon: const Icon(Icons.play_arrow_rounded),
      onPressed: () => start(),
    );
  }

  Widget resetButton(void Function() reset) {
    return IconButton(
      icon: const Icon(Icons.replay),
      onPressed: () => reset(),
    );
  }
}
