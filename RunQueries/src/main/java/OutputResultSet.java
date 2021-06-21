import java.io.File;
import java.io.IOException;
import java.io.PrintStream;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

class OutputResultSet {

    private final static char DELIMITER = '|';
    private final static String NULL = "NULL";
    private final static int MAXCSIZE = 2000;

    private static void addDelimiter(StringBuffer buffer) {
        buffer.append(DELIMITER);
    }

    private static List<Integer> prepareColumnSize(ResultSetMetaData meta) throws SQLException {

        List<Integer> sizes = new ArrayList<Integer>();
        // calculate maximum number
        for (int i = 0; i < meta.getColumnCount(); i++) {
            String header = meta.getColumnName(i + 1);
            int csize = meta.getColumnDisplaySize(i + 1);
            // threshold
            if (csize > MAXCSIZE) Log.info(header + " column size " + csize + " too big");
            sizes.add((header.length() > csize) ? header.length() : csize);
        }
        return sizes;
    }

    private static void addColumn(List<Integer> sizes, ResultSetMetaData meta, int i, String s, StringBuffer buffer) throws SQLException {
        int size = sizes.get(i);
        boolean left = meta.getColumnType(i + 1) == Types.VARCHAR || meta.getColumnType(i + 1) == Types.VARCHAR;
        StringBuffer spaces = new StringBuffer();
        if (s == null) s = NULL;
        String val = s.length() < size ? s : s.substring(0, size);
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

    private static void drawHeader(List<Integer> sizes, ResultSetMetaData meta, PrintStream writer) throws SQLException, IOException {
        drawLine(sizes, writer);
        StringBuffer line = new StringBuffer();
        for (int i = 0; i < meta.getColumnCount(); i++) {
            addColumn(sizes, meta, i, meta.getColumnName(i + 1), line);
        }
        addDelimiter(line);
        writeLine(writer, line);
        drawLine(sizes, writer);
    }

    static boolean isMySql(ResultSet res) throws SQLException {
        DatabaseMetaData da = res.getStatement().getConnection().getMetaData();
        String s = da.getDriverName();
        return s.startsWith("MySQL");
    }

    static boolean wasNull(ResultSet res, int i, String val) throws SQLException {
        if (res.wasNull()) return true;
        if (isMySql(res) && val.equals("")) return true;
        return false;
    }

    static void printResult(ResultSet res, Optional<String> output, boolean header, Optional<Short> rounddec) throws IOException, SQLException {
        Log.info("Writing result to " + (output.isPresent() ? output.get() : " stdout"));
        PrintStream writer = (output.isPresent()) ? new PrintStream(new File(output.get())) : System.out;
        ResultSetMetaData meta = res.getMetaData();
        List<Integer> sizes = prepareColumnSize(meta);
        String format = null;
        if (rounddec.isPresent()) {
            format = "%." + rounddec.get() + "f";
        }
        if (header) drawHeader(sizes, meta, writer);
        while (res.next()) {
            StringBuffer line = new StringBuffer();
            for (int i = 0; i < meta.getColumnCount(); i++) {
                String val = res.getString(i + 1);
                if (wasNull(res, i, val)) val = null;
                else {
                    int t = meta.getColumnType(i + 1);
                    int scale = meta.getScale(i + 1);
                    boolean numericround = rounddec.isPresent() && (t == Types.NUMERIC || t == Types.DECIMAL || t == Types.FLOAT || t == Types.BIGINT);
                    if (numericround) {
                        BigDecimal b = res.getBigDecimal(i + 1);
                        // Local.US to have digital dot, not comma
                        val = String.format(Locale.US, format, b);
                    }
                }
                addColumn(sizes, meta, i, val, line);
            }
            addDelimiter(line);
            writeLine(writer, line);
        }
        if (header) drawLine(sizes, writer);
        writer.close();
    }

}
