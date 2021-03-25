#!/usr/bin/env bash
PUSH=1
ARTIFACT=graalvm-native
MAINCLASS=org.pkg.apinative.Native
VERSION=1.0-SNAPSHOT
#FEATURE=../../../../spring-graal-native/target/spring-graal-native-0.6.1.BUILD-SNAPSHOT.jar

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

rm -rf target
mkdir -p target/native-image

echo "Packaging $ARTIFACT with Maven"
./mvnw -DskipTests package > target/native-image/output.txt

JAR="$ARTIFACT-$VERSION.jar"
rm -f $ARTIFACT
echo "Unpacking $JAR"
cd target/native-image
jar -xvf ../$JAR >/dev/null 2>&1
mkdir -p BOOT-INF/classes BOOT-INF/lib
cp -R META-INF BOOT-INF/classes

LIBPATH=`find BOOT-INF/lib | tr '\n' ':'`
CP=BOOT-INF/classes:$LIBPATH

GRAALVM_VERSION=`native-image --version`
echo "Compiling $ARTIFACT with $GRAALVM_VERSION"
{ time native-image \
  --verbose \
  --no-server \
  --no-fallback \
  --initialize-at-build-time \
  --initialize-at-run-time=org.fusesource.leveldbjni \
  --initialize-at-run-time=org.semux \
  --initialize-at-run-time=org.ethereum \
  --initialize-at-run-time=io.icte.go \
  --initialize-at-build-time=org.semux.api.v2 \
  -H:TraceClassInitialization=true \
  -H:Name=$ARTIFACT \
  -H:EnableURLProtocols=http \
  -H:EnableURLProtocols=https \
  -H:IncludeResources="logging.properties|application.properties" \
  -H:+ReportUnsupportedElementsAtRuntime \
  -H:-AllowVMInspection \
  -H:+ReportExceptionStackTraces \
  -H:-InternalSymbolsAreGlobal \
  -R:-InstallSegfaultHandler \
  -Dspring.graal.verbose=true \
  -Dspring.graal.remove-unused-autoconfig=true \
  -Dspring.graal.remove-yaml-support=true \
  -cp $CP $MAINCLASS >> output.txt ; } 2>> output.txt

if [[ -f $ARTIFACT ]]
then
  printf "${GREEN}SUCCESS${NC}\n"
  mv ./$ARTIFACT ..
  exit 0
else
  cat output.txt
  printf "${RED}FAILURE${NC}: an error occurred when compiling the native-image.\n"
  exit 1
fi

