import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Scanner;

public class PageSearch {
	private Connection conn;
	private Scanner sc;
	private String[] keywords;
	private long subscriberNumOver;
	private long subscriberNumUnder;
	private long totalViewsOver;
	private long totalViewsUnder;
	private String[] genreNames;

	public PageSearch(Connection conn, Scanner sc) {
		this.conn = conn;
		this.sc = sc;
		this.clear();
	}

	public void clear() {
		this.keywords = null;
		this.subscriberNumOver = 0;
		this.subscriberNumUnder = 0;
		this.totalViewsOver = 0;
		this.totalViewsUnder = 0;
		this.genreNames = null;
	}

	public void print() {
		System.out.println();
		System.out.println("[Search Conditions]");
		System.out.printf("            KEYWORDS: %s\n",
				this.keywords != null ? String.join(", ", this.keywords) : "Not included");
		System.out.printf(" SUBSCRIBER_NUM OVER: %s\n",
				this.subscriberNumOver != 0 ? Long.toString(this.subscriberNumOver) : "Not included");
		System.out.printf("SUBSCRIBER_NUM UNDER: %s\n",
				this.subscriberNumUnder != 0 ? Long.toString(this.subscriberNumUnder) : "Not included");
		System.out.printf("    TOTAL_VIEWS OVER: %s\n",
				this.totalViewsOver != 0 ? Long.toString(this.totalViewsOver) : "Not included");
		System.out.printf("   TOTAL_VIEWS UNDER: %s\n",
				this.totalViewsUnder != 0 ? Long.toString(this.totalViewsUnder) : "Not included");
		System.out.printf("         GENRE_NAMES: %s\n",
				this.genreNames != null ? String.join(", ", this.genreNames) : "Not included");
	}

	public void searchByKeywords() {
		System.out.println();
		System.out.println("[KEYWORDS]");
		System.out.print("KEYWORDS (Separated by spaces, Up to 2): ");
		this.keywords = this.sc.nextLine().split(" ");
	}

	public void searchBySubscriberNumOver() {
		System.out.println();
		System.out.println("[SUBSCRIBER_NUM OVER]");
		System.out.print("SUBSCRIBER_NUM OVER: ");
		this.subscriberNumOver = Long.parseLong(this.sc.nextLine());
	}

	public void searchBySubscriberNumUnder() {
		System.out.println();
		System.out.println("[SUBSCRIBER_NUM UNDER]");
		System.out.print("SUBSCRIBER_NUM UNDER: ");
		this.subscriberNumUnder = Long.parseLong(this.sc.nextLine());
	}

	public void searchByTotalViewsOver() {
		System.out.println();
		System.out.println("[TOTAL_VIEWS OVER]");
		System.out.print("TOTAL_VIEWS OVER: ");
		this.totalViewsOver = Long.parseLong(this.sc.nextLine());
	}

	public void searchByTotalViewsUnder() {
		System.out.println();
		System.out.println("[TOTAL_VIEWS UNDER]");
		System.out.print("TOTAL_VIEWS UNDER: ");
		this.totalViewsUnder = Long.parseLong(this.sc.nextLine());
	}

	public void searchByGenreNames() {
		System.out.println();
		System.out.println("[GENRE_NAMES]");
		System.out.print("GENRE_NAMES (Separated by spaces, Up to 2): ");
		this.genreNames = this.sc.nextLine().split(" ");
	}

	public void menu() throws NumberFormatException {
		System.out.println();
		System.out.println("1. Search by KEYWORDS");
		System.out.println("2. Search by SUBSCRIBER_NUM OVER");
		System.out.println("3. Search by SUBSCRIBER_NUM UNDER");
		System.out.println("4. Search by TOTAL_VIEWS OVER");
		System.out.println("5. Search by TOTAL_VIEWS UNDER");
		System.out.println("6. Search by GENRE_NAMES");
		System.out.println("7. Proceed");
		System.out.println("8. Back");
		System.out.println("9. Exit");
		System.out.print("Select menu: ");

		switch (Integer.parseInt(this.sc.nextLine())) {
		case 1:
			this.searchByKeywords();
			break;
		case 2:
			this.searchBySubscriberNumOver();
			break;
		case 3:
			this.searchBySubscriberNumUnder();
			break;
		case 4:
			this.searchByTotalViewsOver();
			break;
		case 5:
			this.searchByTotalViewsUnder();
			break;
		case 6:
			this.searchByGenreNames();
			break;
		case 7:
			Phase3.page = Phase3.PAGE_SEARCH_RESULT;
			break;
		case 8:
			Phase3.page = Phase3.PAGE_MAIN;
			break;
		case 9:
			Phase3.flag = false;
			break;
		default:
			throw new NumberFormatException();
		}
	}

