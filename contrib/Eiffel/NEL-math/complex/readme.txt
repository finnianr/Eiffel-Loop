These classes implement complex numbers.

Although the use of COMPLEX_DOUBLE in Eiffel is straightforward, this class is not a built-in type, so there is no automatic type conversion from DOUBLE to COMPLEX_DOUBLE:

   c: COMPLEX_DOUBLE
   c1: COMPLEX_DOUBLE
   c2: COMPLEX_DOUBLE
   d: DOUBLE
   
   c := d -- this will cause a compiler error - a COMPLEX_DOUBLE is not a DOUBLE
   
   c.set( d, 0.0 ) -- this is how to set a COMPLEX_DOUBLE from a DOUBLE
   
   c1 := d * c -- this will cause a compiler error

   c2.set( d, 0.0 ) -- this is how to accomplish the above
   c1 := c2*c 
   
   
Greg Lee
October 2005
