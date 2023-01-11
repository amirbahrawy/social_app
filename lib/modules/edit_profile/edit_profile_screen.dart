import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: ((context, state) {
        var cubit = AppCubit.get(context);
        var userModel = cubit.userModel;
        var profileImage = cubit.profileImage;
        var coverImage = cubit.coverImage;
        nameController.text = userModel!.userName;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone;

        return Scaffold(
          appBar: DefaultAppBar(
            title: 'Edit Profile',
            actions: [
              defaultTextButton(
                  function: () {
                    cubit.updateUser(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                  },
                  text: 'Update')
            ],
          ),
          body: Column(
            children: [
              if (state is AppUpdateUserLoadingState ||
                  state is AppUploadProfileImageLoadingState ||
                  state is AppUploadCoverImageLoadingState
              )
                const SizedBox(height: 10.0, child: LinearProgressIndicator()),
              SizedBox(
                height: 190,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                            height: 140.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(
                                  4.0,
                                ),
                                topRight: Radius.circular(
                                  4.0,
                                ),
                              ),
                              image: DecorationImage(
                                image: coverImage == null
                                    ? NetworkImage(userModel.cover)
                                    : Image.file(coverImage).image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 20.0,
                              child: IconButton(
                                  onPressed: () {
                                    cubit.getCoverImage();
                                  },
                                  icon: const Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CircleAvatar(
                          radius: 64.0,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundImage: profileImage == null
                                ? NetworkImage(userModel.image)
                                : Image.file(profileImage).image,
                          ),
                        ),
                        CircleAvatar(
                          radius: 20.0,
                          child: IconButton(
                              onPressed: () {
                                cubit.getProfileImage();
                              },
                              icon: const Icon(
                                IconBroken.Camera,
                                size: 16.0,
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              defaultFormField(
                  controller: nameController,
                  type: TextInputType.name,
                  validate: (String? value) {
                    if (value != null && value.isEmpty) {
                      return 'name must not be empty';
                    }
                    return null;
                  },
                  label: 'Name',
                  prefix: IconBroken.User),
              const SizedBox(
                height: 10.0,
              ),
              defaultFormField(
                  controller: bioController,
                  type: TextInputType.text,
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'bio must not be empty';
                    }
                    return null;
                  },
                  label: 'Bio',
                  prefix: IconBroken.Info_Circle),
              const SizedBox(
                height: 10.0,
              ),
              defaultFormField(
                  controller: phoneController,
                  type: TextInputType.phone,
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'Phone number must not be empty';
                    }
                    return null;
                  },
                  label: 'Phone',
                  prefix: IconBroken.Call),
            ],
          ),
        );
      }),
      listener: (context, state) {},
    );
  }
}
