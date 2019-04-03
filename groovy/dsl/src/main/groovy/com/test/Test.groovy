package com.test

class Test {
    static void main(String[] args) {
        runArchitectureRules(new File(Test.class.getClassLoader().getResource("struct.model").getFile()))
    }

    static void runArchitectureRules(File dsl) {

        def dslScript = new GroovyShell().parse(dsl.text)

        def buffer = new StringBuffer()

        dslScript.metaClass = createEMC(dslScript.class, {

            ExpandoMetaClass emc ->

                emc.struct = {

                    Closure cl ->

                        cl.delegate = new StructDelegate(buffer)
                        cl.resolveStrategy = Closure.DELEGATE_FIRST

                        cl()
                }
        })

        dslScript.run()

        println buffer

    }

    static ExpandoMetaClass createEMC(Class clazz, Closure cl) {

        ExpandoMetaClass emc = new ExpandoMetaClass(clazz, false)

        cl(emc)

        emc.initialize()

        return emc

    }
}


def class StructDelegate {
    def buffer

    StructDelegate(buffer) {
        this.buffer = buffer
    }

    def methodMissing(String name, def args) {
        buffer.append("methodMissing $name->${args}\n")
        return this
    }

    def propertyMissing(String name) {
        buffer.append("propertyMissing $name\n")
        return this
    }

    def propertyMissing(String name, def arg) {
        def data = arg ? arg.join(',') : ""
        buffer.append("propertyMissing $name->${data}\n")
        return this
    }
}