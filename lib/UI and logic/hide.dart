import 'dart:io';
import 'package:calculator/database/Photo.dart';
import 'package:calculator/database/databas.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Hide extends StatefulWidget {
  const Hide({Key? key}) : super(key: key);

  @override
  State<Hide> createState() => _HideState();
}

class _HideState extends State<Hide> {
  List<File?> _profilePicture = [];
  final picker = ImagePicker();

  DatabaseHelper? dbhelper;

  late Future<List<DataModel>> noteslist;

  //for the imageview
  int currentImageIndex = 0;
  List<PhotoViewGalleryPageOptions> gallteryItems = [];

  @override
  void initState() {
    super.initState();
    dbhelper = DatabaseHelper();
    loadData();
  }

  loadData() async {
    noteslist = dbhelper!.getNOteList();
  }

  Future<void> pickImages() async {
    final pickedFile = await picker.pickMultiImage();
    try {
      if (pickedFile.isNotEmpty) {
        setState(() {
          _profilePicture.clear();
          for (var i = 0; i < pickedFile.length; i++) {
            _profilePicture.add(File(pickedFile[i].path));
          }
          saveImagesToDatabase();
        });
      } else if (_profilePicture.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No image is selected")));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveImagesToDatabase() async {
    try {
      for (var i = 0; i < _profilePicture.length; i++) {
        final imageFile = _profilePicture[i];
        if (imageFile != null) {
          final bytes = await imageFile.readAsBytes();
          final imageModel = DataModel(imageBytes: bytes);
          await dbhelper!.insert(imageModel);
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Images saved to the database")),
      );
      loadData(); // Reload the list of images
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 43, 42, 42),
        title: const Text(
          "Hide",
          style: TextStyle(
              fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              pickImages();
            },
            child: const Icon(
              Icons.add_box,
              color: Colors.white,
              size: 40,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: noteslist,
        builder: (context, AsyncSnapshot<List<DataModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No images!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.red),
              ),
            );
          } else {
            //to clear all the previous items
            gallteryItems.clear();

            // building the widget
            for (int i = 0; i < snapshot.data!.length; i++) {
              gallteryItems.add(PhotoViewGalleryPageOptions(
                  imageProvider: MemoryImage(snapshot.data![i].imageBytes),
                  minScale: PhotoViewComputedScale,
                  maxScale: PhotoViewComputedScale.covered * 2));
            }
          }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: snapshot.data!.length + _profilePicture.length,
              itemBuilder: (BuildContext context, int index) {
                if (index < snapshot.data!.length) {
            return GestureDetector(
              onTap: () {
                // Open the image in a full-screen gallery
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                      imageProvider: MemoryImage(snapshot.data![index].imageBytes),
                      initialIndex: index,
                      galleryItems: snapshot.data!
                          .map((data) => PhotoViewGalleryPageOptions(
                                imageProvider: MemoryImage(data.imageBytes),
                                minScale: PhotoViewComputedScale.contained,
                                maxScale: PhotoViewComputedScale.covered * 2,
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'image$index', // Unique tag for each image
                child: Image.memory(snapshot.data![index].imageBytes, fit: BoxFit.cover),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                // Open the image in a full-screen gallery
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                      imageProvider: FileImage(_profilePicture[index - snapshot.data!.length]!),
                      initialIndex: index - snapshot.data!.length,
                      galleryItems: _profilePicture
                          .map((file) => PhotoViewGalleryPageOptions(
                                imageProvider: FileImage(file!),
                                minScale: PhotoViewComputedScale.contained,
                                maxScale: PhotoViewComputedScale.covered * 2,
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'image${index - snapshot.data!.length}', // Unique tag for each image
                child: Image.file(_profilePicture[index - snapshot.data!.length]!, fit: BoxFit.cover),
              ),
            );
          }
        },
      );
  })
    );
  }
}


class FullScreenImage extends StatelessWidget {
  final ImageProvider imageProvider;
  final int initialIndex;
  final List<PhotoViewGalleryPageOptions> galleryItems;

  FullScreenImage({
    required this.imageProvider,
    required this.initialIndex,
    required this.galleryItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 43, 42, 42),
        title: const Text("Full-Screen Image", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        child: PhotoViewGallery.builder(
          itemCount: galleryItems.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: galleryItems[index].imageProvider,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
          pageController: PageController(initialPage: initialIndex),
        ),
      ),
    );
  }
}