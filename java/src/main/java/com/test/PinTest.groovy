package com.test

import com.sun.jna.*
import com.sun.jna.ptr.LongByReference

class PosixJNAAffinity {

    private interface CLibrary extends Library {
        public static final CLibrary INSTANCE = (CLibrary) Native.loadLibrary("c", CLibrary.class)

        int sched_setaffinity(pid, cpusetsize, cpuset) throws LastErrorException;

        int sched_getaffinity(pid, cpusetsize, cpuset) throws LastErrorException;

        int sysctlbyname(varName, corecount, len, v1, v2)
    }

    long getAffinity() {
        final CLibrary lib = CLibrary.INSTANCE
        final LongByReference cpuset = new LongByReference(0L)
        final LongByReference len = new LongByReference((int) Long.SIZE / 8)
        try {
            final int ret = lib.sched_getaffinity(0, Long.SIZE / 8, cpuset)
//            final int ret = lib.sysctlbyname("machdep.cpu.core_count", cpuset, len, 0, 0)
            if (ret < 0)
                throw new IllegalStateException("sched_getaffinity((" + Long.SIZE / 8 + ") , &(" + cpuset + ") ) return " + ret)
            return cpuset.getValue()
        } catch (LastErrorException e) {
            throw new IllegalStateException("sched_getaffinity((" + Long.SIZE / 8 + ") , &(" + cpuset + ") ) errorNo=" + e.getErrorCode(), e)
        }
    }

    long getAffinityMac() {
        final CLibrary lib = CLibrary.INSTANCE
        final LongByReference cpuset = new LongByReference(0L)
        final LongByReference len = new LongByReference((int) Long.SIZE / 8)
        try {
            final int ret = lib.sched_getaffinity(0, Long.SIZE / 8, cpuset)
//            final int ret = lib.sysctlbyname("machdep.cpu.core_count", cpuset, len, 0, 0)
            if (ret < 0)
                throw new IllegalStateException("sched_getaffinity((" + Long.SIZE / 8 + ") , &(" + cpuset + ") ) return " + ret)
            return cpuset.getValue()
        } catch (LastErrorException e) {
            throw new IllegalStateException("sched_getaffinity((" + Long.SIZE / 8 + ") , &(" + cpuset + ") ) errorNo=" + e.getErrorCode(), e)
        }
    }

    void setAffinity(final long affinity) {
        final CLibrary lib = CLibrary.INSTANCE
        try {
            final int ret = lib.sched_setaffinity(0, Long.SIZE / 8, new LongByReference(affinity))
            if (ret < 0) {
                throw new IllegalStateException("sched_setaffinity((" + Long.SIZE / 8 + ") , &(" + affinity + ") ) return " + ret);
            }
        } catch (LastErrorException e) {
            throw new IllegalStateException("sched_getaffinity((" + Long.SIZE / 8 + ") , &(" + affinity + ") ) errorNo=" + e.getErrorCode(), e);
        }
    }
}


def instance = new PosixJNAAffinity()
try {
    println instance.getAffinity()

//    println instance.setAffinity(8)
} catch (UnsatisfiedLinkError e) {
    e.printStackTrace()
}

