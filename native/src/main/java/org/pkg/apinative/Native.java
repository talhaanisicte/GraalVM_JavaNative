package org.pkg.apinative;

import java.io.IOException;

public class Native {

  private void nativeMethod() {

    System.out.println("Before createIsolate() ");

    final long iso = createIsolate();

    System.out.println("Executed isolate - " + iso);

    final long addr = Long.MAX_VALUE;
    final int size = Integer.MAX_VALUE;

    System.out.println("Before run() ");

    final int ret = run(iso, addr, size);

    System.out.println("After run() returned - " + ret);
  }

  private static void usage() {
    throw new RuntimeException("usage:" + "\r\n\r\nProvide full path to java native shared library\r\n\r\n");
  }

  public static void main(String[] args) {
    if (args.length == 0) {
      usage();
      return;
    }
    final String fullPath = args[0];

    System.out.println("Loading shared library...");
    System.out.println(fullPath);

    System.load(fullPath);

    Native nativeObj = new Native();

    nativeObj.nativeMethod();

    try {
      System.in.read();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  private static native long createIsolate();

  private static native int run(long isolateThread, long addr, int size);
}
