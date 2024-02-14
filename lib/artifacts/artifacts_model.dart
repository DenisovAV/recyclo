class ArtifactModel {
  ArtifactModel({
    required this.requirements,
    required this.status,
  });

  final ArtifactRequirements requirements;
  final ArtifactStatus status;
}

class ArtifactsModel {
  ArtifactsModel({
    required this.shampoo,
    required this.car,
    required this.plant,
    required this.laptop,
    required this.house,
    required this.newspaper,
  });

  final ArtifactModel shampoo;
  final ArtifactModel car;
  final ArtifactModel plant;
  final ArtifactModel laptop;
  final ArtifactModel house;
  final ArtifactModel newspaper;
}

enum ArtifactStatus {
  notEnoughResources,
  readyForCraft,
  crafted,
  addedToWallet,
}

class ArtifactRequirements {
  const ArtifactRequirements({
    this.plastic = 0,
    this.organic = 0,
    this.glass = 0,
    this.paper = 0,
    this.electronics = 0,
  });

  final int plastic;
  final int organic;
  final int glass;
  final int paper;
  final int electronics;
}
