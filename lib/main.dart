import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WaterTrackerPage(),
    );
  }
}

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({super.key});

  @override
  _WaterTrackerPageState createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  List<int> waterIntake = [];
  int dailyGoal = 2000; // в миллилитрах
  final TextEditingController goalController = TextEditingController();

  int get totalIntake => waterIntake.fold(0, (sum, item) => sum + item);

  double get progress => totalIntake / dailyGoal;

  void addWater(int amount) {
    setState(() {
      waterIntake.add(amount);
    });
  }

  void removeLast() {
    if (waterIntake.isNotEmpty) {
      setState(() {
        waterIntake.removeLast();
      });
    }
  }

  void updateGoal() {
    final input = int.tryParse(goalController.text);
    if (input != null && input > 0) {
      setState(() {
        dailyGoal = input;
        waterIntake.clear(); // можно сбросить прогресс при смене цели
      });
    }
  }

  String get statusMessage {
    if (progress >= 1.0) {
      return "🎉 Отлично! Вы достигли цели!";
    } else if (progress < 0.5) {
      return "💧 Пейте больше воды!";
    } else {
      return "Продолжайте в том же духе!";
    }
  }

  @override
  void dispose() {
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Счётчик воды'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Цель: ${dailyGoal} мл',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress > 1.0 ? 1.0 : progress,
              minHeight: 20,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0 ? Colors.green : Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Вы выпили: $totalIntake / $dailyGoal мл',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              statusMessage,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => addWater(200),
                  child: const Text('Добавить 200 мл'),
                ),
                ElevatedButton(
                  onPressed: () => addWater(500),
                  child: const Text('Добавить 500 мл'),
                ),
                ElevatedButton(
                  onPressed: removeLast,
                  child: const Text('Удалить последний'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'История:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: waterIntake.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${waterIntake[index]} мл'),
                  );
                },
              ),
            ),
            const Divider(),
            const Text(
              'Настройка дневной цели:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: goalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Введите цель в мл',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: updateGoal,
                  child: const Text('Сохранить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
