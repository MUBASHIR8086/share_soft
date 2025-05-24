import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shersoft/controller/login.dart';
import 'package:shersoft/view/home/accounts.dart';
import 'package:shersoft/view/home/backup&restore.dart';

Drawer drawer({BuildContext? context,String? company,String? phone}) {
  return Drawer(
    child: Center(
        child: Column(
      children: [
        Container(
          child: Column(
            spacing: 20,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(company??'',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white
              ),),
              Text(phone??'',style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),)
            ],
          ),
          color: const Color.fromARGB(255, 36, 44, 201),
          height: 200,
          width: double.infinity,
        ),
        ListTile(
          onTap: () => Navigator.push(
              context!, MaterialPageRoute(builder: (context) => AccountsPage())),
          title: Text("Accounts"),
          leading: Icon(Icons.groups_outlined),
        ),
        ListTile(
          title: Text("Transfer"),
          leading: Icon(Icons.track_changes),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context!, MaterialPageRoute(builder: (context)=>BackupandRestore()));
          },
          title: Text("Backup and Restore"),
          leading: Icon(Icons.settings_backup_restore),
        ),
        ListTile(
          title: Text("Settings"),
          leading: Icon(Icons.settings_outlined),
        ),
        ListTile(
          onTap: () {
            Provider.of<UserController>(context!, listen: false)
                .logoutUser(context);
          },
          title: Text("Logout"),
          leading: Icon(Icons.logout),
        )
      ],
    )),
  );
}
