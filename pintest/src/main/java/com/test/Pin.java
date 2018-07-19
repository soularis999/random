package com.test;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.ptr.ByReference;

public class Pin {

    private final CLibrary lib = CLibrary.INSTANCE;

    private interface CLibrary extends Library {
        CLibrary INSTANCE = (CLibrary)
                Native.loadLibrary("c", CLibrary.class);

        int sched_getaffinity(int pid, int cpusetsize, CpuSetT cpuset);

        int sched_setaffinity(int pid, int cpusetsize, CpuSetT cpuset);
    }

    /**
     * THe code currently only works with "current" process id. Each thread has it's own pid and thus passing 0 to
     * the set and get affinity will work on that pid. we can expand this to actually provide the pid.
     * @param setT
     */
    public void setAffinity(CpuSetT setT) {
        lib.sched_setaffinity(0, 128, setT);
    }

    public CpuSetT getAffinity() {
        CpuSetT cpuSetT = new CpuSetT();
        lib.sched_getaffinity(0, 128, cpuSetT);
        return cpuSetT;
    }

    /**
     * This class represents a 128 byte bitmetrix that will be passed to the linux c finction to pin the
     * threads to the cores. Each core in the cpu architecture is represented as 1 bit in the metrix. Thus
     * each attached byte will represent 8 cores!
     *
     * By setting a byte the code can pin the particular process ID to up to 8 cores.
     */
    public static class CpuSetT extends ByReference {
        public CpuSetT() {
            super(128);
        }

        public byte get(int offset) {
            return super.getPointer().getByte(offset);
        }

        public void set(int offset, byte val) {
            super.getPointer().setByte(offset, val);
        }

        public void clear() {
            for (int i = 0; i < 128; i++) {
                set(i, (byte) 0);
            }
        }
    }
}
