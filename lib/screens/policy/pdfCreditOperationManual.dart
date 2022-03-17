import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CreditOperationManualScreen extends StatefulWidget {
  const CreditOperationManualScreen({Key? key}) : super(key: key);

  @override
  _CreditOperationManualScreenState createState() =>
      _CreditOperationManualScreenState();
}

class _CreditOperationManualScreenState
    extends State<CreditOperationManualScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //Set to true
  late PdfViewerController _pdfViewerController;
  late PdfTextSearchResult _searchResult;
  TextEditingController searchController = TextEditingController();

  bool _isloading = false;

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Credit Operation Manual');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: logolightGreen,
          title: customSearchBar,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        controller: searchController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: 'type in here...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Credit Operation Manual');
                  }
                });
              },
              icon: customIcon,
            ),
            if (customIcon.icon != Icons.search)
              ElevatedButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  setState(() {
                    _isloading = true;
                  });

                  Future.delayed(Duration(seconds: 5), () async {
                    _searchResult = (await _pdfViewerController.searchText(
                      searchController.text,
                    ));
                    setState(() {
                      _isloading = false;
                    });
                  });
                },
                child: Text(
                  "search",
                  style: TextStyle(color: Colors.black),
                ),
              )
          ],
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Visibility(
                  visible: _searchResult.hasResult,
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchResult.clear();
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: _searchResult.hasResult,
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _searchResult.previousInstance();
                    },
                  ),
                ),
                Visibility(
                  visible: _searchResult.hasResult,
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _searchResult.nextInstance();
                    },
                  ),
                ),
              ],
            ),
            _isloading
                ? Center(
                    child: Text("Loading"),
                  )
                : Container(),
            Expanded(
              child: SfPdfViewer.asset(
                'assets/Credit_Operation_Manual.pdf',
                controller: _pdfViewerController,
                currentSearchTextHighlightColor: Colors.red.withOpacity(0.7),
                otherSearchTextHighlightColor: Colors.red.withOpacity(0.5),
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _searchResult = PdfTextSearchResult();
    setState(() {
      _isloading = true;
    });

    Future.delayed(Duration(seconds: 3), () async {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }
}
