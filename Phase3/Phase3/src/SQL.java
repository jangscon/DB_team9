import java.util.StringJoiner;

public class SQL {
	public static final int ORDER_BY_CHANNEL_NAME = 0;
	public static final int ORDER_BY_SUBSCRIBER_NUM = 1;
	public static final int ORDER_BY_TOTAL_VIEWS = 2;

	public static String strOrderBy(int orderBy) {
		switch (orderBy) {
		case ORDER_BY_CHANNEL_NAME:
			return "CHANNEL_NAME";
		case ORDER_BY_SUBSCRIBER_NUM:
			return "SUBSCRIBER_NUM DESC";
		case ORDER_BY_TOTAL_VIEWS:
			return "TOTAL_VIEWS DESC";
		}
		return null;
	}

	public static String sqlMain(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("                SELECT c.channel_id, c.subscriber_num, c.total_views, c.channel_name");
		sj.add("                  FROM channel c");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	public static String sqlSearch(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add(sqlSearchProjection());
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	// Type 4
	public static String sqlSearchKW(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("                SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description");
		sj.add("                  FROM channel c, youtuber y");
		sj.add("                 WHERE c.youtuber_id = y.youtuber_id");
		sj.add("                   AND c.channel_id IN (");
		sj.add("                SELECT c.channel_id");
		sj.add("                  FROM channel c");
		sj.add("                 WHERE c.channel_name LIKE ?");
		sj.add("                   AND c.channel_name LIKE ?");
		sj.add("                    OR c.description LIKE ?");
		sj.add("                   AND c.description LIKE ?)");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	// Type 6
	public static String sqlSearchSN(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("                SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description");
		sj.add("                  FROM channel c, youtuber y");
		sj.add("                 WHERE c.youtuber_id = y.youtuber_id");
		sj.add("                   AND c.channel_id IN (");
		sj.add("                SELECT c.channel_id");
		sj.add("                  FROM channel c");
		sj.add("                 WHERE c.subscriber_num > ?");
		sj.add("                   AND c.subscriber_num < ?)");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	// Type 7
	public static String sqlSearchTV(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("                  WITH id_total_views AS (");
		sj.add("                SELECT c.channel_id");
		sj.add("                  FROM channel c");
		sj.add("                 WHERE c.total_views > ?");
		sj.add("                   AND c.total_views < ?)");
		sj.add("                SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description");
		sj.add("                  FROM channel c, youtuber y, id_total_views i");
		sj.add("                 WHERE c.youtuber_id = y.youtuber_id");
		sj.add("                   AND c.channel_id = i.channel_id");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	// Type 5
	public static String sqlSearchGN(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("                SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description");
		sj.add("                  FROM channel c, youtuber y");
		sj.add("                 WHERE c.youtuber_id = y.youtuber_id");
		sj.add("                   AND NOT EXISTS (");
		sj.add("                SELECT g.genre_num");
		sj.add("                  FROM genre g");
		sj.add("                 WHERE g.genre_name in (?, ?)");
		sj.add("                 MINUS");
		sj.add("                SELECT h.genre_num");
		sj.add("                  FROM has h");
		sj.add("                 WHERE c.channel_id = h.channel_id)");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	public static String sqlSearchKWSN(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add(sqlSearchProjection());
		sj.add("AND c.channel_id IN (");
		sj.add(subSearchKW());
		sj.add("INTERSECT");
		sj.add(subSearchSN());
		sj.add(")");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	public static String sqlSearchKWTV(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add(sqlSearchProjection());
		sj.add("AND c.channel_id IN (");
		sj.add(subSearchKW());
		sj.add("INTERSECT");
		sj.add(subSearchTV());
		sj.add(")");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	public static String sqlSearchKWGN(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add(sqlSearchProjection());
		sj.add("AND c.channel_id IN (");
		sj.add(subSearchKW());
		sj.add("INTERSECT");
		sj.add(subSearchGN());
		sj.add(")");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	public static String sqlSearchSNTV(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add(sqlSearchProjection());
		sj.add("AND c.channel_id IN (");
		sj.add(subSearchSN());
		sj.add("INTERSECT");
		sj.add(subSearchTV());
		sj.add(")");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	public static String sqlSearchSNGN(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add(sqlSearchProjection());
		sj.add("AND c.channel_id IN (");
		sj.add(subSearchSN());
		sj.add("INTERSECT");
		sj.add(subSearchGN());
		sj.add(")");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	public static String sqlSearchTVGN(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add(sqlSearchProjection());
		sj.add("AND c.channel_id IN (");
		sj.add(subSearchTV());
		sj.add("INTERSECT");
		sj.add(subSearchGN());
		sj.add(")");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	public static String sqlSearchKWSNTV(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add(sqlSearchProjection());
		sj.add("AND c.channel_id IN (");
		sj.add(subSearchKW());
		sj.add("INTERSECT");
		sj.add(subSearchSN());
		sj.add("INTERSECT");
		sj.add(subSearchTV());
		sj.add(")");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	public static String sqlSearchKWSNGN(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add(sqlSearchProjection());
		sj.add("AND c.channel_id IN (");
		sj.add(subSearchKW());
		sj.add("INTERSECT");
		sj.add(subSearchSN());
		sj.add("INTERSECT");
		sj.add(subSearchGN());
		sj.add(")");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	public static String sqlSearchKWTVGN(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add(sqlSearchProjection());
		sj.add("AND c.channel_id IN (");
		sj.add(subSearchKW());
		sj.add("INTERSECT");
		sj.add(subSearchTV());
		sj.add("INTERSECT");
		sj.add(subSearchGN());
		sj.add(")");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	public static String sqlSearchSNTVGN(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add(sqlSearchProjection());
		sj.add("AND c.channel_id IN (");
		sj.add(subSearchSN());
		sj.add("INTERSECT");
		sj.add(subSearchTV());
		sj.add("INTERSECT");
		sj.add(subSearchGN());
		sj.add(")");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
	}

	// Type 10
	public static String sqlSearchKWSNTVGN(int orderBy) {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("                SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description");
		sj.add("                  FROM channel c, youtuber y");
		sj.add("                 WHERE c.youtuber_id = y.youtuber_id");
		sj.add("                   AND c.channel_id IN (");
		sj.add("                SELECT c.channel_id");
		sj.add("                  FROM channel c");
		sj.add("                 WHERE c.channel_name LIKE ?");
		sj.add("                   AND c.channel_name LIKE ?");
		sj.add("                    OR c.description LIKE ?");
		sj.add("                   AND c.description LIKE ?");
		sj.add("             INTERSECT");
		sj.add("                SELECT c.channel_id");
		sj.add("                  FROM channel c");
		sj.add("                 WHERE c.subscriber_num > ?");
		sj.add("                   AND c.subscriber_num < ?");
		sj.add("             INTERSECT");
		sj.add("                SELECT c.channel_id");
		sj.add("                  FROM channel c");
		sj.add("                 WHERE c.total_views > ?");
		sj.add("                   AND c.total_views < ?");
		sj.add("             INTERSECT");
		sj.add("                SELECT c.channel_id");
		sj.add("                  FROM channel c, has h, genre g");
		sj.add("                 WHERE c.channel_id = h.channel_id");
		sj.add("                   AND h.genre_num = g.genre_num");
		sj.add("                   AND g.genre_name = ?");
		sj.add("             INTERSECT");
		sj.add("                SELECT c.channel_id");
		sj.add("                  FROM channel c, has h, genre g");
		sj.add("                 WHERE c.channel_id = h.channel_id");
		sj.add("                   AND h.genre_num = g.genre_num");
		sj.add("                   AND g.genre_name = ?)");
		sj.add(String.format("ORDER BY %s", strOrderBy(orderBy)));
		return sj.toString();
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

	// Type 8
	public static String sqlPerformers() {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("  SELECT p2.name, p2.character");
		sj.add("    FROM channel c, participation p1, performer p2");
		sj.add("   WHERE c.channel_id = p1.channel_id");
		sj.add("     AND p1.performer_id = p2.performer_id");
		sj.add("     AND c.channel_id = ?");
		sj.add("ORDER BY p2.name");
		return sj.toString();
	}

	public static String sqlSearchProjection() {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("SELECT c.channel_id, c.subscriber_num, c.total_views, y.name, c.channel_name, c.description");
		sj.add("  FROM channel c, youtuber y");
		sj.add(" WHERE c.youtuber_id = y.youtuber_id");
		return sj.toString();
	}

	// Type 1
	public static String subSearchKW() {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("SELECT c.channel_id");
		sj.add("  FROM channel c");
		sj.add(" WHERE c.channel_name LIKE ?");
		sj.add("   AND c.channel_name LIKE ?");
		sj.add("    OR c.description LIKE ?");
		sj.add("   AND c.description LIKE ?");
		return sj.toString();
	}

	public static String subSearchSN() {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("SELECT c.channel_id");
		sj.add("  FROM channel c");
		sj.add(" WHERE c.subscriber_num > ?");
		sj.add("   AND c.subscriber_num < ?");
		return sj.toString();
	}

	public static String subSearchTV() {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("SELECT c.channel_id");
		sj.add("  FROM channel c");
		sj.add(" WHERE c.total_views > ?");
		sj.add("   AND c.total_views < ?");
		return sj.toString();
	}

	public static String subSearchGN() {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("   SELECT c.channel_id");
		sj.add("     FROM channel c, has h, genre g");
		sj.add("    WHERE c.channel_id = h.channel_id");
		sj.add("      AND h.genre_num = g.genre_num");
		sj.add("      AND g.genre_name = ?");
		sj.add("INTERSECT");
		sj.add("   SELECT c.channel_id");
		sj.add("     FROM channel c, has h, genre g");
		sj.add("    WHERE c.channel_id = h.channel_id");
		sj.add("      AND h.genre_num = g.genre_num");
		sj.add("      AND g.genre_name = ?");
		return sj.toString();
	}

	public static String sqlChannelInfo() {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("SELECT c.channel_id, c.channel_name, c.description, c.total_views, c.subscriber_num, y.name");
		sj.add("  FROM channel c, youtuber y");
		sj.add(" WHERE c.youtuber_id = y.youtuber_id");
		sj.add("   AND c.channel_id = ?");
		return sj.toString();
	}

	// Type 3
	public static String sqlAverageRating() {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("  SELECT c1.channel_id, AVG(r.rating)");
		sj.add("    FROM channel c1, rating r, customer c2");
		sj.add("   WHERE c1.channel_id = r.channel_id");
		sj.add("     AND r.customer_id = c2.customer_id");
		sj.add("GROUP BY c1.channel_id");
		sj.add("  HAVING c1.channel_id = ?");
		return sj.toString();
	}

	// Type 9
	public static String sqlComments() {
		StringJoiner sj = new StringJoiner(" ");
		sj.add("  SELECT c2.comment_id, c2.message, COUNT(r.customer_id) AS heart_num");
		sj.add("    FROM channel c1, comments c2 LEFT OUTER JOIN recommendation r ON c2.comment_id = r.comment_id");
		sj.add("   WHERE c1.channel_id = c2.channel_id");
		sj.add("     AND c1.channel_id = ?");
		sj.add("GROUP BY c2.comment_id, c2.message");
		sj.add("ORDER BY heart_num DESC");
		return sj.toString();
	}

	public static String sqlGiveRating() {
		return "INSERT INTO rating VALUES ('HGozooaJ46329939', ?, ?)";
	}

	public static String sqlWriteComment() {
		return "INSERT INTO comments VALUES ('HGozooaJ46329939', comments_seq.NEXTVAL, ?, ?)";
	}
}
