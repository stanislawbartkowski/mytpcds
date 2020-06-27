import com.sun.security.auth.callback.TextCallbackHandler;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.security.UserGroupInformation;

import javax.security.auth.Subject;
import javax.security.auth.login.LoginContext;
import javax.security.auth.login.LoginException;
import java.io.IOException;

public class HadoopAuth {

    public static void HadoopAuth() throws LoginException, IOException {
        LoginContext lc = new LoginContext("Client", new TextCallbackHandler());
        lc.login();
        Subject sub = lc.getSubject();
        Configuration conf = new Configuration();
        conf.set("hadoop.security.authentication", "Kerberos");
        UserGroupInformation.setConfiguration(conf);
        UserGroupInformation.loginUserFromSubject(sub);
    }

}
