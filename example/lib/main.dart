import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yet_another_date_picker/yet_another_date_picker.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Date Picker Example'),
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyMedium!,
                      child: const DateSelected()),
                  const SizedBox(height: 20),
                  const DateSelectorWrapper(),
                  const SizedBox(height: 20),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text.rich(TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge!,
                            children: [
                              TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                  text: "Select date\n"),
                              const TextSpan(
                                text: "(from the years provided)\n",
                              ),
                              const TextSpan(
                                  text:
                                      "* If the day is any, it selects a month\n"),
                              const TextSpan(
                                  text: "* If the year is null, it represents "
                                      "the specific day from any year\n"),
                              const TextSpan(
                                  text:
                                      "* Can't have both day and year empty\n"),
                            ])),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> monthsOfTheYear = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

class DateSelected extends ConsumerWidget {
  const DateSelected({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ddmmyyyy = ref.watch(ddmmyyyyProvider);

    final day = (ddmmyyyy.dd == null) ? "" : "${ddmmyyyy.dd} - ";
    final month = monthsOfTheYear[ddmmyyyy.mm];
    final year = (ddmmyyyy.yyyy == null) ? "" : " - ${ddmmyyyy.yyyy}";

    return Text("$day$month$year");
  }
}

class DateSelectorWrapper extends ConsumerWidget {
  const DateSelectorWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DateSelector(
      years: List.generate(47, (index) => 1977 + index),
      initialDate: DDMMYYYY.fromDateTime(DateTime.now()),
      onDateChanged: (ddmmyyyy) async {
        ref.read(ddmmyyyyProvider.notifier).state = ddmmyyyy;
      },
    );
  }
}

final ddmmyyyyProvider = StateProvider<DDMMYYYY>((ref) {
  return DDMMYYYY(
    dd: DateTime.now().day,
    mm: DateTime.now().month - 1,
    yyyy: DateTime.now().year,
  );
});
