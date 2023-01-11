import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_data_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/color.dart';

import '../../shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserDataModel model;
  final TextEditingController messageController = TextEditingController();

  ChatDetailsScreen(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).getMessages(receiverId: model.uId);
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(model.image),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(model.userName)
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: state is! AppGetMessagesLoadingState,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                var message = cubit.messages[index];
                                var sendByMe = message.senderId != model.uId;
                                return sendByMe
                                    ? myItem(
                                        context,
                                        cubit.messages[index].text,
                                      )
                                    : receiverItem(
                                        context, cubit.messages[index].text);
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 15.0,
                                );
                              },
                              itemCount: cubit.messages.length)),
                      Container(
                        padding: const EdgeInsets.only(left: 5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(width: 1.0, color: Colors.grey)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: messageController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type your message here...'),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.sendMessage(
                                    receiverId: model.uId,
                                    dateTime: DateTime.now().toString(),
                                    msg: messageController.text);
                                messageController.clear();
                              },
                              icon: const Icon(IconBroken.Send),
                              color: defaultColor,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ));
        },
        listener: (context, state) {});
  }
}

Widget myItem(context, String text) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: defaultColor.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0))),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline6,
        )),
  );
}

Widget receiverItem(
  context,
  String text,
) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0))),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline6,
        )),
  );
}
