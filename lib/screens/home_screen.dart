import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:brand_names/models/band_model.dart';
import 'package:brand_names/services/socket_io_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BandModel> bands = [];

  @override
  void initState() {
    super.initState();

    final socketService = Provider.of<SocketIoService>(context, listen: false);

    socketService.socket.on('active-bands', (payload) {
      List<BandModel> _bands =
          (payload as List).map((band) => BandModel.fromMap(band)).toList();
      bands = _bands;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    final socketService = Provider.of<SocketIoService>(context, listen: false);
    socketService.socket.off('active-bands');
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketIoService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Band Names',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(
                    Icons.check_circle_sharp,
                    color: Colors.blue[300],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red[300],
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          if (bands.isNotEmpty) _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (_, int index) => _bandTile(bands[index]),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(BandModel band) {
    final socketService = Provider.of<SocketIoService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        socketService.emit('remove-band', {'id': band.id});
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
        onTap: () {
          socketService.emit(
            'vote-band',
            {
              'id': band.id,
            },
          );
        },
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
      final socketService =
          Provider.of<SocketIoService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};

    bands.forEach((band) {
      dataMap.putIfAbsent(
        band.name,
        () => band.votes.toDouble(),
      );
    });

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(
          milliseconds: 800,
        ),
        chartType: ChartType.ring,
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 0,
        ),
      ),
    );
  }
}
