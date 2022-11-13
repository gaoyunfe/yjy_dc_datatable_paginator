import 'package:flutter/material.dart';

class DcDataTableController {
  late BuildContext context;

  final ValueNotifier<int> _pageSize = ValueNotifier(10);
  final ValueNotifier<int> _initialPage = ValueNotifier(0);
  final ValueNotifier<int> _limitPages = ValueNotifier(5);
  final ValueNotifier<int> _totalRecords = ValueNotifier(0);
  final ValueNotifier<List> _data = ValueNotifier([]);
  final ValueNotifier<List> _dataSelected = ValueNotifier([]);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  final ValueNotifier<bool> _sortAscending = ValueNotifier(false);
  final ValueNotifier<int> _sortColumnIndex = ValueNotifier(0);
  final ValueNotifier<String> _searchValue = ValueNotifier('');

  final ValueNotifier<bool> _loadding = ValueNotifier(false);

  //getters
  int get totalRecords => _totalRecords.value;
  List get data => _data.value;
  List get dataSelected => _dataSelected.value;
  int get currentPage => _currentPage.value;
  bool get sortAscending => _sortAscending.value;
  int get sortColumnIndex => _sortColumnIndex.value;
  int get pageSize => _pageSize.value;
  int get initialPage => _initialPage.value;
  int get limitPages => _limitPages.value;
  String get searchValue => _searchValue.value;
  bool get loadding => _loadding.value;

  //setters
  set totalRecords(int value) => _totalRecords.value = value;
  set data(List value) => _data.value = value;
  set dataSelected(List value) => _dataSelected.value = value;
  set currentPage(int value) => _currentPage.value = value;
  set sortAscending(value) => _sortAscending.value = value;
  set sortColumnIndex(sortColumnIndex) =>
      _sortColumnIndex.value = sortColumnIndex;
  set pageSize(int value) => _pageSize.value = value;
  set limitPages(int value) => _limitPages.value = value;
  set searchValue(String value) => _searchValue.value = value;

  set loadding(bool value) {
    _loadding.value = value;
  }

  DcDataTableController(this.context);

  DataRow getRow(int rowIndex) {
    return const DataRow(cells: <DataCell>[DataCell(Text("none"))]);
  }

  Future<void> onLoadData() async {
    data = [];
    totalRecords = 0;
  }

  void addListenerUpdateCurrentPage(Function() f) {
    _currentPage.addListener(f);
  }

  void addListenerUpdateData(Function() f) {
    _data.addListener(f);
  }

  void addListenerUpdateTotalRecords(Function() f) {
    _totalRecords.addListener(f);
  }

  void addListenerUpdateDataSelected(Function() f) {
    _dataSelected.addListener(f);
  }

  void addListenerUpdateSortColumnIndex(Function() f) {
    _sortColumnIndex.addListener(f);
  }

  void addListenerUpdateSortAscending(Function() f) {
    _sortAscending.addListener(f);
  }

  void addListenerUpdateSearchValue(Function() f) {
    _searchValue.addListener(f);
  }

  static int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
