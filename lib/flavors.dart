enum Flavor {
  dev,
  stg,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'petalytic Dev';
      case Flavor.stg:
        return 'petalytic Stg';
      case Flavor.prod:
        return 'petalytic';
    }
  }

}
