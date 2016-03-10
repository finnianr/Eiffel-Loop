indexing
   description: "2-D vectors"
   author: "Greg Lee"
   copyright: "Copyright (c) 2005, Greg Lee"
   license: "Eiffel Forum License v2 (see below)"
   date: "$Date: 2005/10/31 12:00:00 $"
   revision: "$Revision: 1.0 $"

class
   VECTOR_DOUBLE_2

inherit
   VECTOR_DOUBLE
   
creation
   make, make_row, make_column, make_from_array, make_from

feature -- Access

   as_tuple: TUPLE[DOUBLE, DOUBLE] assign set_from_tuple is
      do
         Result := [item(1), item(2) ]
      end

   x: DOUBLE assign put_x is
      do
         Result := item(1)
      end
      
   y: DOUBLE assign put_y is
      do
         Result := item(2)
      end
      
feature -- Element change

   set( a_x: DOUBLE; a_y: DOUBLE ) is
      do
         put( a_x, 1 )
         put( a_y, 2 )
      end      

   set_from_tuple( t: TUPLE[DOUBLE, DOUBLE] ) is
      do
         put( t.double_item(1), 1 )
         put( t.double_item(2), 2 )
      end      

   put_x( a_x: DOUBLE ) is
      do
         put( a_x, 1 )
      end
      
   put_y( a_y: DOUBLE ) is
      do
         put( a_y, 2 )
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

end -- class VECTOR_DOUBLE_2
