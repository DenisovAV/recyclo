import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/artifacts/cubit/artifacts_cubit.dart';
import 'package:recyclo/artifacts/widgets/artifacts_list/artifacts_list_page_mobile.dart';
import 'package:recyclo/artifacts/widgets/artifacts_list/artifacts_list_page_tv.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/service_provider.dart';

class ArtifactsListPage extends StatelessWidget {
  const ArtifactsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ArtifactsCubit>(create: (_) => ServiceProvider.get()),
      ],
      child: ExtendedPlatform.isTv
          ? const ArtifactsListPageTv()
          : const ArtifactsListPageMobile(),
    );
  }
}
