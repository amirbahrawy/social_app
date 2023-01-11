import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: DefaultAppBar(
              title: 'Create Post',
              actions: [
                defaultTextButton(
                    function: () {
                      var now = DateTime.now();
                      if (cubit.postImage == null) {
                        cubit.createPost(
                            text: _textEditingController.text,
                            dateTime: now.toString());
                      } else {
                        cubit.uploadImagePost(
                            text: _textEditingController.text,
                            dateTime: now.toString());
                      }
                    },
                    text: 'Post')
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (state is AppCreatePostLoadingState)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: LinearProgressIndicator(),
                    ),
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 25.0,
                          backgroundImage:
                              NetworkImage(cubit.userModel!.image)),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(child: Text(cubit.userModel!.userName)),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                          hintText: 'what is on your mind ... ',
                          border: InputBorder.none),
                    ),
                  ),
                  if (cubit.postImage != null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          height: 140.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: DecorationImage(
                              image: Image.file(cubit.postImage!).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 15.0,
                            child: IconButton(
                                onPressed: () {
                                  cubit.removePostImage();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 12.0,
                                )),
                          ),
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              cubit.getPostImage();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(IconBroken.Image),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text('Add Photos')
                              ],
                            )),
                      ),
                      Expanded(
                          child: TextButton(
                              onPressed: () {}, child: const Text('# tags')))
                    ],
                  )
                ],
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
