import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shersoft/controller/dataController.dart';
import 'package:shersoft/controller/login.dart';
import 'package:shersoft/model/dataModel.dart';
import 'package:shersoft/services/backup/backup.dart';
import 'package:shersoft/view/home/homeWidget/drawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _cashin = TextEditingController();
  final TextEditingController _cashout = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserController>(context, listen: false).getUserMetaData();
      Provider.of<Datacontroller>(context, listen: false).getdata();
      // BackupServices().fetchDataFirebase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0XFFF5F5F5),
      drawer: Consumer<UserController>(
          builder: (context, value, child) => drawer(
              context: context,
              company: value.companyName ?? '',
              phone: value.phone ?? '')),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Icon(
            Icons.search,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: const Color(0XFF0008B4),
        title: Text(
          "Cash Book",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<Datacontroller>(context, listen: false).getdata('All');
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<Datacontroller>(
                builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['All', 'Daily', 'Weekly', 'Monthly'].map((filter) {
                    bool isSelected = value.selected == filter;
                    return SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          value.selectedColor(filter);
                          value.getdata(filter);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              isSelected ? Colors.white : Color(0XFF0008B4),
                          backgroundColor:
                              isSelected ? Color(0XFF0008B4) : Colors.white,
                        ),
                        child: Text(filter),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Color(0XFFFFFFFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        "Cash in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF30CB76),
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Cash out",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0XFFF31717),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<Datacontroller>(
                builder: (context, value, child) {
                  if (value.filteredData.isEmpty) {
                    return Center(child: Text("No transactions found"));
                  }
                  return ListView.builder(
                    itemCount: value.filteredData.length,
                    itemBuilder: (context, index) {
                      final data = value.filteredData[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0XFFFFFFFF),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.day ?? ''),
                                    Text("${data.date} ${data.time}")
                                  ],
                                ),
                                Text(
                                  data.cashIn ?? '0',
                                  style: TextStyle(
                                    color: Color(0XFF30CB76),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data.cashout ?? '0',
                                  style: TextStyle(
                                    color: Color(0XFFF31717),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF0008B4),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          DateTime datetime = DateTime.now();

          final date = DateFormat('dd/MM/yyyy').format(datetime);
          final day = DateFormat('EEEE').format(datetime);
          final time = DateFormat('hh:mm:a').format(datetime);

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text("Add Data"),
                actions: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _cashin,
                    decoration: InputDecoration(hintText: 'cash in'),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _cashout,
                    decoration: InputDecoration(hintText: 'cash out'),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          final data = Datamodel(
                              cashIn: _cashin.text.trim(),
                              cashout: _cashout.text.trim(),
                              date: date,
                              day: day,
                              uid: Provider.of<UserController>(context,
                                      listen: false)
                                  .uid,
                              time: time);
                          Provider.of<Datacontroller>(context, listen: false)
                              .addDatafireBase(data: data);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0XFF0008B4),
                        ),
                        child: Text("add"),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
