package org.pkg.implnative;

import org.graalvm.nativeimage.c.function.CEntryPoint;
import org.graalvm.word.Pointer;
import sun.misc.Unsafe;

import java.lang.reflect.Field;

public final class NativeImpl {

  @CEntryPoint(name = "Java_org_pkg_apinative_Native_run")
  public static int run(
      Pointer jniEnv,
      Pointer clazz,
      @CEntryPoint.IsolateThreadContext long isolateId,
      long addr,
      int size) {
    System.out.println("NativeImpl_run( " + addr + ",  " + size + " );");

    return 11235813;
  }

  @CEntryPoint(
      name = "Java_org_pkg_apinative_Native_createIsolate",
      builtin = CEntryPoint.Builtin.CREATE_ISOLATE)
  public static native long createIsolate();
}
