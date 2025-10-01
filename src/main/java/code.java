https://marketplace.eclipse.org/marketplace-client-intro?mpc_install=6395807
import java.util.*;

class MyException extends Exception
{
	public MyException(String m) {
		super(m);
	}
	
}
public class code {

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int mark;
		try {
			System.out.print("Name : ");
			String name = sc.nextLine();
			System.out.print("Mark : ");
			mark = sc.nextInt();
			sc.nextLine();
			System.out.print("School Name : ");
			String sclName = sc.nextLine();	
			
			if(!sclName.equals("SCOPE")) 
			{ 
				throw new MyException("Another School"); 
			}
			 
			if(name.isBlank()||sclName.isBlank())
			{
				throw new NullPointerException("Null Pointer Exception");
			}
			System.out.print("Name : "+name+"\nMarks : "+mark+"\nSchool Name : "+sclName );
		}
		catch(InputMismatchException e){
			System.out.print(e);
		}
		catch(NullPointerException e) {
			System.out.print(e);
		}
		catch(ArithmeticException e)
		{
			System.out.print(e);
		}
		  catch(MyException m) { System.out.print(m.getMessage()); }
				
	}

}
