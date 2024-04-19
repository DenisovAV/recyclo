import 'package:recyclo/artifacts/artifacts_model.dart';

class Requirements {
  static const newspaper = ArtifactRequirements(
    paper: 9,
    plastic: 6,
  );

  static const shampoo = ArtifactRequirements(
    paper: 14,
    plastic: 12,
    organic: 18,
  );

  static const plant = ArtifactRequirements(
    paper: 20,
    plastic: 22,
    organic: 28,
  );

  static const laptop = ArtifactRequirements(
    paper: 32,
    plastic: 34,
    glass: 12,
    electronics: 24,
  );

  static const car = ArtifactRequirements(
    paper: 8,
    plastic: 32,
    organic: 4,
    glass: 40,
    electronics: 22,
  );

  static const house = ArtifactRequirements(
    paper: 22,
    plastic: 34,
    organic: 12,
    glass: 40,
    electronics: 52,
  );
}
