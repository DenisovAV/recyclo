import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/artifact_details/widgets/artifact_details/artifact_details_mobile.dart';
import 'package:recyclo/artifact_details/widgets/artifact_details/artifact_details_tv.dart';
import 'package:recyclo/artifacts/cubit/artifacts_cubit.dart';
import 'package:recyclo/common/extensions/platform/extended_platform.dart';
import 'package:recyclo/service_provider.dart';

class ArtifactDetails extends StatelessWidget {
  const ArtifactDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ArtifactsCubit>(create: (_) => ServiceProvider.get()),
      ],
      child: ExtendedPlatform.isTv
          ? const ArtifactDetailsTv()
          : const ArtifactDetailsMobile(),
    );
  }
}
