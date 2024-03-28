import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/city.dart';

import 'package:weather_app/models/suggestions.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:weather_app/widgets/weather_card.dart';

const Duration debounceDuration = Duration(seconds: 1);

class AddCityScreen extends StatefulWidget {
  const AddCityScreen({super.key, required this.onRemove});

  final void Function(int) onRemove;

  @override
  State<AddCityScreen> createState() {
    return _AddCityScreenState();
  }
}

class _AddCityScreenState extends State<AddCityScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<String>> _listOfAddedCities;

  // The query currently being searched for. If null, there is no pending
  // request.
  String? _currentQuery;

  // The most recent suggestions received from the API.
  late Iterable<Widget> _lastOptions = <Widget>[];

  late final _Debounceable<Iterable<Suggestions>?, String> _debouncedSearch;

  Future<Iterable<Suggestions>> searchCity(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final url = Uri.https(
      'api.weatherapi.com',
      '/v1/search.json',
      {
        'key': '8e85ba92d52849f4b7385155232111',
        'q': query,
      },
    );

    final response = await http.get(url);
    final List<dynamic> options = jsonDecode(response.body);

    final Iterable<Suggestions> suggestions =
        options.map((suggestion) => Suggestions.fromJSON(suggestion));

    return suggestions;
  }

  // Calls the "remote" API to search with the given query. Returns null when
  // the call has been made obsolete.
  Future<Iterable<Suggestions>?> _search(String query) async {
    _currentQuery = query;

    // In a real application, there should be some error handling here.
    final Iterable<Suggestions> options = await searchCity(_currentQuery!);

    // If another search happened after this one, throw away these options.
    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    return options;
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch = _debounce<Iterable<Suggestions>?, String>(_search);
    _listOfAddedCities =
        _prefs.then((prefs) => prefs.getStringList('addedCities') ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage cities'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: SearchAnchor.bar(
                viewLeading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: theme.dividerColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                barLeading: const Icon(
                  Icons.search_outlined,
                  color: Colors.white38,
                ),
                barHintText: 'Search a city',
                barTextStyle: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.focused) ||
                      !states.contains(MaterialState.focused)) {
                    return const TextStyle(color: Colors.white, fontSize: 16);
                  }
                  return null;
                }),
                barHintStyle: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.focused) ||
                      !states.contains(MaterialState.focused)) {
                    return const TextStyle(color: Colors.white38, fontSize: 16);
                  }
                  return null;
                }),
                barPadding: MaterialStateProperty.all(
                    const EdgeInsets.only(left: 15, right: 15)),
                barBackgroundColor: MaterialStateProperty.all(Colors.white12),
                viewBackgroundColor: Colors.grey[900],
                viewHeaderTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 16),
                viewHeaderHintStyle:
                    const TextStyle(color: Colors.white38, fontSize: 16),
                suggestionsBuilder: (context, controller) async {
                  final List<Suggestions>? options =
                      (await _debouncedSearch(controller.text))?.toList();
                  if (options == null) {
                    return _lastOptions;
                  } else if (options.isEmpty) {
                    return [
                      ListTile(
                        title: Text(
                          'No results found',
                          style:
                              theme.textTheme.bodyLarge!.copyWith(fontSize: 16),
                        ),
                      ),
                    ];
                  }
                  _lastOptions = List<ListTile>.generate(
                    options.length,
                    (int index) {
                      final Suggestions item = options[index];
                      return ListTile(
                        title: Text(
                          '${item.name}, ${item.region} ${item.country}',
                          style:
                              theme.textTheme.bodyLarge!.copyWith(fontSize: 16),
                        ),
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => WeatherScreen(
                                queryParameter:
                                    '${item.latitude.toString()},${item.longitude.toString()}',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );

                  return _lastOptions;
                },
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: _listOfAddedCities,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final cities = snapshot.data!.map((city) => jsonDecode(city));

                return Column(
                  children: cities.toList().asMap().entries.map(
                    (city) {
                      final obj =
                          City.fromJSON(jsonDecode(city.value['weather']));
                      final cityIndex = city.key;
                      return Dismissible(
                        key: ValueKey(cityIndex),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    WeatherScreen(queryParameter: obj.name),
                              ));
                            },
                            child:
                                WeatherCard(city: obj, cityIndex: cityIndex)),
                        onDismissed: (direction) {
                          widget.onRemove(cityIndex);
                        },
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(debounceDuration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}
