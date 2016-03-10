indexing
   description: "FFT window deferred interface"
   author: "Greg Lee"
   copyright: "Copyright (c) 2005, Greg Lee"
   license: "Eiffel Forum License v2 (see below)"
   date: "$Date: 2005/10/31 12:00:00 $"
   revision: "$Revision: 1.0 $"

deferred class
	WINDOWER_DOUBLE

feature -- Initialization

	make( n: INTEGER ) is
		require
			n_positive: n > 0
		deferred
		ensure
			length_set: length = n	
		end
		
feature -- Access

	length: INTEGER

	name: STRING is
		deferred
		end
	
feature -- Element change

	set_window( a_window: ARRAY[DOUBLE] ) is
		require
			a_window_length_ok: a_window.count = length
		deferred
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


end -- class WINDOWER_DOUBLE
