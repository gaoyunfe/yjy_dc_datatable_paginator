import 'package:dc_datatable_paginator/dc_datatable_paginator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//########################
///  APP
//##########################
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example DcDataTable',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Example DcDataTable'),
    );
  }
}

//########################
///  SCREEM
//##########################

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DcDataTableController controller = MyDataTableController(context);

    controller.sortColumnIndex = 1;
    controller.limitPages = 10;
    controller.pageSize = 7;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///  Widget Definition
            DcDataTable(
              controller: controller,
              labelPage: 'Page',
              labelRecords: 'Records',
              labelNoRecords: 'No Records',
              showCheckboxColumn: false,
              showInputSearch: true,
              textInputActionSearch: TextInputAction.search,
              columns: [
                DataColumn(
                    label: const Text('Id'),
                    onSort: (columnIndex, ascending) {
                      onSortColumn(controller, columnIndex, ascending);
                    }),
                DataColumn(
                    label: const Text('Name'),
                    onSort: (columnIndex, ascending) {
                      onSortColumn(controller, columnIndex, ascending);
                    }),
                DataColumn(
                    label: const Text('Description'),
                    onSort: (columnIndex, ascending) {
                      onSortColumn(controller, columnIndex, ascending);
                    }),
              ],
            ),
          ],
        ),
      ),
    );

    //record search simulation in an api
  }

  void onSortColumn(
      DcDataTableController controller, int columnIndex, bool ascending) {
    List<ModelExample> list = List<ModelExample>.from(controller.data);

    if (columnIndex == 0) {
      list.sort((m1, m2) => DcDataTableController.compareString(
          ascending, m1.id.toString(), m2.id.toString()));
    } else if (columnIndex == 1) {
      list.sort((m1, m2) =>
          DcDataTableController.compareString(ascending, m1.name, m2.name));
    } else if (columnIndex == 2) {
      list.sort((m1, m2) => DcDataTableController.compareString(
          ascending, m1.description, m2.description));
    }

    controller.data = list;
    controller.sortAscending = ascending;
    controller.sortColumnIndex = columnIndex;
  }
}

//########################
///  MODEL
//##########################
class ModelExample {
  final int id;
  final String name;
  final String description;
  ModelExample({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ModelExample &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}

//########################
///  CONTROLLER
//##########################

class MyDataTableController extends DcDataTableController {
  MyDataTableController(super.context);

  @override
  Future<void> onLoadData() async {
    //get Data from API
    debugPrint("fetch data from  api...");
    loadding = true;
    Future.delayed(
      const Duration(seconds: 2),
      () {
        List<ModelExample> dataList = List.generate(pageSize, (i) {
          i++;
          return ModelExample(
              id: i + (currentPage * 10),
              name: "Name ${i + (currentPage * 10)} ",
              description:
                  "Description:  Record:${i + (currentPage * 10)}  Page: ${currentPage + 1}  search: $searchValue ");
        });

        //set result Data from Api
        data = dataList;
        //symbolic value
        totalRecords = 110;
        //close dialog loading
        loadding = false;
      },
    );
  }

  @override
  DataRow getRow(int rowIndex) {
    ModelExample model = data[rowIndex];
    return DataRow(
        cells: <DataCell>[
          DataCell(Text(model.id.toString())),
          DataCell(Text(model.name)),
          DataCell(Text(model.description)),
        ],
        selected: dataSelected.contains(model),
        onSelectChanged: (value) {
          if (dataSelected.contains(model)) {
            dataSelected.remove(model);
          } else {
            dataSelected.add(model);
          }
          onLoadData();
        });
  }
}
