import 'package:flutter/material.dart';
import 'package:siptadik/page/resepsionis/detail_tamu_page.dart';
import 'package:siptadik/theme/padding.dart';

import '../../theme/colors.dart';

class SearchPage extends SearchDelegate {
  final List listTamu;

  SearchPage({required this.listTamu});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear, color: kWhite,),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        tooltip: 'Back',
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
          color: kWhite,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text("Search term must be longer than two letters."),
          )
        ],
      );
    }

    final results = listTamu
        .where(
            (tamu) => tamu.nama.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text("No Results Found"),
          )
        ],
      );
    }

    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, i) {
          return ListTile(
            contentPadding: EdgeInsets.all(padding),
            title: Text(results[i].nama, style: TextStyle(fontSize: 12),),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailTamuPage(
                            nama: results[i].nama,
                            nip: results[i].nip,
                            nik: results[i].nik,
                            provinsi: results[i].provinces,
                            kota: results[i].regencies,
                            noHp: results[i].noHp,
                            alamat: results[i].alamat,
                            kategori: results[i].category,
                            jekel: results[i].jenisKelamin,
                            jabatan: results[i].jabatan,
                            unitKerja: results[i].unitKerja,
                            tujuanBertamu: results[i].tujuanBertamu,
                            foto: results[i].foto,
                            createdAt: results[i].createdAt,
                          )));
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? listTamu
        : listTamu
            .where((tamu) =>
                tamu.nama.toLowerCase().contains(query.toLowerCase()))
            .toList();
    // TODO: implement buildSuggestions
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, i) {
          return ListTile(
            contentPadding: EdgeInsets.only(
              left: padding,
            ),
            title: Text(suggestions[i].nama, style: TextStyle(fontSize: 12),),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailTamuPage(
                            nama: suggestions[i].nama,
                            nip: suggestions[i].nip,
                            nik: suggestions[i].nik,
                            provinsi: suggestions[i].provinces,
                            kota: suggestions[i].regencies,
                            noHp: suggestions[i].noHp,
                            alamat: suggestions[i].alamat,
                            kategori: suggestions[i].category,
                            jekel: suggestions[i].jenisKelamin,
                            jabatan: suggestions[i].jabatan,
                            unitKerja: suggestions[i].unitKerja,
                            tujuanBertamu: suggestions[i].tujuanBertamu,
                            foto: suggestions[i].foto,
                            createdAt: suggestions[i].createdAt,
                          )));
            },
          );
        });
  }
}
