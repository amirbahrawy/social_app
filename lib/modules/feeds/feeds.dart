import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/cubit/states.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return ConditionalBuilder(
              condition: cubit.posts.isNotEmpty,
              builder: (context) => SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          elevation: 10.0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          margin: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomStart,
                              children: [
                                const Image(
                                  image: NetworkImage(
                                      'https://img.freepik.com/free-photo/hands-reaching-each-other-color-year-2023_23-2149991018.jpg?w=740&t=st=1670452653~exp=1670453253~hmac=b575a7a2a3752ebaf8f94fad88cdcac5e0fab760925dd93668177817e7c6dd92'),
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: double.infinity,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Communicate with friends',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                buildPostItem(cubit.posts[index], context),
                            separatorBuilder: (c, i) => const SizedBox(
                                  height: 5.0,
                                ),
                            itemCount: cubit.posts.length),
                        const SizedBox(
                          height: 8.0,
                        )
                      ],
                    ),
                  ),
              fallback: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ));
        },
        listener: (context, state) {});
  }
}

Widget buildPostItem(PostModel model, context) => Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //personal information
            Row(
              children: [
                // profile image
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(model.image),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                //name and date
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //name and blue logo
                    Row(
                      children: [
                        Text(model.userName),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.blue,
                          size: 14.0,
                        )
                      ],
                    ),
                    // post date and time
                    Text(
                      model.dateTime,
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                )),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.more_horiz)),
              ],
            ),
            //separate line
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              height: 1.0,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            // post text
            Text(
              model.postText,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            //tags
/*
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  children: [
                    SizedBox(
                      height: 25.0,
                      child: MaterialButton(
                        onPressed: () {},
                        minWidth: 0,
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: const Text(
                          '#Flutter',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                      child: MaterialButton(
                        onPressed: () {},
                        minWidth: 0,
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: const Text(
                          '#Software',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                      child: MaterialButton(
                        onPressed: () {},
                        minWidth: 0,
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: const Text(
                          '#Mobile_development',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
*/
            if (model.postImage != null)
              //post image
              Container(
                height: 150,
                margin: const EdgeInsets.only(top: 10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(model.postImage!))),
              ),
            //number of likes and comments
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              IconBroken.Heart,
                              size: 19.0,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${model.likesNumber}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              IconBroken.Chat,
                              size: 19.0,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '0 comment',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            // make like and comment
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(
                              AppCubit.get(context).userModel!.image),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'write a comment ...',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                   ),
                ),
                InkWell(
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Heart,
                        size: 20.0,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Like',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black45),
                      ),
                    ],
                  ),
                  onTap: () {
                    AppCubit.get(context).likePost(model.postId!);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
