import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

class RunQueries {

    static ResultSet runStatement(Connection con, String statement, boolean queryS) throws SQLException {
        if (queryS) return con.prepareStatement(statement).executeQuery();
        con.prepareStatement(statement).executeUpdate();
        return null;
    }

    static ResultSet runSqlFile(Connection con, String file, boolean queryS, boolean removeSemicolon) throws IOException, SQLException {
        Log.info("Read " + (queryS ? "query" : "update") + " " + file);
        File f = new File(file);
        List<String> lines = Files.readAllLines(f.toPath());
        StringBuffer query = new StringBuffer();
        for (String line : lines) {
            if (!line.startsWith("--")) {
                query.append(line);
                query.append('\n');
            }
        }
        String q = query.toString().trim();
        if (removeSemicolon && q.endsWith(";")) q = q.substring(0,q.length()-1);
        return runStatement(con, q, queryS);
    }


}
