import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
} 

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange), 
        ),
        home: MyHomePage(), 
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {                                   
  var current = WordPair.random(); 

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];                                             
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
  Widget build(BuildContext context) {                                    
    
    return Scaffold(                                                     
      body: Row(                                                                 //  new MyHomePage contains a Row with two children
        children: [
          SafeArea(                                                              // The SafeArea ensures that its child is not obscured by a hardware notch or a status bar. In this app, the widget wraps around NavigationRail to prevent the navigation buttons from being obscured by a mobile status bar, for example
            child: NavigationRail(
              extended: false,                                                   // change the extended false line in NavigationRail to true shows the labels next to the icons. This is possible to do automatically when the app has enough horizontal space
              destinations: [
                NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
                ),
                NavigationRailDestination(
                icon: Icon(Icons.favorite),
                label: Text('Favorites'),
                ),
              ],
              selectedIndex: 0,                                                 //  A selected index of zero selects the first destination of the navigation rail, a selected index of one selects the second destination, and so on. For now, it's hard coded to zero.
              onDestinationSelected: (value) {                                  // The navigation rail also defines what happens when the user selects one of the destinations with onDestinationSelected. Right now, the app merely outputs the requested index value with print()
              print('selected: $value');
              },
            ),
          ),
          Expanded(                                                             // Expanded widgets are extremely useful in rows and columns—they let you express layouts where some children take only as much space as they need (SafeArea, in this case) and other widgets should take as much of the remaining room as possible (Expanded, in this case). Two Expanded widgets split all the available horizontal space between themselves, even though the navigation rail only really needed a little slice on the left.
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: GeneratorPage(),
            )
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {                                     // all from MyHomePage exapt Scaffold widget 
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();                          
    var pair = appState.current;                                          

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;                                              
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(                                                    
                                                                        
        mainAxisAlignment: MainAxisAlignment.center,
        children: [                    
          BigCard(pair: pair),                                          
          SizedBox(height: 20),
          Row(                                                          
            mainAxisSize: MainAxisSize.min,                             
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
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],                                        
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
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,                                                              
    );

    return Card(
      color: theme.colorScheme.primary,              
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
          ),
      ),
    );
  }
}