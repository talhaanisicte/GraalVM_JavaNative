# README
This repository is calling createIsolate() and run(long,int) methods in java NativeImpl project 

##Build 
```./mvnw clean install -DskipTests && ./compile.sh```

##Run
```./target/graalvm-native /root/GraalVM_JavaNative/nativeImpl/target/libnativeimpl.so```
