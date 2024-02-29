class ArtifactModel {
  ArtifactModel({
    required this.requirements,
    required this.artifactType,
    required this.status,
    this.uuid,
  });

  final ArtifactRequirements requirements;
  final ArtifactStatus status;
  final ArtifactType artifactType;
  final String? uuid;

  ArtifactModel copyWith(
    ArtifactStatus status,
    String uuid,
  ) {
    return ArtifactModel(
      requirements: requirements,
      artifactType: artifactType,
      status: status,
      uuid: uuid,
    );
  }

  bool get isCrafted =>
      status == ArtifactStatus.crafted ||
      status == ArtifactStatus.addedToWallet;
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

  ArtifactsModel copyWith({
    ArtifactModel? shampoo,
    ArtifactModel? car,
    ArtifactModel? plant,
    ArtifactModel? laptop,
    ArtifactModel? house,
    ArtifactModel? newspaper,
  }) {
    return ArtifactsModel(
      shampoo: shampoo ?? this.shampoo,
      car: car ?? this.car,
      plant: plant ?? this.plant,
      laptop: laptop ?? this.laptop,
      house: house ?? this.house,
      newspaper: newspaper ?? this.newspaper,
    );
  }
}

enum ArtifactType {
  newspaper,
  shampoo,
  plant,
  laptop,
  car,
  house,
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
