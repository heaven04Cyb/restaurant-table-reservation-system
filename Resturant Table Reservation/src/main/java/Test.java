import com.tablebook.service.TableService;
public class Test {
    public static void main(String[] args) {
        TableService ts = new TableService();
        System.out.println("Tables found: " + ts.getAvailableTables("RES1778388636066").size());
    }
}
