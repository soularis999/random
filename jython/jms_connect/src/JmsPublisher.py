from javax.naming import Context, InitialContext, NamingException
from java.util import Properties
from javax.jms import Session
from com.ibm.mq import MQQueueConnectionFactory, JMSC
from java.util.logging import Logger, Level
import sys
import os.path
import weblogic

log = Logger.getLogger("Publisher")

########################### Publisher class begins #################################
class JmsPublisher:
    """ Constructor takes the factory name and queue name to create a connection
    Also optional are server url in case connection is done remotely and factory class
    to use in case it is specific to the implementation of JMS"""
    def __init__(self, connectionFactory, queue):
        self.__connection = None
        self.__session = None
        self.__producer = None
        self.__cf = connectionFactory
        self.__q = queue
        
        self.__configure()
        
    def __configure(self):
        try:
            self.__connection = self.__cf.createConnection()
            self.__session = self.__connection.createSession(False, Session.AUTO_ACKNOWLEDGE)
            self.__producer = self.__session.createProducer(self.__q)
        except JMSException, e:
            log.log(Level.WARNING, "could not connect to queue...", e)
            self.close()
            raise e
  
    """ Method to disconnect from queue """
    def close(self):
        if self.__session != None:
            try:
                self.__session.close()
            except Exception, e:
                log.log(Level.WARNING, "System error closing session:", e)

        if self.__connection != None:
            try:
                self.__connection.close()
            except Exception, e:
                log.log(Level.WARNING, "System error closing connection: ", e)
      
    """ Method is taking a text of the message to send and sends it using configurations 
    passed in constructor """
    def sendMessage(self, message):
        try:
            if len(message) < 1: return
            
            m = self.__session.createTextMessage()
            m.setText(message)
            self.__producer.send(m)
        except Exception, e:
            log.log(Level.WARNING, "could not send message...", err)
            raise e

########################### Publisher class is done #################################

def getInitialContext(serverUrl=None, initialContextFactoryName=None):
        # Create properties for InitialContext
    prop = Properties()
    if initialContextFactoryName != None:
        prop.put(Context.INITIAL_CONTEXT_FACTORY, initialContextFactoryName)
    
    if serverUrl != None:
        prop.put(Context.PROVIDER_URL, serverUrl)
        
    # Create initialContext
    jndiContext = None
    try:
        log.log(Level.INFO, "Creating context for %s:%s"%(initialContextFactoryName, serverUrl))
        jndiContext = InitialContext(prop)
        log.log(Level.INFO, "initial context was found!!!")
    except NamingException, e:
        log.log(Level.WARNING, "initial context could not be found...", e)
        raise e
    
    return jndiContext
   
def getWLConnectionFactory(factoryName, initialContext):
    if initialContext == None:
        raise SystemException, "Initial context was not provided..."
    # get connection factory to create connections
    factory = None
    try:
        log.log(Level.INFO, "Getting factory with following name: %s"%(factoryName))
        factory = initialContext.lookup(factoryName)
        log.log(Level.INFO, "factory was found!!!")
    except Exception, e:
        log.log(Level.WARNING, "factory could not be found...", e)
        raise e
    
    return factory

def getWLQueue(queueName, initialContext):
    if initialContext == None:
        raise SystemException, "Initial context was not provided..."
    # get queue / topic
    queue = None
    try:
        log.log(Level.INFO, "Getting queue with following name: %s"%(queueName))
        queue = initialContext.lookup(queueName)
        log.log(Level.INFO, "queue was found!!!")
    except Exception, e:
        log.log(Level.WARNING, "queue could not be found...", e)
        raise e
    
    return queue

def getMQConnectionFactory(serverUrl=None, port=None, queueManager=None):
    factory = MQQueueConnectionFactory()
    if "localhost" == hostName or "127.0.0.1" == hostName:
        factory.setTransportType( JMSC.MQJMS_TP_BINDINGS_MQ )
    else:
        factory.setTransportType( JMSC.MQJMS_TP_CLIENT_MQ_TCPIP )
    
    factory.setQueueManager( queueManager );
    factory.setHostName( serverUrl );
    factory.setPort(port);
    
####################### Connection setup is done #####################################    
def usage():
    print """Usage: jython jmstest.py [options] 
        [options]: -cqsif
        c: connection factory name to use (Required)
        q: queue name to connect to (Requeired)
        s: server name to connect to (Optional - if jms server is used)
        i: initial context factory class name (Optional - if jms server is used)
        f: file name to read for messages
        """

def parse(args):
    factory = None
    queue = None
    server = None
    initContext = None
    file = None

    for i in range(len(args)):
        key = args[i]
        val = None
        if i+1 < len(args):
            val = args[i+1]
        
        if key == "-c" and val not in ("-q", "-s", "-f", "-i"):
            factory = val
        elif key == "-q" and val not in ("-c", "-s", "-f", "-i"):
            queue = val
        elif key == "-s" and val not in ("-c", "-q", "-f", "-i"):
            server = val
        elif key == "-i" and val not in ("-c", "-q", "-s", "-i"):
            initContext = val
        elif key == "-f" and val not in ("-c", "-q", "-s", "-f"):
            file = val
    
    return (factory, queue, server, initContext, file)

def readMessages(file):
    if file == None or not os.path.exists(file):
        return []
    
    f = None
    try:
        f = open(file, 'r')
        lines = f.readlines();
    finally:
        if f != None:
            f.close()
    
    return lines

""" run main block """
if __name__ == "__main__":
    factory = None
    queue = None
    server = None
    initContext = None
    file = None
    
    try:
        log.log(Level.INFO, "Params: %s"%(",".join(sys.argv[1:])))
        factory, queue, server, initContext, file = parse(sys.argv[1:])
        
        log.log(Level.INFO, 
                "Factory:%s, Queue:%s, Server:%s, initContextFactory: %s, File:%s"
                %(factory,queue,server,initContext,file))
        if factory == None or queue == None:
            raise SystemError, "Factory or queue is null"
    except Exception,e:
        log.log(Level.SEVERE, "Error while parsing params: %s"%(e))
        usage()
        sys.exit(1)
    
    pub = None
    try:
        iContext = getInitialContext(server, initContext)
        factory = getWLConnectionFactory(factory, iContext)
        queue = getWLQueue(queue, iContext)
        pub = JmsPublisher(factory,queue)
        messages = readMessages(file)
        for message in messages:
            pub.sendMessage(message)
        
        log.log(Level.INFO, "sent %i messages..."%(len(messages)))
    except Exception, e:
        log.log(Level.SEVERE, "Error happend: %s" % (e))
        
    if pub != None:
        pub.close()
    
    sys.exit(0)
