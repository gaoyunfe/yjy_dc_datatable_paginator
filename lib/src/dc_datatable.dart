import 'package:flutter/material.dart';

import 'package:dc_datatable_paginator/dc_datatable_paginator.dart';

import 'dc_paginator.dart';

class DcDataTable extends StatefulWidget {
  final List<DataColumn> columns;

  final bool paginator;
  final String labelPage;
  final String labelRecords;
  final String labelNoRecords;
  final bool showCheckboxColumn;
  final bool showInputSearch;
  final String labelSearch;
  final String labelLoading;
  final TextInputAction? textInputActionSearch;

  final DcDataTableController controller;

  const DcDataTable(
      {Key? key,
      required this.controller,
      required this.columns,
      this.paginator = true,
      this.labelPage = 'Página',
      this.labelRecords = 'Registros',
      this.labelNoRecords = "Sem registros",
      this.labelSearch = "Pesquisa",
      this.labelLoading = "Carregando...",
      this.showCheckboxColumn = false,
      this.showInputSearch = false,
      this.textInputActionSearch = TextInputAction.go})
      : super(key: key);

  @override
  State<DcDataTable> createState() => _DcDataTableState();
}

class _DcDataTableState extends State<DcDataTable> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListenerUpdateCurrentPage(() {
      setState(() {
        fetchData();
      });
    });

    widget.controller.addListenerUpdateSearchValue(() {
      setState(() {
        fetchData();
      });
    });

    widget.controller.addListenerUpdateData(() {
      setState(() {});
    });

    widget.controller.addListenerUpdateDataSelected(() {
      setState(() {});
    });

    widget.controller.addListenerUpdateSortColumnIndex(() {
      setState(() {});
    });

    widget.controller.addListenerUpdateSortAscending(() {
      setState(() {});
    });

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //input search
                widget.showInputSearch
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.50,
                              ),
                              Expanded(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                  child: TextField(
                                    textInputAction:
                                        widget.textInputActionSearch,
                                    keyboardType: TextInputType.text,
                                    onSubmitted: (value) {
                                      widget.controller.searchValue = value;
                                    },
                                    onChanged: (value) {
                                      if (widget.textInputActionSearch !=
                                          TextInputAction.go) {
                                        widget.controller.searchValue = value;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.search),
                                      labelText: widget.labelSearch,
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              )
                            ]),
                      )
                    : const SizedBox(),
                //datatable
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    showCheckboxColumn: widget.showCheckboxColumn,
                    headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Theme.of(context).colorScheme.primary,
                    ),
                    sortAscending: widget.controller.sortAscending,
                    sortColumnIndex: widget.controller.sortColumnIndex,
                    columns: widget.columns,
                    showBottomBorder: true,
                    rows: _createRows(),
                  ),
                ),
                //label no records
                (!widget.controller.loadding && widget.controller.data.isEmpty)
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(widget.labelNoRecords,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)))
                    : const SizedBox(),

                //paginator
                (!widget.controller.loadding &&
                        widget.controller.data.isNotEmpty)
                    ? DcPaginator(
                        enable: widget.paginator,
                        labelPage: widget.labelPage,
                        labelRecords: widget.labelRecords,
                        controller: widget.controller,
                      )
                    : const SizedBox(),

                //progress
                widget.controller.loadding
                    ? Center(
                        child: Dialog(
                          // The background color
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // The loading indicator
                                const CircularProgressIndicator(),
                                const SizedBox(
                                  height: 15,
                                ),
                                // Some text
                                Text(widget.labelLoading)
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            )),
      ),

      //paginator
    );
  }

  _createRows() {
    List<DataRow> createRows = [];
    for (int i = 0; i < widget.controller.data.length; i++) {
      createRows.add(widget.controller.getRow(i));
    }

    return createRows;
  }

  fetchData() async {
    widget.controller.onLoadData();
  }
}
