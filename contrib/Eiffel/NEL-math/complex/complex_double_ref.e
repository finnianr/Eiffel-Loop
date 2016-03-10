indexing
   description: "Complex numbers with DOUBLE precision"
   author: "Greg Lee"
   copyright: "Copyright (c) 2005, Greg Lee"
   license: "Eiffel Forum License v2 (see below)"
   date: "$Date: 2005/10/31 12:00:00 $"
   revision: "$Revision: 1.0 $"

class COMPLEX_DOUBLE_REF

inherit
   NUMERIC
      redefine
         out,
         is_equal
      end
   DOUBLE_MATH_EXTENDED
      rename
         power as power_double
      redefine
         out,
         is_equal
      end

feature -- Access

   r: DOUBLE assign set_real
      -- Real part of `Current'

   i: like r assign set_imag
      -- Imaginary part of `Current'

   zero: like Current is
      -- Neutral element for "+" and "-"
      do
         create Result
      end -- zero

   one: like Current is
      -- Neutral element for "*" and "/"
      do
         create Result
         Result.set_real(1.0)
      end -- one

   as_tuple: TUPLE[DOUBLE, DOUBLE] assign set_from_tuple is
      do
         create Result
         Result.put_double( r, 1 )
         Result.put_double( i, 2 )
      end

   item: COMPLEX_DOUBLE is
      do
         item.set_from_reference( Current )
      end

feature -- Comparison

	is_equal(other: like Current): BOOLEAN is
		do
			Result := ( r = other.r ) and ( i = other.i )
		end

feature -- Basic operations

   infix "+"(other: like Current): like Current is
      -- Sum with `other' (commutative)
      do
         create Result
         Result.set(r + other.r, i + other.i)
      end

   infix "-"(other: like Current): like Current is
      -- Result of subtracting `other'
      do
         create Result
         Result.set(r - other.r, i - other.i)
      end

   infix "*"(other: like Current): like Current is
      -- Product by `other'
      do
         create Result
         Result.set(r*other.r - i*other.i, r*other.i + i*other.r)
      end

   infix "/"(other: like Current): like Current is
      -- Division by `other'
      local
         d: DOUBLE
      do
         d := 1.0 / (other.r*other.r + other.i*other.i)
         create Result
         Result.set(d * (r*other.r + i*other.i), d*(-r*other.i + i*other.r))
      end

   infix "^" (exponent: DOUBLE): like Current is
      -- `Current' to the power `e'
		local
			m: DOUBLE
			ph: DOUBLE
			c: DOUBLE
			s: DOUBLE
		do
			create Result

			m := magnitude ^ exponent

			ph := phase*exponent
			c := cosine( ph )
			s := sine( ph )

			Result.set_real( m*c )
			Result.set_imag( m*s )

      end

   prefix "+": like Current is
      -- Unary plus
      do
         create Result
         Result.set(r, i )
      ensure then
         result_is_equal_current: Result.is_equal(Current)
      end

   prefix "-": like Current is
      -- Unary minus
      do
         create Result
         Result.set(-r, -i)
      ensure then
         opposite: Current.r + Result.r = 0.0 and Current.i + Result.i = 0.0
      end

   power(other: like Current): like Current is
      -- `Current' to the power `other'
		local
			m: DOUBLE
			ph: DOUBLE
			c: DOUBLE
			s: DOUBLE
		do
			create Result

			m := power_double(magnitude, other.r)

			ph := phase*other.r + other.i
			c := cosine( ph )
			s := sine( ph )

			Result.set_real( m*c )
			Result.set_imag( m*s )

      end

   conjugated: like Current is
      -- conjugated copy of Current
      do
         create Result
         Result.set(r, -i)
      end

   conjugate is
      -- conjugate Current
      do
         i := -i
      end

   squared_magnitude: DOUBLE is
      -- squared magnitude of Current
      do
      	Result := r*r + i*i
      end

   magnitude: DOUBLE is
      -- magnitude of Current
      do
      	Result := sqrt(r*r + i*i)
      end

	phase: like r is
			-- phase of `Current'
		do
		   if not ( r = 0.0 and i = 0.0 ) then
            Result := arc_tangent2(i, r)
         end
		end

   inverse: like Current is
      -- multiplicative inverse of Current
      local
         d: DOUBLE
      do
         d := 1.0 / (r*r +i*i)
         create Result
         Result.set(d*r, -d*i)
      end

   invert is
      -- invert Current
      local
         d: DOUBLE
      do
         d := 1.0 / (r*r +i*i)
         set(d*r, -d*i)
      end

feature -- Status report

   divisible(other: like Current): BOOLEAN is
      -- May `Current' object be divided by other?
      do
         Result := not other.is_equal(zero)
      end

   exponentiable(other: like Current): BOOLEAN is
      -- May `Current' object be elevated to the power other?
      do
         Result := not Current.is_equal(zero)
      end

feature -- Element change

   set_from(other: like Current) is
      do
         r := other.r
         i := other.i
      end

   set_from_reference(other: COMPLEX_DOUBLE_REF) is
      do
         r := other.r
         i := other.i
      end

   set_from_expanded(other: COMPLEX_DOUBLE) is
      do
         r := other.r
         i := other.i
      end

   set(re: DOUBLE; im: DOUBLE) is
      do
         r := re
         i := im
      end

   set_real(re: DOUBLE) is
      do
         r := re
      end

   set_imag(im: DOUBLE) is
      do
         i := im
      end

   set_from_tuple( t: TUPLE[DOUBLE, DOUBLE] ) is
      do
         r := t.double_item(1)
         i := t.double_item(2)
      end

	is_approximately_equal(other: like Current; precision: DOUBLE ): BOOLEAN is
		local
			maximum: DOUBLE
			diff1: DOUBLE
			diff2: DOUBLE
		do
			maximum := magnitude
			if other.magnitude > maximum then
				maximum := other.magnitude
			end

			diff1 := (r - other.r).abs
			diff2 := (i - other.i).abs

			if diff1 <= precision*maximum and diff2 <= precision*maximum then
				Result := True
			end

		end

feature -- Output

   out: STRING is
      do
         create Result.make(32)
         Result.append("( ")
         Result.append(r.out)
         if i >= 0 then
            Result.append(" + ")
         else
            Result.append("  ")
         end
         Result.append(i.out)
         Result.append("i")
         Result.append(" )")
      end

	simple_out: STRING is
		do
         create Result.make(32)
         Result.append(r.out)
         Result.append("%T")
         Result.append(i.out)
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

end -- class COMPLEX_DOUBLE_REF
