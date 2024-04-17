import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import '../Controller/photo_controller.dart';

class PhotoScreen extends StatelessWidget {
  PhotoScreen({super.key});

  final photoController = Get.put(PhotoController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBar(
              title: const Text('Photos',style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.purple,
            ),
            body: Obx(
              () => Padding(
                padding: const EdgeInsets.all(5.0),
                child: GridView.builder(
                  controller: photoController.scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 6.0,
                  ),
                  itemCount: photoController.photoData.length,
                  itemBuilder: (context, index) {
                    return photoData(
                      context,
                      index: index,
                    );
                  },
                )
              ),
            ),
          );
  }

  Widget photoData(BuildContext context, {required int index}) {
    final itemData = photoController.photoData[index];
    return GestureDetector(
      onTap: () {
        photoPreview(
          context,
          itemData.largeImageURL ?? '',
        );
      },
      child:Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image.network(
              itemData.webformatURL ?? '',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.photo_album_sharp,
                  size: 50,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)),color: Colors.black54),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.thumb_up_alt_outlined,
                              size: 18,
                              color: Colors.white,
                            ).paddingOnly(right: 5),
                            const SizedBox(height: 3,),
                            Text(
                              (itemData.likes ?? 0).toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)),color: Colors.black54,),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.visibility_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 3,),
                          Text(
                            (itemData.views ?? 0).toString(),
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis, color: Colors.white
                            ),

                          ).paddingOnly(right: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  // To open image in fullscreen
  void photoPreview(BuildContext context, String imageUrl) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Preview",style: TextStyle(color:Colors.white)),
            foregroundColor: Colors.white,
            backgroundColor: Colors.purple,
          ),
          backgroundColor: Colors.white,
          body: Center(
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.white),
              imageProvider: NetworkImage(imageUrl),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
              initialScale: PhotoViewComputedScale.contained,
            ),
          ),
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
    );
  }
}
