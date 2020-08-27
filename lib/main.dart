import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData( //Tema do app
        primaryColor: Colors.lightBlue,
      ),
      home: RandomWords(), //Define a primeira parte que será exibida
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();  //controi widget pela classe RandomWordsState
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);
  final WordPair wordPair = WordPair.random();

  @override
  Widget build(BuildContext context) {
    void _pushSaved() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            final Iterable<ListTile> tiles = _saved.map( //item de lista
                  (WordPair pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );

              },
            );
            final List<Widget> divided = ListTile.divideTiles( //Configura a borda de cada item da lista
              context: context,
              tiles: tiles,
            ).toList();

            return Scaffold(
              appBar: AppBar(
                title: Text('Saved Suggestions'), //Titulo da tela de nomes salvos
              ),
              body: ListView(children: divided), //Exibe uma lista com os nomes
            );

          },
        ),
      );
    }
    return Scaffold( //Scaffold deixa cada elemento em um andar para não se sobrepor
      appBar: AppBar( //Define a barra do app
        title: Text('Infinit List'), //Texto que aparece na no Barra da tela
        actions: <Widget>[ //Avisa que aqui dentro tem Widgets
          IconButton(
              icon: Icon(Icons.list),  //seleciona o icone já existente
              onPressed: _pushSaved //controla a ação de toque no icone
          ),
        ],
      ),
      body: _buildSuggestions(), //corpo do app
    );
  }

  Widget _buildRow(WordPair pair) { //Configura o que vai aparecer em cada linha
    final bool alreadySaved = _saved.contains(pair);
    return ListTile( //O titulo de cada item da lista
      title: Text( //O titulo é um texto
        //2 palavras em ingles que vai receber, sendo que cada palavra vai começão com letra maiuscula
        pair.asPascalCase,
        style: _biggerFont, //Estilo do texto da linha
      ),
      trailing: Icon( //Define icone das linhas
        alreadySaved ? Icons.favorite : Icons.favorite_border, //Define os 2 icones na lista para animação
        color: alreadySaved ? Colors.red : null, //Cor do icone
      ),
      onTap: () { //Ação de toque no item da lista
        setState(() { //Avisa que o estado/aparencia vai mudar
          if (alreadySaved) {
            _saved.remove(pair); //remove do array
          } else {
            _saved.add(pair); //Adiciona ao array
          }
        });
      },
    );
  }

  Widget _buildSuggestions() { //Toda programaçaõ do corpo do app
    return ListView.builder( //cria uma lista e configura a construção
        padding: const EdgeInsets.all(16), //Define padding das bordas da lista
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) { //isOdd erifica se o numero é impar
            return Divider(); //Divide
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]); //Retorna configuração de cada linha
        });
  }
}