import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/db_Handler.dart';
import '../Controller/HomeController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());
  TextEditingController txtname = TextEditingController();
  TextEditingController txtnumber = TextEditingController();
  TextEditingController txtdname = TextEditingController();
  TextEditingController txtdnumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    homeController.dataList.value = await DbHandler.dbHandler.readData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Contact Diary",
            style: GoogleFonts.satisfy(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                textInputAction: TextInputAction.next,
                controller: txtname,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: GoogleFonts.satisfy(),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                textInputAction: TextInputAction.next,
                controller: txtnumber,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Contact Number",
                  hintStyle: GoogleFonts.satisfy(),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () async {
                  DbHandler.dbHandler
                      .insertData(name: txtname.text, number: txtnumber.text);
                  getData();
                },
                child: Text(
                  "Insert",
                  style: GoogleFonts.satisfy(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: homeController.dataList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          elevation: 10,
                          child: ExpansionTile(
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            leading: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                  "${homeController.dataList[index]['name'][0]}"
                                      .toUpperCase(),
                                  style: GoogleFonts.satisfy(color: Colors.white,fontSize: 18)),
                            ),
                            title: Text(
                                "${homeController.dataList[index]['name']}",
                                style: GoogleFonts.satisfy()),
                            subtitle: Text(
                                "${homeController.dataList[index]['number']}",
                                style: GoogleFonts.satisfy()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    DbHandler.dbHandler.deleteData(
                                        id: homeController.dataList[index]
                                            ['id']);
                                    getData();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    txtdname = TextEditingController(
                                        text: homeController.dataList[index]
                                            ['name']);
                                    txtdnumber = TextEditingController(
                                        text: homeController.dataList[index]
                                            ['number']);
                                    Get.defaultDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: txtdname,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextField(
                                              controller: txtdnumber,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  DbHandler.dbHandler
                                                      .updateData(
                                                          id: homeController
                                                                  .dataList[
                                                              index]['id'],
                                                          name: txtdname.text,
                                                          number:
                                                              txtdnumber.text);
                                                  Get.back();
                                                  getData();
                                                },
                                                child: Text(
                                                  "Update",
                                                  style: GoogleFonts.satisfy(
                                                      color: Colors.white),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: GoogleFonts.satisfy(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          )
                                        ]);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        // await launchUrl(Uri.parse("tel:${homeController.dataList[index]['number']}"),);
                                        await FlutterPhoneDirectCaller.callNumber(
                                            "${homeController.dataList[index]['numbe'
                                                'r']}");
                                      },
                                      icon: Icon(
                                        Icons.call,
                                        color: Colors.green,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        await launchUrl(Uri.parse(
                                            "sms:${homeController.dataList[index]['number']}"));
                                      },
                                      icon: Icon(
                                        Icons.message,
                                        color: Colors.blue,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.history)),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:database/Screen/Controller/HomeController.dart';
// import 'package:database/Utils/db_Handler.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   TextEditingController txtname = TextEditingController();
//   TextEditingController txtnumber = TextEditingController();
//   TextEditingController txtdname = TextEditingController();
//   TextEditingController txtdnumber = TextEditingController();
//   HomeController homeController = Get.put(HomeController());
//
//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }
//
//   Future<void> getData() async {
//     homeController.dataList.value = await DbHandler.dbHandler.readData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Contact Diary"),
//           centerTitle: true,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               TextField(textInputAction: TextInputAction.next,
//                 controller: txtname,
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder(), hintText: "Name"),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 textInputAction: TextInputAction.next,
//                 controller: txtnumber,
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder(), hintText: "Contact number"),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   DbHandler.dbHandler
//                       .insertData(name: txtname.text, number: txtnumber.text);
//                   getData();
//                 },
//                 child: Text("Insert"),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Expanded(
//                 child: Obx(
//                   () => Container(
//                     child: ListView.builder(
//                       itemCount: homeController.dataList.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ListTile(
//                             tileColor: Colors.blue,
//                             leading:
//                                 Text("${homeController.dataList[index]['id']}"),
//                             title: Text(
//                                 "${homeController.dataList[index]['name']}"),
//                             subtitle: Text(
//                                 "${homeController.dataList[index]['number']}"),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   onPressed: () {
//                                     DbHandler.dbHandler.deleteData(
//                                         id: homeController.dataList[index]
//                                             ['id']);
//                                     getData();
//                                   },
//                                   icon: Icon(Icons.delete),
//                                 ),
//                                 IconButton(
//                                   onPressed: () {
//                                     txtdname = TextEditingController(
//                                         text: homeController.dataList[index]
//                                             ['name']);
//                                     txtdnumber = TextEditingController(
//                                         text: homeController.dataList[index]
//                                             ['number']);
//                                     Get.defaultDialog(
//                                         content: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             TextField(
//                                               controller: txtdname,
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             TextField(
//                                               controller: txtdnumber,
//                                             ),
//                                           ],
//                                         ),
//                                         actions: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             children: [
//                                               ElevatedButton(
//                                                 onPressed: () {
//                                                   DbHandler.dbHandler
//                                                       .updateData(
//                                                           id: homeController
//                                                                   .dataList[
//                                                               index]['id'],
//                                                           name: txtdname.text,
//                                                           number:
//                                                               txtdnumber.text);
//                                                   Get.back();
//                                                   getData();
//                                                 },
//                                                 child: Text("Update"),
//                                               ),
//                                               SizedBox(
//                                                 width: 10,
//                                               ),
//                                               ElevatedButton(
//                                                 onPressed: () {
//                                                   Get.back();
//                                                 },
//                                                 child: Text("Cancel"),
//                                               ),
//                                             ],
//                                           )
//                                         ]);
//                                   },
//                                   icon: Icon(Icons.edit),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
