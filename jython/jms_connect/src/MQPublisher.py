from javax.naming import Context, InitialContext, NamingException
from java.util import Properties
from java.util.logging import Logger, Level
from com.ibm.mq import MQQueueManager, MQMessage, MQPutMessageOptions

log = Logger.getLogger("Publisher")
    
class MQPublisher:
    """ Constructor takes the factory name and queue name to create a connection
    Also optional are server url in case connection is done remotely and factory class
    to use in case it is specific to the implementation of JMS"""
    def __init__(self):

        MQQueueConnectionFactory factory = new MQQueueConnectionFactory();

        if( "localhost".equals(hostName)
        ||  "127.0.0.1".equals(hostName) ) {
            factory.setTransportType( JMSC.MQJMS_TP_BINDINGS_MQ );
        }
        else {
            factory.setTransportType( JMSC.MQJMS_TP_CLIENT_MQ_TCPIP );
        }

        factory.setQueueManager( queueManager );
        factory.setHostName( hostName );
        //factory.setChannel( channel );
        factory.setPort( Integer.parseInt( com.cme.fec.util.Configuration.getValue("fec.etp.server.mq.listenport") ) );
        fConnection = factory.createQueueConnection();
        fSession = fConnection.createQueueSession( false, Session.AUTO_ACKNOWLEDGE );
        fQueue = fSession.createQueue( queue );
        fReceiver = fSession.createReceiver( fQueue );
        fReceiver.setMessageListener( this );
        fConnection.setExceptionListener( this );
        
    """ Method to disconnect from queue """
    def close(self):
        if self.__qMgr != None:
            try:
                self.__qMgr.close()
            except Exception, e:
                log.log(Level.WARNING, "System error closing connection: ", e)
      
    """ Method is taking a text of the message to send and sends it using configurations 
    passed in constructor """
    def sendMessage(self, message):
        try:
            if len(message) < 1: return
            
            m = MQMessage()
            m.writeUTF(message)
            
            pmo = MQPutMessageOptions()
            self.__queue.put(m, pmo)
            
        except Exception, e:
            log.log(Level.WARNING, "could not send message...", err)
            raise e
