import 'package:Ihsan/localization/localization_constants.dart';
import 'package:Ihsan/models/City.dart';
import 'package:Ihsan/providers/radioListTile_cities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:search_widget/search_widget.dart';

class CityLatLng extends StatefulWidget {
  List _list;

  CityLatLng(this._list);

  @override
  _CityLatLngState createState() => _CityLatLngState(this._list);
}

class _CityLatLngState extends State<CityLatLng> {
  List _list;
  City _selectedItem;
  bool _show = true;

  _CityLatLngState(this._list);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<RadioListTileCitiesProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: <Widget>[
          Text(getTrabskated(context, "city")),
          const SizedBox(
            height: 10,
          ),
          if (_show)
            SearchWidget<City>(
              dataList: _list,
              hideSearchBoxWhenItemSelected: false,
              listContainerHeight: MediaQuery.of(context).size.height / 4,
              queryBuilder: (query, list) {
                return list
                    .where((item) =>
                        item.city.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              },
              popupListItemBuilder: (item) {
                return PopupListCityWidget(item);
              },
              selectedItemBuilder: (selectedItem, deleteSelectedItem) {
                return SelectedCityWidget(selectedItem, deleteSelectedItem);
              },
              // widget customization
              noItemsFoundWidget: NoCityFound(),
              textFieldBuilder: (controller, focusNode) {
                return MyTextField(controller, focusNode);
              },
              onItemSelected: (item) {
                bloc.selectedCity = item;
              },
            ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "${bloc.selectedCity != null ? bloc.selectedCity.toJson().toString() : getTrabskated(context, "A city is not selected")}",
          ),
        ],
      ),
    );
  }
}

class SelectedCityWidget extends StatelessWidget {
  const SelectedCityWidget(this.selectedCity, this.deleteSelectedItem);

  final City selectedCity;
  final VoidCallback deleteSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                selectedCity.city,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 22),
            color: Colors.grey[700],
            onPressed: deleteSelectedItem,
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField(this.controller, this.focusNode);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x4437474F),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: getTrabskated(context, "Search here..."),
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      ),
    );
  }
}

class NoCityFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.folder_open,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          getTrabskated(context, "The city has not found"),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PopupListCityWidget extends StatelessWidget {
  const PopupListCityWidget(this.item);

  final City item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        item.city,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
