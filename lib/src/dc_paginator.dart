import 'package:flutter/material.dart';
import '../dc_datatable_paginator.dart';

class DcPaginator extends StatelessWidget {
  final bool enable;
  final String labelPage;
  final String labelRecords;
  final DcDataTableController controller;

  const DcPaginator({
    Key? key,
    required this.controller,
    this.enable = false,
    this.labelPage = 'Page',
    this.labelRecords = 'Records',
  }) : super(key: key);

  int get maxPageSize => (controller.totalRecords / controller.pageSize).ceil();

  @override
  Widget build(BuildContext context) {
    //
    if (enable == false) return Container();

    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DcButton(
                  onPressed: _getCurrentPage() != 0 ? _first : null,
                  child: const Icon(Icons.first_page),
                ),
                DcButton(
                  onPressed: _getCurrentPage() > 0 ? _prev : null,
                  child: const Icon(Icons.chevron_left),
                ),
                ..._generateButtonList(),
                DcButton(
                  onPressed:
                      _getCurrentPage() + 1 >= maxPageSize ? null : _next,
                  child: const Icon(Icons.chevron_right),
                ),
                DcButton(
                  onPressed:
                      (_getCurrentPage() != maxPageSize - 1) ? _last : null,
                  child: const Icon(Icons.last_page),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  '$labelRecords: ${controller.totalRecords}   $labelPage: ${_getCurrentPage() + 1}/$maxPageSize',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  int _getCurrentPage() {
    return controller.currentPage;
  }

  _setCurrentPage(int value) {
    return controller.currentPage = value;
  }

  _first() {
    _setCurrentPage(0);
  }

  _last() {
    _setCurrentPage(maxPageSize - 1);
  }

  _prev() {
    _setCurrentPage(_getCurrentPage() - 1);
  }

  _next() {
    _setCurrentPage(_getCurrentPage() + 1);
  }

  _navigateToPage(int index) {
    index = index;
    _setCurrentPage(index);
  }

  List<Widget> _generateButtonList() {
    List<Widget> buttons = [];

    int pageSize = controller.limitPages;
    int pageStart = 0;
    int pageEnd = maxPageSize;
    int currentPage = _getCurrentPage() + 1;

    if (controller.limitPages < maxPageSize) {
      int group = (currentPage / pageSize).ceil();
      if (group == 0) group = 1;
      int limiteFim = (group * pageSize);
      int pageStart = (limiteFim - pageSize);
      int pageEnd = limiteFim;

      if (pageEnd > maxPageSize) pageEnd = maxPageSize;

      for (int x = pageStart; x < pageEnd; x++) {
        buttons.add(_buildPageButton(x));
      }
    } else {
      for (int x = pageStart; x < pageEnd; x++) {
        buttons.add(_buildPageButton(x));
      }
    }

    return buttons;
  }

  Widget _buildPageButton(int index) => DcButton(
        onPressed: () => _navigateToPage(index),
        selected: _selected(index),
        child: Text((index + 1).toString(),
            maxLines: 1,
            style: TextStyle(
                color: _selected(index) ? Colors.white : Colors.black87)),
      );

  bool _selected(index) => index == _getCurrentPage();
}
