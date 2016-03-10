indexing
   description: "3-D vectors of COMPLEX_DOUBLEs"
   author: "Greg Lee"
   copyright: "Copyright (c) 2005, Greg Lee"
   license: "Eiffel Forum License v2 (see below)"
   date: "$Date: 2005/10/31 12:00:00 $"
   revision: "$Revision: 1.0 $"

class
   VECTOR_COMPLEX_DOUBLE_3

inherit
   VECTOR_COMPLEX_DOUBLE
   
creation
   make, make_row, make_column, make_from_array, make_from

feature -- Access
   
   as_tuple: TUPLE[DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE] assign set_from_tuple is
      do
         Result := [item(1).r, item(1).i, item(2).r, item(2).i, item(3).r, item(3).i ]
      end

   x: COMPLEX_DOUBLE assign put_x is
      do
         Result := item(1)
      end
      
   y: COMPLEX_DOUBLE assign put_y is
      do
         Result := item(2)
      end
      
   z: COMPLEX_DOUBLE assign put_z is
      do
         Result := item(3)
      end
         
feature -- Element change

   set( a_x: COMPLEX_DOUBLE; a_y: COMPLEX_DOUBLE; a_z: COMPLEX_DOUBLE ) is
      do
         put( a_x, 1 )
         put( a_y, 2 )
         put( a_z, 3 )
      end      

   set_from_tuple( t: TUPLE[DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE] ) is
      do
         put_real( t.double_item(1), 1 )
         put_imag( t.double_item(2), 1 )
         put_real( t.double_item(3), 2 )
         put_imag( t.double_item(4), 2 )
         put_real( t.double_item(5), 3 )
         put_imag( t.double_item(6), 3 )
      end      

   put_x( a_x: COMPLEX_DOUBLE ) is
      do
         put( a_x, 1 )
      end
      
   put_y( a_y: COMPLEX_DOUBLE ) is
      do
         put( a_y, 2 )
      end
      
   put_z( a_z: COMPLEX_DOUBLE ) is
      do
         put( a_z, 3 )
      end
      
feature -- Basic operations

   cross, infix "#cross" ( other: VECTOR_COMPLEX_DOUBLE ): like Current is
      require
         other_size_ok: other.size = 3
         compatible_row_or_column: is_row_vector = other.is_row_vector
      local
         v: like Current
         a: COMPLEX_DOUBLE
      do
         create Result.make_from( Current )
         a := item(2)*other.item(3) - item(3)*other.item(2) 
         Result.put( a, 1 )
         a := item(3)*other.item(1) - item(1)*other.item(3)
         Result.put( a, 2 )
         a := item(1)*other.item(2) - item(2)*other.item(1)
         Result.put( a, 3 )
      end
   
   set_from_cross( u: like Current; v: like Current ) is
      require
         compatible_row_or_column: u.is_row_vector = v.is_row_vector
      do
         put( u.item(2)*v.item(3) - u.item(3)*v.item(2), 1 )
         put( u.item(3)*v.item(1) - u.item(1)*v.item(3), 2 )
         put( u.item(1)*v.item(2) - u.item(2)*v.item(1), 3 )
      end
   
indexing

   license: "[ 
      Eiffel Forum License, version 2
      
      1. Permission is hereby granted to use, copy, modify and/or distribute this 
      package, provided that:
         * copyright notices are retained unchanged,
         * any distribution of this package, whether modified or not, includes 
           this license text.
         
      2. Permission is hereby also granted to distribute binary programs which 
      depend on this package. If the binary program depends on a modified 
      version of this package, you are encouraged to publicly release the 
      modified version of this package.
   
   
      THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT WARRANTY. ANY EXPRESS OR 
      IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
      OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
      IN NO EVENT SHALL THE AUTHORS BE LIABLE TO ANY PARTY FOR ANY DIRECT, 
      INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
      ARISING IN ANY WAY OUT OF THE USE OF THIS PACKAGE.
      ]" 

end -- class VECTOR_COMPLEX_DOUBLE_3