	public PreparedStatement psSearch(int orderBy) throws SQLException {
		boolean condKW = this.keywords == null;
		boolean condSN = this.subscriberNumOver == 0 && this.subscriberNumUnder == 0;
		boolean condTV = this.totalViewsOver == 0 && this.totalViewsUnder == 0;
		boolean condGN = this.genreNames == null;
		PreparedStatement ps = null;

		if (condKW && condSN && condTV && condGN)
			ps = this.psCond(orderBy);
		if (!condKW && condSN && condTV && condGN)
			ps = this.psCondKW(orderBy);
		if (condKW && !condSN && condTV && condGN)
			ps = this.psCondSN(orderBy);
		if (condKW && condSN && !condTV && condGN)
			ps = this.psCondTV(orderBy);
		if (condKW && condSN && condTV && !condGN)
			ps = this.psCondGN(orderBy);
		if (!condKW && !condSN && condTV && condGN)
			ps = this.psCondKWSN(orderBy);
		if (!condKW && condSN && !condTV && condGN)
			ps = this.psCondKWTV(orderBy);
		if (!condKW && condSN && condTV && !condGN)
			ps = this.psCondKWGN(orderBy);
		if (condKW && !condSN && !condTV && condGN)
			ps = this.psCondSNTV(orderBy);
		if (condKW && !condSN && condTV && !condGN)
			ps = this.psCondSNGN(orderBy);
		if (condKW && condSN && !condTV && !condGN)
			ps = this.psCondTVGN(orderBy);
		if (!condKW && !condSN && !condTV && condGN)
			ps = this.psCondKWSNTV(orderBy);
		if (!condKW && !condSN && condTV && !condGN)
			ps = this.psCondKWSNGN(orderBy);
		if (!condKW && condSN && !condTV && !condGN)
			ps = this.psCondKWTVGN(orderBy);
		if (condKW && !condSN && !condTV && !condGN)
			ps = this.psCondSNTVGN(orderBy);
		if (!condKW && !condSN && !condTV && !condGN)
			ps = this.psCondKWSNTVGN(orderBy);
		return ps;
	}

