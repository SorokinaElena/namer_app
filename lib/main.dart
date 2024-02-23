import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
} 

// Widgets are the elements from which consists every Flutter app. Even the app itself is a widget.
// MyApp sets up the whole app. It creates the app-wide state, names the app, defines the visual theme, and sets the "home" widget—the starting point of your app:
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange), // hand-picked colors or Color.fromRGBO(0, 255, 0, 1.0) or Color(0xFF00FF00)
        ),
        home: MyHomePage(), // home widget
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {                                   // The state is created and provided to the whole app using a ChangeNotifierProvider. ChangeNotifier can notify others about its own changes. For example, if the current word pair changes, some widgets in the app need to know 
  var current = WordPair.random(); 

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];                                             // specified that the list can only ever contain word pairs: <WordPair>[], using generics

  void toggleFavorite() {
    if(favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {                                    // Every widget defines a build() method that's automatically called every time the widget's  circumstances change so that the widget is always up to date
    var appState = context.watch<MyAppState>();                           // MyHomePage tracks changes to the app's current state using the watch method
    var pair = appState.current;                                          // Flutter provides a refactoring helper for extracting widgets but before use it, make sure that the line being extracted only accesses what it needs

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;                                              // https://fonts.google.com/icons?selected=Material+Symbols+Outlined:favorite:FILL@0;wght@400;GRAD@0;opsz@24
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(                                                      // Every build method must return a widget or (more typically) a nested tree of widgets. In this case, the top-level widget is Scaffold
      body: Center(
        child: Column(                                                    // Column is one of the most basic layout widgets in Flutter. It takes any number of children and puts them in a column from top to bottom. By default, the column visually places its children at the top
                                                                          // Column, call up the Refactor menu and select Wrap with Center
          mainAxisAlignment: MainAxisAlignment.center,                    // Center the UI, vertical - This centers the children inside the Column along its main (vertical) axis
          children: [
            // Text('A random AWESOME idea:'),
            // Text(appState.current.asLowerCase),                        // Text widget takes appState, and accesses the only member of that class, current (which is a WordPair). WordPair provides several helpful getters, such as asPascalCase or asSnakeCase. To make a design - extract this line into a separate widget
            // Text(pair.asLowerCase),                                    // call up the Refactor menu - mouse or Ctrl+, In the Refactor menu, select Extract Widget. Assign a name, such as BigCard, and click Enter
            // SizedBox(height: 10),
            BigCard(pair: pair),                                          // Extract widget
            SizedBox(height: 20),
            Row(                                                          // The Row widget is the horizontal equivalent of Column -> Refactor menu -> Wrap with Row
              mainAxisSize: MainAxisSize.min,                             // mainAxisSize. This tells Row not to take all available horizontal space
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  }, 
                  icon: Icon(icon), 
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // print('button pressed!');
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],                                        // Trailing comma between a few children
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    // return Text(pair.asLowerCase);                // Refactor - wrap with Padding - This creates a new parent widget around the Text widget called Padding
    // 
    // return Padding(                               // Wrap with widget - This allows to specify the parent widget ("Card") 
    //   padding: const EdgeInsets.all(20.0),
    //   child: Text(pair.asLowerCase),
    // );

    final theme = Theme.of(context);                 // the code requests the app's current theme with Theme.of(context), https://m3.material.io/styles/color/choosing-a-scheme
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,            // size of a text. By using theme.textTheme, you access the app's font theme. This class includes members such as bodyMedium (for standard text of medium size), caption (for captions of images), or headlineLarge (for large headlines)
                                                     // Calling copyWith() on displayMedium returns a copy of the text style with the changes you define. In this case, you're only changing the text's color
                                                     // To get the new color, you once again access the app's theme. The color scheme's onPrimary property defines a color that is a good fit for use on the app's primary color
                                                     // To get the full list of properties Ctrl+Shift+Space   
                                                     // there's also .secondary, .surface, and a myriad of others. All of these colors have their onPrimary equivalents                                      
                                                     // https://m3.material.io/styles/color/roles
                                                     // https://codelabs.developers.google.com/codelabs/flutter-codelab-first#4
    );

    return Card(
      color: theme.colorScheme.primary,              // The card is now painted with the app's primary color
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        // child: Text(pair.asLowerCase),
        // child: Text(pair.asLowerCase, style: style), // size of a text
        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
          ),  // Improve accessibility
      ),
    );
  }
}