import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/loading/loading.dart';
import 'package:recyclo/menu/view/main_menu_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => PreloadCubit(
              Images(prefix: ''),
            )..loadSequentially(),
          ),
        ],
        child: const LoadingPage(),
      ),
    );
  }

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<void> onPreloadComplete(BuildContext context) async {
    final navigator = Navigator.of(context);
    await Future<void>.delayed(AnimatedProgressBar.intrinsicAnimationDuration);
    if (!mounted) {
      return;
    }
    await navigator.pushReplacement<void, void>(MainMenuPage.route());
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SemanticsService.announce(context.l10n.loading(''), TextDirection.ltr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PreloadCubit, PreloadState>(
      listenWhen: (prevState, state) => !prevState.isComplete && state.isComplete,
      listener: (context, state) => onPreloadComplete(context),
      child: const Scaffold(
        backgroundColor: FlutterGameChallengeColors.primary1,
        body: Center(
          child: _LoadingInternal(),
        ),
      ),
    );
  }
}

class _LoadingInternal extends StatelessWidget {
  const _LoadingInternal();

  @override
  Widget build(BuildContext context) {
    final primaryTextTheme = Theme.of(context).primaryTextTheme;
    final l10n = context.l10n;

    return BlocBuilder<PreloadCubit, PreloadState>(
      builder: (context, state) {
        final loadingLabel = l10n.loadingPhaseLabel(state.currentLabel);
        final loadingMessage = l10n.loading(loadingLabel);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: AnimatedProgressBar(
                progress: state.progress,
                backgroundColor: FlutterGameChallengeColors.aboutAppBackground,
                foregroundColor: FlutterGameChallengeColors.gamesBackground,
              ),
            ),
            Text(
              loadingMessage,
              style: primaryTextTheme.bodySmall!.copyWith(
                color: FlutterGameChallengeColors.primary1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        );
      },
    );
  }
}
