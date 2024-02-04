import 'package:brand_names/models/band_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BandModel> bands = [
    BandModel(id: '1', name: 'rammstein', votes: 5),
    BandModel(id: '2', name: 'Queen', votes: 10),
    BandModel(id: '3', name: 'metallica', votes: 4),
    BandModel(id: '4', name: 'placebo', votes: 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Band Names',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (_, int index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(BandModel band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('dissmised id: ${band.id}');
      },
      background: Container(
        padding: const EdgeInsets.only(left: 10),
        color: Colors.red[400],
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete band',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            band.name.substring(0, 2),
          ),
        ),
        title: Text(band.name),
        trailing: Text(
          "${band.votes}",
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  addNewBand() {
    final _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New band name'),
          content: TextField(
            controller: _controller,
          ),
          actions: [
            MaterialButton(
              elevation: 5,
              onPressed: () => addBandToList(_controller.text),
              textColor: Colors.blue,
              child: const Text('add'),
            )
          ],
        );
      },
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final newBand =
          BandModel(id: "${bands.length + 1}", name: name, votes: 0);
      bands.add(newBand);
      setState(() {});
    }

    Navigator.pop(context);
  }
}
