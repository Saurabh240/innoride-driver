import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/model/authorization/authorization_response_model.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:ovoride_driver/presentation/components/app-bar/custom_appbar.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovoride_driver/presentation/screens/ticket/widget/circle_icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class PreviewImageScreen extends StatefulWidget {
  String url;
  PreviewImageScreen({super.key, required this.url});

  @override
  State<PreviewImageScreen> createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  @override
  void initState() {
    widget.url = Get.arguments;
    super.initState();
  }

  //download pdf
  TargetPlatform? platform;
  String _localPath = '';
  String downLoadId = "";

  Future<bool> checkPermission() async {
    if (platform == TargetPlatform.android) {
      await Permission.storage.request();
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        await Permission.storage.request();
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    checkPermission();
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (Platform.isAndroid) {
      return "/storage/emulated/0/Download";
      // final directory = await getExternalStorageDirectory();
      // if (directory != null) {
      //   return directory.path;
      // } else {
      //   return (await getExternalStorageDirectory())?.path ?? "";
      // }
    } else if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      return null;
    }
  }

  bool isSubmitLoading = false;

  Future<void> downloadAttachment(String url, String extention) async {
    isSubmitLoading = true;
    setState(() {});

    await _prepareSaveDir();

    final headers = {
      'Authorization': "Bearer ${Get.find<ApiClient>().token}",
      'content-type': "application/pdf",
      "dev-token":
          "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;

      await saveFile(
          bytes, '${MyStrings.appName} ${DateTime.now()}.$extention');
    } else {
      try {
        AuthorizationResponseModel model =
            AuthorizationResponseModel.fromJson(jsonDecode(response.body));
        CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong]);
      } catch (e) {
        CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
      }
    }

    isSubmitLoading = false;
    setState(() {});
  }

  Future<void> saveFile(List<int> bytes, String fileName) async {
    final path = '$_localPath/$fileName';
    final file = File(path);
    await file.writeAsBytes(bytes).then((v) {
      printX(v.absolute.path);
      CustomSnackBar.success(successList: [MyStrings.imgDownloadMsg]);
    });
  }

  Future<void> downloadImageToDownloads(String url) async {
    try {
      // Check and request storage permission
      if (Platform.isAndroid) {
        if (await Permission.storage.request() != PermissionStatus.granted) {
          CustomSnackBar.error(errorList: ['Storage permission is required']);
          return;
        }
      }

      isSubmitLoading = true;
      setState(() {});

      final headers = {
        'Authorization': "Bearer ${Get.find<ApiClient>().token}",
        "dev-token":
            "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final fileName =
            '${MyStrings.appName}_${DateTime.now().millisecondsSinceEpoch}.${url.split('.').last}';

        if (Platform.isAndroid) {
          final directory = await getExternalStorageDirectory();
          if (directory == null) {
            throw Exception('Could not access storage directory');
          }

          final downloadsPath = Directory('${directory.path}/Download');
          printX(downloadsPath.path);
          if (!await downloadsPath.exists()) {
            await downloadsPath.create(recursive: true);
          }

          final filePath = '${downloadsPath.path}/$fileName';
          final file = File(filePath);
          await file.writeAsBytes(bytes);
          CustomSnackBar.success(
              successList: ['Image saved to Downloads folder $filePath']);
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/$fileName';
          final file = File(filePath);
          await file.writeAsBytes(bytes);
          CustomSnackBar.success(
              successList: ['Image saved to Documents folder $filePath']);
        }
      } else {
        CustomSnackBar.error(errorList: ['Failed to download image']);
      }
    } catch (e) {
      printX(e);
      CustomSnackBar.error(errorList: [e.toString()]);
    } finally {
      isSubmitLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: CustomAppBar(
        title: 'Image Preview',
        isTitleCenter: true,
        actionsWidget: [
          CircleIconButton(
            onTap: () {
              String extention = widget.url.split('.').last;
              if (isSubmitLoading == false) {
                downloadImageToDownloads(widget.url);
              }
            },
            backgroundColor: MyColor.primaryColor,
            child: const Icon(Icons.download, color: MyColor.colorWhite),
          ),
          const SizedBox(width: Dimensions.space10)
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: isSubmitLoading ? 0.3 : 1,
            child: InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: widget.url.toString(),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      boxShadow: const [],
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.contain)),
                ),
                placeholder: (context, url) => SizedBox(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Dimensions.mediumRadius),
                    child: Center(
                      child: SpinKitFadingCube(
                        color: MyColor.getPrimaryColor().withValues(alpha: 0.3),
                        size: Dimensions.space20,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => SizedBox(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Dimensions.mediumRadius),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        color: MyColor.colorGrey.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isSubmitLoading) ...[
            Container(
              height: context.height,
              width: context.width,
              color: MyColor.primaryColor.withValues(alpha: 0.1),
              child: const SpinKitFadingCircle(
                color: MyColor.primaryColor,
              ),
            )
          ]
        ],
      ),
    );
  }
}
