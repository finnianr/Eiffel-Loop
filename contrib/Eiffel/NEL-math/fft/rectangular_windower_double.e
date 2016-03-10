indexing
   description: "FFT rectangular window"
   author: "Greg Lee"
   copyright: "Copyright (c) 2005, Greg Lee"
   license: "Eiffel Forum License v2 (see below)"
   date: "$Date: 2005/10/31 12:00:00 $"
   revision: "$Revision: 1.0 $"

class
	RECTANGULAR_WINDOWER_DOUBLE

inherit
	WINDOWER_DOUBLE

create
	make

feature -- Initialization

	make (n: INTEGER) is
		do
			length := n
		end

feature -- Access

	name: STRING is "RECTANGULAR"

feature -- Element change

	set_window( a_window: ARRAY[DOUBLE] ) is
		local
			g: DOUBLE
			i: INTEGER
		do
			g := 1.0
			from
				i := 1
			until
				i > a_window.count
			loop
				a_window.put( g, i )
				i := i + 1
			end

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

end -- class RECTANGULAR_WINDOWER_DOUBLE
