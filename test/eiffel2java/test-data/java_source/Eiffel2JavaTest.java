import java.util.LinkedList;

public class Eiffel2JavaTest {
	Eiffel2JavaTest () {
		my_integer  = 10;
	}

	Eiffel2JavaTest (String s) {
		my_string = s;
	}

	public int my_integer;

	public String my_string;

	public static int my_static_integer;

	public void my_method (int n, String s) {
		System.out.println ("int n=" + n + ", String s=\""+s + "\"");
		my_static_integer = n;
		my_integer = n;
	}
	public float my_function (int n, String s) {
		System.out.println ("int n=" + n + ", String s=\"" + s + "\"");
		return 0.9f;
	}

	public LinkedList stringList (String[] array){
		LinkedList list = new LinkedList ();
		for (int i = 0; i < array.length; i++){
			list.addLast (array [i]);
		}
		return list;
	}
}