	private PreparedStatement psCond(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearch(orderBy));
		return ps;
	}

	private PreparedStatement psCondKW(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchKW(orderBy));
		ps.setString(1, String.format("%%%s%%", this.keywords[0]));
		ps.setString(3, String.format("%%%s%%", this.keywords[0]));
		if (this.keywords.length != 1) {
			ps.setString(2, String.format("%%%s%%", this.keywords[1]));
			ps.setString(4, String.format("%%%s%%", this.keywords[1]));
		} else {
			ps.setString(2, "%%");
			ps.setString(4, "%%");
		}
		return ps;
	}

	private PreparedStatement psCondSN(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchSN(orderBy));
		ps.setLong(1, this.subscriberNumOver != 0 ? this.subscriberNumOver : -1);
		ps.setLong(2, this.subscriberNumUnder != 0 ? this.subscriberNumUnder : 99999999);
		return ps;
	}

	private PreparedStatement psCondTV(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchTV(orderBy));
		ps.setLong(1, this.totalViewsOver != 0 ? this.totalViewsOver : -1);
		ps.setLong(2, this.totalViewsUnder != 0 ? this.totalViewsUnder : 99999999999L);
		return ps;
	}

	private PreparedStatement psCondGN(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchGN(orderBy));
		ps.setString(1, this.genreNames[0]);
		ps.setString(2, this.genreNames.length != 1 ? this.genreNames[1] : this.genreNames[0]);
		return ps;
	}

	private PreparedStatement psCondKWSN(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchKWSN(orderBy));
		ps.setString(1, String.format("%%%s%%", this.keywords[0]));
		ps.setString(3, String.format("%%%s%%", this.keywords[0]));
		if (this.keywords.length != 1) {
			ps.setString(2, String.format("%%%s%%", this.keywords[1]));
			ps.setString(4, String.format("%%%s%%", this.keywords[1]));
		} else {
			ps.setString(2, "%%");
			ps.setString(4, "%%");
		}
		ps.setLong(5, this.subscriberNumOver != 0 ? this.subscriberNumOver : -1);
		ps.setLong(6, this.subscriberNumUnder != 0 ? this.subscriberNumUnder : 99999999);
		return ps;
	}

	private PreparedStatement psCondKWTV(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchKWTV(orderBy));
		ps.setString(1, String.format("%%%s%%", this.keywords[0]));
		ps.setString(3, String.format("%%%s%%", this.keywords[0]));
		if (this.keywords.length != 1) {
			ps.setString(2, String.format("%%%s%%", this.keywords[1]));
			ps.setString(4, String.format("%%%s%%", this.keywords[1]));
		} else {
			ps.setString(2, "%%");
			ps.setString(4, "%%");
		}
		ps.setLong(5, this.totalViewsOver != 0 ? this.totalViewsOver : -1);
		ps.setLong(6, this.totalViewsUnder != 0 ? this.totalViewsUnder : 99999999999L);
		return ps;
	}

	private PreparedStatement psCondKWGN(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchKWGN(orderBy));
		ps.setString(1, String.format("%%%s%%", this.keywords[0]));
		ps.setString(3, String.format("%%%s%%", this.keywords[0]));
		if (this.keywords.length != 1) {
			ps.setString(2, String.format("%%%s%%", this.keywords[1]));
			ps.setString(4, String.format("%%%s%%", this.keywords[1]));
		} else {
			ps.setString(2, "%%");
			ps.setString(4, "%%");
		}
		ps.setString(1, this.genreNames[0]);
		ps.setString(2, this.genreNames.length != 1 ? this.genreNames[1] : this.genreNames[0]);
		return ps;
	}

	private PreparedStatement psCondSNTV(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchSNTV(orderBy));
		ps.setLong(1, this.subscriberNumOver != 0 ? this.subscriberNumOver : -1);
		ps.setLong(2, this.subscriberNumUnder != 0 ? this.subscriberNumUnder : 99999999);
		ps.setLong(3, this.totalViewsOver != 0 ? this.totalViewsOver : -1);
		ps.setLong(4, this.totalViewsUnder != 0 ? this.totalViewsUnder : 99999999999L);
		return ps;
	}

	private PreparedStatement psCondSNGN(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchSNGN(orderBy));
		ps.setLong(1, this.subscriberNumOver != 0 ? this.subscriberNumOver : -1);
		ps.setLong(2, this.subscriberNumUnder != 0 ? this.subscriberNumUnder : 99999999);
		ps.setString(3, this.genreNames[0]);
		ps.setString(4, this.genreNames.length != 1 ? this.genreNames[1] : this.genreNames[0]);
		return ps;
	}

	private PreparedStatement psCondTVGN(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchTVGN(orderBy));
		ps.setLong(1, this.totalViewsOver != 0 ? this.totalViewsOver : -1);
		ps.setLong(2, this.totalViewsUnder != 0 ? this.totalViewsUnder : 99999999999L);
		ps.setString(3, this.genreNames[0]);
		ps.setString(4, this.genreNames.length != 1 ? this.genreNames[1] : this.genreNames[0]);
		return ps;
	}

	private PreparedStatement psCondKWSNTV(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchKWSNTV(orderBy));
		ps.setString(1, String.format("%%%s%%", this.keywords[0]));
		ps.setString(3, String.format("%%%s%%", this.keywords[0]));
		if (this.keywords.length != 1) {
			ps.setString(2, String.format("%%%s%%", this.keywords[1]));
			ps.setString(4, String.format("%%%s%%", this.keywords[1]));
		} else {
			ps.setString(2, "%%");
			ps.setString(4, "%%");
		}
		ps.setLong(5, this.subscriberNumOver != 0 ? this.subscriberNumOver : -1);
		ps.setLong(6, this.subscriberNumUnder != 0 ? this.subscriberNumUnder : 99999999);
		ps.setLong(7, this.totalViewsOver != 0 ? this.totalViewsOver : -1);
		ps.setLong(8, this.totalViewsUnder != 0 ? this.totalViewsUnder : 99999999999L);
		return ps;
	}

	private PreparedStatement psCondKWSNGN(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchKWSNGN(orderBy));
		ps.setString(1, String.format("%%%s%%", this.keywords[0]));
		ps.setString(3, String.format("%%%s%%", this.keywords[0]));
		if (this.keywords.length != 1) {
			ps.setString(2, String.format("%%%s%%", this.keywords[1]));
			ps.setString(4, String.format("%%%s%%", this.keywords[1]));
		} else {
			ps.setString(2, "%%");
			ps.setString(4, "%%");
		}
		ps.setLong(5, this.subscriberNumOver != 0 ? this.subscriberNumOver : -1);
		ps.setLong(6, this.subscriberNumUnder != 0 ? this.subscriberNumUnder : 99999999);
		ps.setString(7, this.genreNames[0]);
		ps.setString(8, this.genreNames.length != 1 ? this.genreNames[1] : this.genreNames[0]);
		return ps;
	}

	private PreparedStatement psCondKWTVGN(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchKWTVGN(orderBy));
		ps.setString(1, String.format("%%%s%%", this.keywords[0]));
		ps.setString(3, String.format("%%%s%%", this.keywords[0]));
		if (this.keywords.length != 1) {
			ps.setString(2, String.format("%%%s%%", this.keywords[1]));
			ps.setString(4, String.format("%%%s%%", this.keywords[1]));
		} else {
			ps.setString(2, "%%");
			ps.setString(4, "%%");
		}
		ps.setLong(5, this.totalViewsOver != 0 ? this.totalViewsOver : -1);
		ps.setLong(6, this.totalViewsUnder != 0 ? this.totalViewsUnder : 99999999999L);
		ps.setString(7, this.genreNames[0]);
		ps.setString(8, this.genreNames.length != 1 ? this.genreNames[1] : this.genreNames[0]);
		return ps;
	}

	private PreparedStatement psCondSNTVGN(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchSNTVGN(orderBy));
		ps.setLong(1, this.subscriberNumOver != 0 ? this.subscriberNumOver : -1);
		ps.setLong(2, this.subscriberNumUnder != 0 ? this.subscriberNumUnder : 99999999);
		ps.setLong(3, this.totalViewsOver != 0 ? this.totalViewsOver : -1);
		ps.setLong(4, this.totalViewsUnder != 0 ? this.totalViewsUnder : 99999999999L);
		ps.setString(5, this.genreNames[0]);
		ps.setString(6, this.genreNames.length != 1 ? this.genreNames[1] : this.genreNames[0]);
		return ps;
	}

	private PreparedStatement psCondKWSNTVGN(int orderBy) throws SQLException {
		PreparedStatement ps = this.conn.prepareStatement(SQL.sqlSearchKWSNTVGN(orderBy));
		ps.setString(1, String.format("%%%s%%", this.keywords[0]));
		ps.setString(3, String.format("%%%s%%", this.keywords[0]));
		if (this.keywords.length != 1) {
			ps.setString(2, String.format("%%%s%%", this.keywords[1]));
			ps.setString(4, String.format("%%%s%%", this.keywords[1]));
		} else {
			ps.setString(2, "%%");
			ps.setString(4, "%%");
		}
		ps.setLong(5, this.subscriberNumOver != 0 ? this.subscriberNumOver : -1);
		ps.setLong(6, this.subscriberNumUnder != 0 ? this.subscriberNumUnder : 99999999);
		ps.setLong(7, this.totalViewsOver != 0 ? this.totalViewsOver : -1);
		ps.setLong(8, this.totalViewsUnder != 0 ? this.totalViewsUnder : 99999999999L);
		ps.setString(9, this.genreNames[0]);
		ps.setString(10, this.genreNames.length != 1 ? this.genreNames[1] : this.genreNames[0]);
		return ps;
	}
}
