import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';

class Requirements {
  static const newspaper = ArtifactRequirements(
    paper: 42,
    plastic: 8,
  );

  static const shampoo = ArtifactRequirements(
    paper: 4,
    plastic: 48,
    organic: 82,
  );

  static const plant = ArtifactRequirements(
    paper: 12,
    plastic: 80,
    organic: 144,
  );

  static const laptop = ArtifactRequirements(
    paper: 40,
    plastic: 240,
    glass: 212,
    electronics: 550,
  );

  static const car = ArtifactRequirements(
    paper: 80,
    plastic: 440,
    organic: 92,
    glass: 212,
    electronics: 338,
  );

  static const house = ArtifactRequirements(
    paper: 520,
    plastic: 682,
    organic: 244,
    glass: 350,
    electronics: 420,
  );
}
