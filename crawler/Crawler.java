import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
//database
import com.mysql.jdbc.Driver; 
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;


public class Crawler {
	static String url;

	static Queue<String> queue = new LinkedList<String>();
	static ArrayList<String> visited = new ArrayList<String>();
	static 	int counter=0;
	public static void main(String[] args) throws IOException, SQLException {
		Crawler cr = new Crawler();

		BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
		System.out.print ("Enter the url to crawl: \n");
		System.out.flush(); 
		url = stdin.readLine();

		if (url.startsWith("www")) {
			url = "http://" + url;
		} 
		if (!(url.startsWith("http://") && !(url.startsWith("www")))) {

			url = "http://" + url;
		}


		cr.parseHTML(cr.getHTMLPage(url));
	}
	public static String getHTMLPage(String site) throws SQLException {	
		String title_regex = "<title>(.*?)</title>";
		String desc_regex = "<meta NAME|name=\"(description|Description|DESCRIPTION)\" content=(.*?)>";

		String title="";
		String desc="";

		Pattern title_pattern = Pattern.compile(title_regex);
		Pattern desc_pattern = Pattern.compile(desc_regex);

		Matcher title_matcher = null;
		Matcher desc_matcher = null;
		Connection conn = null;
		DriverManager.registerDriver (new Driver());
		Statement stmt = null;

		try {
			conn =
				DriverManager.getConnection("jdbc:mysql://localhost/web_crawler?" +
				"user=root&password=");

		} catch (SQLException ex) {
			// handle any errors
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		}

		URL url = null;
		try {
			url = new URL(site);
		} catch (MalformedURLException e) {

			e.printStackTrace();
		}
		URLConnection conn1 = null;
		
		try {
			conn1 = url.openConnection();
		} catch (IOException e) {
			if(queue.size() > 0 ) {
				String skipUrl = queue.poll();
				visited.add(skipUrl);
				getHTMLPage(skipUrl);
			} else {
				System.out.println("Malformed html content\n");
				System.exit(0);
			}
		}
		
		conn1.setRequestProperty("User-Agent", "Mozilla/5.0 (Linux; U; Slackware Linux; en-US; rv:x.x.x) Gecko/20090123 Firefox/x.x");

		
		BufferedReader br = null;
		try {
			
			br = new BufferedReader(new InputStreamReader(conn1.getInputStream()));
	
		} catch (IOException e) {
			if(queue.size() > 0) {
				String skipUrl = queue.poll();
				visited.add(skipUrl);
				getHTMLPage(skipUrl);
			} else {
				System.out.println("Malformed HTML content\n");
				System.exit(0);
			}
			//e.printStackTrace();
		}  
		StringBuilder str = new StringBuilder();
		String buffer = " ";

		StringBuilder html = new StringBuilder();
		while (buffer != null) {
			//System.out.println(buffer);
			html.append(buffer);
			try {
				
				buffer = br.readLine();
	
			} catch (IOException e) {
				if(queue.size() > 0 ) {
					String skipUrl = queue.poll();
					visited.add(skipUrl);
					getHTMLPage(skipUrl);
				} else {
					System.out.println("Malformed HTML\n");
					System.exit(0);
				}
				//e.printStackTrace();
			}


		}
		try {
			br.close();
		} catch (IOException e) {

			e.printStackTrace();
		}

		try {
			title_matcher = title_pattern.matcher(html.toString());
		} catch (Exception e1) {
			return new String();
		}

		try {
			desc_matcher = desc_pattern.matcher(html.toString());
		} catch (Exception e1) {
			return new String();
		}

		if (title_matcher.find()) {
			title = title_matcher.group();
			title = title.replaceAll("<title>|</title>|\"|\'|;","");
			System.out.println("Title "+ title);
		}
		if(desc_matcher.find()) {
			desc = desc_matcher.group();
			desc = desc.replaceAll("(name=\"(description|Description|DESCRIPTION)\" content=\")|\"|>|\'|;","");
			System.out.println("Description "+ desc);
		}



		try {
			stmt = conn.createStatement();

			stmt.executeUpdate("INSERT INTO url (url_name,title,description) VALUES ('"+site+"','"+title+"','"+desc+"')");

		}
		catch (SQLException ex){
			// handle any errors
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		}
		finally {

			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException sqlEx) { } // ignore

				stmt = null;
			}
		}	


		return html.toString();
	}

	public static String parseHTML(String html) throws IOException, SQLException {
		String urlPattern = "<a href=\"(.*?)\"";

		String results;
		results = setResults(Pattern.compile(urlPattern), html);

		return results;
	}	

	public static String setResults(Pattern urlPattern, String html) throws IOException, SQLException {
		Matcher matcher = null;

		try {
			matcher = urlPattern.matcher(html);
		} catch (Exception e1) {
			return new String();
		}


		boolean result = matcher.find();
		List outList = new ArrayList();


		while (result) {
			String href;


			href = matcher.group();
			href = href.replaceAll("<a href=", "").replaceAll("\"","");

			if(!href.contains("javascript") && !href.contains(";")) {

				if ((!(href.startsWith("http://"))) &&  (!(href.startsWith("www"))) && (!(href.startsWith("https://"))) && (!(href.startsWith("/")))){
					href = url + "/" + href;
				}
				if (href.startsWith("/")) {
					if(!url.endsWith("/")) {

						href = url + href;
					}
				}

			}
			if (href.contains(url)){
				queue.add(href);

			}

			result = matcher.find();
		}

		while(queue.size() > 0){

			String next = queue.poll();
			if(checkTraversed(visited, next) == 0){
				counter++;
				if(counter > 50) {
					System.out.println("Maximum search depth reached.");
					System.exit(0);
				}

				System.out.println("Crawling "+next);
				visited.add(next);
				parseHTML(getHTMLPage(next));

			}
		}
		return queue.peek();
	}

	public static Integer checkTraversed(ArrayList<String> list, String list_id) {

		list_id = list_id.replace("/", "");
		list_id = list_id.replace("http:", "");
		list_id = list_id.trim();
		for(int i=0; i < list.size() ; i++) {
			String element = list.get(i).toString();
			element = element.replace("/","");
			element = element.replace("http:","");
			element = element.trim();  

			if(element.equalsIgnoreCase(list_id)) {
				return 1;
			}



		}

		return 0;
	}
}

