import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;
import java.util.StringJoiner;

public class Phase3 {
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	public static final String USER_UNIVERSITY = "university";
	public static final String USER_PASSWD = "comp322";

	public static final int PAGE_MAIN = 0;
	public static final int PAGE_SEARCH = 1;
	public static final int PAGE_SEARCH_RESULT = 2;
	public static final int PAGE_CHANNEL_INFO = 3;

	public static final int ORDER_BY_CHANNEL_NAME = 0;
	public static final int ORDER_BY_SUBSCRIBER_NUM = 1;
	public static final int ORDER_BY_TOTAL_VIEWS = 2;

	public static boolean flag = true;
	public static int page = 0;

	public static void main(String[] args) {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (ClassNotFoundException e) {
			System.err.println("error = " + e.getMessage());
			System.exit(1);
		}

		try (Connection conn = DriverManager.getConnection(URL, USER_UNIVERSITY, USER_PASSWD);
				Statement stmt = conn.createStatement();
				Scanner sc = new Scanner(System.in)) {
			PageMain pageMain = new PageMain(conn, stmt, sc);
			PageSearch pageSearch = new PageSearch(conn, sc);
			PageSearchResult pageSearchResult = new PageSearchResult(conn, sc);

			pageMain.setPageSearch(pageSearch);
			pageSearchResult.setPageSearch(pageSearch);
			conn.setAutoCommit(false);

			while (flag) {
				try {
					switch (page) {
					case PAGE_MAIN:
						pageMain.print();
						pageMain.menu();
						break;
					case PAGE_SEARCH:
						pageSearch.print();
						pageSearch.menu();
						break;
					case PAGE_SEARCH_RESULT:
						pageSearchResult.print();
						pageSearchResult.menu();
						break;
					}
				} catch (NumberFormatException e) {
					System.err.println("Please enter a valid value.");
				}
			}
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
			System.exit(1);
		}
	}

	// Type 2
	public static String sqlGenreNames() {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("  SELECT g.genre_name");
		sj.add("    FROM channel c, has h, genre g");
		sj.add("   WHERE c.channel_id = h.channel_id");
		sj.add("     AND h.genre_num = g.genre_num");
		sj.add("     AND c.channel_id = ?");
		sj.add("ORDER BY g.genre_name");
		return sj.toString();
	}

	public static String strOrderBy(int orderBy) {
		String str = null;
		switch (orderBy) {
		case ORDER_BY_CHANNEL_NAME:
			return "CHANNEL_NAME";
		case ORDER_BY_SUBSCRIBER_NUM:
			return "SUBSCRIBER_NUM DESC";
		case ORDER_BY_TOTAL_VIEWS:
			return "TOTAL_VIEWS DESC";
		}
		return str;
	}
}
