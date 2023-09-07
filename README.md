
One of my requirement was to search the database for the given month, or a specific day for every year or specific date. I couldn't find a date picker that support all these scenaris without additional widgets, as all of them refer date as DateTime Module, hence couldn't select a day without year or month without date. 

Thats the reason, I wrote this package. 

## Features

A date picker to select date with few additional options
1. Select Month  without specific date
2. Select a day (Day + Month) without year
3. selection only from the years provided in the list.

There is an option to select 'any' for both day and year, and a new object DDMMYYYY for representing the date in which either day or year can be null.

Month is represented by number indexed from 0 ('zero') so that we can directly index.
As the years are provided in a list, instead of range, it is possible to skip the years that are not required.

## Getting started / usage

1. Add the package to your `pubspec.yaml` file:

  ```
   flutter pub add yet_another_date_picker
  ```

2. Add riverpod

  ```
   flutter pub add flutter_riverpod
  ```

3. Wrap the entire application in a "ProviderScope" widget.
  ```dart
  void main() {
    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  }
  ```
4. Import the package 
   ```dart
   import 'package:yet_another_date_picker/yet_another_date_picker.dart';
  ```

5. Use the Widget
  ```dart
    DateSelector(
        years: List.generate(24, (index) => 2000 + index),
        initialDate: DDMMYYYY(
        dd: DateTime.now().day,
        mm: DateTime.now().month,
        yyyy: DateTime.now().year,
        ),
        onDateChanged: (ddmmyyyy) async {
        print(ddmmyyyy);
        },
    )
    ```

## Additional information

## Planned enhancements
- [X] Have an option to move back to initial date
- [X] Provide an option to select from table when tapping on the wheel
~~- [ ] Provide a standard calander interface~~ Not required
- [X] Support weekday when year and day are present
      - Added DDMMYYYY.toDateTime, when it is not null, the weekday can be obtained from the package `intl` `DateFormat('EEEE').format(date);`
- [ ] Allow UI to disable either day or year.
- [ ] Option to set, heigth and width from outside.
