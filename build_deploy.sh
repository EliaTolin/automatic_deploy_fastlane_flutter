echo "### START ###"

echo "### TESTS ###"
flutter test &&

echo "### CLEAN ###"
flutter clean && 

echo "### PUB GET ###"
flutter pub get &&

echo "### INCREMENT VERSION ###"
# Estrae la versione corrente dal file pubspec.yaml
VERSION=$(grep 'version: ' pubspec.yaml | sed 's/version: //' | tr -d '\n' | tr -d '\r' | cut -d" " -f1)

# Estrae la build e la minor versione
MAJOR=$(echo $VERSION | cut -d. -f1)
MINOR=$(echo $VERSION | cut -d. -f2)
PATCH=$(echo $VERSION | cut -d. -f3 | cut -d+ -f1)
BUILD=$(echo $VERSION | cut -d+ -f2)

# Incrementa la build e la minor versione
PATCH=$((PATCH + 1))
BUILD=$((BUILD + 1))

# Costruisce la nuova versione
NEW_VERSION="$MAJOR.$MINOR.$PATCH+$BUILD"

# Sostituisce la vecchia versione con la nuova nel file pubspec.yaml
sed -i '' "s/version: $VERSION/version: $NEW_VERSION/" pubspec.yaml &&

# Stampa la nuova versione
echo "FROM $VERSION TO $NEW_VERSION" &&

echo "### BUILD IPA ###"
flutter build ipa && 

echo "### BUILD APPBUNDLE ###"
flutter build appbundle && 

echo "### DEPLOY APPLE ###"
cd ios && 
fastlane ios release &&

cd .. && 

echo "### DEPLOY ANDROID ###"
cd android &&
fastlane android deploy &&

echo "### FINISH ###"
