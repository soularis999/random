call classpath.bat

jython src\jms.py -c ConnectionFactory -q Queue -s t3://localhost:7001/ -i weblogic.jndi.WLInitialContextFactory -f "messages.txt"

pause