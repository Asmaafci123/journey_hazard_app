import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentsService {
  Future<PickedFile> getGalleryImage() async {
    return await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );
//    return await ImagePicker().getImage(source: ImageSource.gallery,);
  }

  Future<PickedFile> getCameraImage() async {
    return await ImagePicker().getImage(
      source: ImageSource.camera,
    );
  }

  Future<List<PlatformFile>> getMultiImages() async {
    FilePickerResult filesList = await FilePicker.platform.pickFiles(type: FileType.image);
    return filesList.files;
  }


  showChooseImageDialog() async {
    // TODO
  }
}

