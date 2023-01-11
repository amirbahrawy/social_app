import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_data_model.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return ConditionalBuilder(
              condition: state is! AppGetAllUsersLoadingState,
              builder: (context) {
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      height: 1.0,
                      width: double.infinity,
                      color: Colors.grey[300],
                    );
                  },
                  itemBuilder: (context, index) =>
                      _buildChatItem(cubit.users[index],context),
                  itemCount: cubit.users.length,
                );
              },
              fallback: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ));
        },
        listener: (context, state) {});
  }

  Widget _buildChatItem(UserDataModel model,context) {
    return InkWell(
      onTap: () {
        navigateTo(context, ChatDetailsScreen(model));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Row(
          children: [
            CircleAvatar(
                radius: 25.0, backgroundImage: NetworkImage(model.image)),
            const SizedBox(
              width: 15.0,
            ),
            Text(model.userName)
          ],
        ),
      ),
    );
  }
}
