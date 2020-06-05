import java.util.logging.Level;
import java.util.logging.Logger;

class Log {

    private final static Logger LOGGER = Logger.getLogger(Log.class.getName());

    static void severe(String mess,Throwable e) {
        LOGGER.log(Level.SEVERE,mess,e);
        System.exit(4);
    }

    static void info(String mess) {
        LOGGER.info(mess);
    }
}
