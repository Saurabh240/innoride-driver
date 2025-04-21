import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_strings.dart';
import '../../../core/utils/style.dart';
import '../snack_bar/show_custom_snackbar.dart';

class DownloadingDialog extends StatefulWidget {
  final String url;
  final String fileName;

  const DownloadingDialog(
      {super.key, required this.url, required this.fileName});

  @override
  DownloadingDialogState createState() => DownloadingDialogState();
}

class DownloadingDialogState extends State<DownloadingDialog> {
  int _total = 0, _received = 0;
  late http.StreamedResponse _response;
  File? _image;
  final List<int> _bytes = [];
  bool _isImage = false;

  // Detects if the file is an image based on the file extension.
  bool _detectIfImage(String url) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    String extension = url.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  // Generates a formatted timestamp for file naming.
  String _getTimestamp() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String _getFileExtension(String url) {
    final extension = url.split('.').last;
    return extension.contains('/')
        ? 'png'
        : extension; // Default to png if no extension found
  }

  Future<void> _downloadFile() async {
    _response =
        await http.Client().send(http.Request('GET', Uri.parse(widget.url)));
    _total = _response.contentLength ?? 0;
    String fileExtension = _getFileExtension(widget.url);
    String dynamicFileName =
        '${widget.fileName}_${_getTimestamp()}.$fileExtension';

    _response.stream.listen((value) {
      setState(() {
        _bytes.addAll(value);
        _received += value.length;
      });
    }).onDone(() async {
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$dynamicFileName');
      File savedFile = await file.writeAsBytes(_bytes);
      Get.back();
      CustomSnackBar.success(successList: [
        '${MyStrings.fileDownloadedSuccess}: ${savedFile.path}'
      ]);
      setState(() {
        _image = file;
      });
    });
  }

  Future<void> _saveImage() async {
    try {
      var response = await http.get(Uri.parse(widget.url), headers: {
        "dev-token":
            "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
      });
      if (response.statusCode == 200) {
        String fileExtension = _getFileExtension(widget.url);
        String dynamicFileName =
            '${widget.fileName}_${_getTimestamp()}.$fileExtension';

        final result = await ImageGallerySaverPlus.saveImage(
            Uint8List.fromList(response.bodyBytes),
            quality: 60,
            name: dynamicFileName);
        dynamic value = result['isSuccess'];
        if (value.toString() == 'true') {
          Get.back();
          CustomSnackBar.success(
              successList: [(MyStrings.fileDownloadedSuccess)]);
        } else {
          Get.back();
          dynamic errorMessage = result['errorMessage'];
          CustomSnackBar.error(errorList: [errorMessage]);
        }
      } else {
        Get.back();
        CustomSnackBar.error(errorList: [MyStrings.requestFail]);
      }
    } catch (e) {
      printX(e.toString());
      Get.back();
      CustomSnackBar.error(errorList: [MyStrings.requestFail]);
    }
  }

  @override
  void initState() {
    super.initState();
    _isImage = _detectIfImage(widget.url);
    if (_isImage) {
      _saveImage();
    } else {
      _downloadFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColor.getCardBgColor(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SpinKitThreeBounce(
                color: MyColor.primaryColor,
                size: 20.0,
              ),
            ),
          ),
          Visibility(
              visible: !_isImage,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      '${MyStrings.downloading.tr} ${_received ~/ 1024}/${_total ~/ 1024} ${'KB'.tr}',
                      style: regularDefault),
                ],
              ))
        ],
      ),
    );
  }
}
