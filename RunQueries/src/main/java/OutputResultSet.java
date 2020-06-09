import java.io.File;
import java.io.IOException;
import java.io.PrintStream;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

class OutputResultSet {

    private final static char DELIMITER = '|';
    private final static String NULL="null";

    private static void addDelimiter(StringBuffer buffer) {
        buffer.append(DELIMITER);
    }

    private static List<Integer> prepareColumnSize(ResultSetMetaData meta) throws SQLException {

        List<Integer> sizes = new ArrayList<Integer>();
        // calculate maximum number
        for (int i=0; i<meta.getColumnCount(); i++) {
            String header = meta.getColumnName(i + 1);
            int csize = meta.getColumnDisplaySize(i + 1);
            sizes.add((header.length() > csize) ? header.length() : csize);
        }
        return sizes;
    }

    private static void addColumn(List<Integer> sizes, ResultSetMetaData meta, int i, String s, StringBuffer buffer) throws SQLException {
        int size = sizes.get(i);
        boolean left = meta.getColumnType(i+1) == Types.VARCHAR || meta.getColumnType(i+1) == Types.VARCHAR;
        StringBuffer spaces = new StringBuffer();
        if (s == null) s = NULL;
        String val = s.length() < size ? s : s.substring(0,size);
        for (int j = val.length(); j < size; j++) spaces.append(' ');
        addDelimiter(buffer);
        if (left) {
            buffer.append(val);
            buffer.append(spaces);
        } else {
            buffer.append(spaces);
            buffer.append(val);
        }
    }

    private static void writeLine(PrintStream writer, StringBuffer line) throws IOException {
        writer.println(line.toString());
    }

    private static void drawLine(List<Integer> sizes, PrintStream writer) throws SQLException, IOException {
        StringBuffer s = new StringBuffer();
        for (int i = 0; i < sizes.size(); i++) {
            StringBuffer lines = new StringBuffer();
            // one character mode for delimiter
            for (int j = 0; j < sizes.get(i) + 1; j++) lines.append('-');
            s.append(lines);
        }
        s.append('-');  // DELIMITER
        writeLine(writer, s);
    }

    private static void drawHeader(List<Integer> sizes,ResultSetMetaData meta, PrintStream writer) throws SQLException, IOException {
        drawLine(sizes,writer);
        StringBuffer line = new StringBuffer();
        for (int i = 0; i < meta.getColumnCount(); i++) {
            addColumn(sizes,meta, i, meta.getColumnName(i + 1), line);
        }
        addDelimiter(line);
        writeLine(writer, line);
        drawLine(sizes, writer);
    }


    static void printResult(ResultSet res, Optional<String> output, boolean header) throws IOException, SQLException {
        Log.info("Writing result to " + (output.isPresent() ? output.get() : " stdout"));
        PrintStream writer = (output.isPresent()) ? new PrintStream(new File(output.get())) : System.out;
        ResultSetMetaData meta = res.getMetaData();
        List<Integer> sizes = prepareColumnSize(meta);
        if (header) drawHeader(sizes,meta, writer);
        while (res.next()) {
            StringBuffer line = new StringBuffer();
            for (int i = 0; i < meta.getColumnCount(); i++) {
                String val = res.getString(i + 1);
                if (res.wasNull()) val = null;
                addColumn(sizes,meta, i, val, line);
            }
            addDelimiter(line);
            writeLine(writer, line);
        }
        if (header) drawLine(sizes,writer);
        writer.close();
    }

}
