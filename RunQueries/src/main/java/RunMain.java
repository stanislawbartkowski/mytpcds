
import java.io.*;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.*;
import java.util.Optional;

import org.apache.commons.cli.*;

public class RunMain {

    private static void P(String s) {
        System.out.println(s);
    }

    private final static String urlO = "url";
    private final static String helpO = "help";
    private final static String userO = "user";
    private final static String passwordO = "password";
    private final static String statementO = "s";
    private final static String fileO = "f";
    private final static String outputO = "output";
    private final static String queryO = "query";
    private final static String headerO = "header";
    private final static String hadoopKerberosO = "hadoopKerberos";

    private static Connection connect(String url, String user, String password) throws SQLException {
        return DriverManager.getConnection(url, user, password);
        //return DriverManager.getConnection(url);
    }

    private static void printHelp(Options options, Optional<String> par, boolean notfound) {
        HelpFormatter formatter = new HelpFormatter();
        String header = "RunQueries";
        if (par.isPresent()) header = " " + par.get() + (notfound ? " not found in the arg list" : "");
        formatter.printHelp(header, options);
        System.exit(4);
    }

    private static void authenticateHadoop() throws ClassNotFoundException, NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        Class hadoopAuth = Class.forName("HadoopAuth");
        Method m = hadoopAuth.getDeclaredMethod("HadoopAuth", null);
        m.invoke(null, null);

    }

    public static void main(String[] args) {
        Options options = new Options();
        options.addOption(urlO, true, "JDBC URL string");
        options.addOption(helpO, false, "print this message");
        options.addOption(userO, true, "JDBC URL user name");
        options.addOption(passwordO, true, "JDBC URL user password");
        options.addOption(statementO, true, "SQL statement to execute");
        options.addOption(outputO, true, "Output text file or stdout if not provided");
        options.addOption(fileO, true, "SQL input file");
        options.addOption(queryO, false, "Query SQL");
        options.addOption(headerO, false, "Output with header and footer");
        options.addOption(hadoopKerberosO, false, "Hive/Kerberos authentication");
        // placeholder to force usage of commons.cli 1.4 instead of 1.2
        // can be found in dependencies
        options.hasShortOption("dummy");

        CommandLineParser parser = new DefaultParser();
        CommandLine cmd = null;
        try {
            cmd = parser.parse(options, args);
        } catch (ParseException e) {
            Log.severe("Invalid command line parameters", e);
        }
        if (cmd.hasOption(helpO)) printHelp(options, Optional.empty(), false);
        if (!cmd.hasOption(urlO)) printHelp(options, Optional.of(urlO), true);
        if (!cmd.hasOption(userO)) printHelp(options, Optional.of(userO), true);
        if (!cmd.hasOption(passwordO)) printHelp(options, Optional.of(passwordO), true);
        if (cmd.hasOption(statementO) && cmd.hasOption(fileO))
            printHelp(options, Optional.of("Either " + statementO + " or " + fileO + " should be specified, not both "), false);
        String url = cmd.getOptionValue(urlO);
        String user = cmd.getOptionValue(userO);
        String password = cmd.getOptionValue(passwordO);
        boolean queryS = cmd.hasOption(queryO);

        Log.info("Connecting to " + url);
        Log.info("User: " + user + ", password: XXXX");
        if (cmd.hasOption(hadoopKerberosO))
            try {
                Log.info("Hadoop/Kerberos authentication");
                authenticateHadoop();
                Log.info("Kerberos authentication successful");
            } catch (ClassNotFoundException | NoSuchMethodException | InvocationTargetException | IllegalAccessException throwables) {
                Log.severe("Cannot authenticate as Kerberos or HadoopAuth class not found", throwables);
            }
        try (Connection conn = connect(url, user, password)) {
            ResultSet res = null;
            if (cmd.hasOption(statementO)) {
                res = RunQueries.runStatement(conn, cmd.getOptionValue(statementO), queryS);
            }
            if (cmd.hasOption(fileO)) {
                res = RunQueries.runSqlFile(conn, cmd.getOptionValue(fileO), queryS);
            }
            if (res != null)
                OutputResultSet.printResult(res, cmd.hasOption(outputO) ? Optional.of(cmd.getOptionValue(outputO)) : Optional.empty(), cmd.hasOption(headerO));
        } catch (SQLException | IOException throwables) {
            Log.severe("Cannot connect to data source", throwables);
        }
    }
}
