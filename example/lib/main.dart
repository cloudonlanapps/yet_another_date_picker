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
          title: const DateSelected(),
        ),
        body: Stack(
          children: [
            Center(
              child: ListView(
                children: [
                  const DateSelectorWrapper(),
                  Padding(
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
                              text: "* Can't have both day and year empty\n"),
                        ])),
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
  "JAN",
  "FEB",
  "MAR",
  "APR",
  "MAY",
  "JUN",
  "JUL",
  "AUG",
  "SEP",
  "OCT",
  "NOV",
  "DEC",
];

class DateSelected extends ConsumerWidget {
  const DateSelected({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ddmmyyyy = ref.watch(ddmmyyyyProvider);

    final day = (ddmmyyyy.dd == null)
        ? "Any day in "
        : "${ddmmyyyy.dd!.toString().padLeft(2, '0')} - ";
    final month = monthsOfTheYear[ddmmyyyy.mm];
    final year =
        (ddmmyyyy.yyyy == null) ? " of Any year" : " - ${ddmmyyyy.yyyy}";

    return Text(" Date Selected: $day$month$year");
  }
}

class DateSelectorWrapper extends ConsumerStatefulWidget {
  const DateSelectorWrapper({
    super.key,
  });

  @override
  ConsumerState<DateSelectorWrapper> createState() =>
      _DateSelectorWrapperState();
}

class _DateSelectorWrapperState extends ConsumerState<DateSelectorWrapper> {
  late final DateTime initialDate;
  final startYear = 1970;
  final futureYears = 0;
  late final List<int> years;
  late DDMMYYYY currentDate;

  @override
  void initState() {
    initialDate = DateTime.now();
    currentDate = DDMMYYYY.fromDateTime(initialDate);
    years = List.generate(DateTime.now().year - startYear + 1 + futureYears,
        (index) => startYear + index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DateSelector(
      years: years,
      date: currentDate,
      width: MediaQuery.of(context).size.width * .5,
      height: MediaQuery.of(context).size.height * 0.6,
      itemExtend: 40,
      onDateChanged: (ddmmyyyy) async {
        currentDate = ddmmyyyy;
        setState(() {});
        ref.read(ddmmyyyyProvider.notifier).state = ddmmyyyy;
      },
      onReset: () {
        currentDate = DDMMYYYY.fromDateTime(initialDate);
        setState(() {});
      },
    );
  }
}

final ddmmyyyyProvider = StateProvider<DDMMYYYY>((ref) {
  final initialDate = DateTime.now();
  return DDMMYYYY.fromDateTime(initialDate);
});
