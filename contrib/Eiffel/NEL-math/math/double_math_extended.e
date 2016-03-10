indexing
   description: "[
      Basic double-precision mathematical functions with a few useful constants.
      Includes all of the standard C functions from <math.h>.
      ]"
   author: "Greg Lee"
   copyright: "Copyright (c) 2005, Greg Lee"
   license: "Eiffel Forum License v2 (see below)"
   date: "$Date: 2005/10/31 12:00:00 $"
   revision: "$Revision: 1.0 $"

class
   DOUBLE_MATH_EXTENDED
   
inherit
   DOUBLE_MATH
   
feature -- Trigomometric

   arc_tangent2 (x: DOUBLE; y: DOUBLE): DOUBLE is
         -- Trigonometric four quadrant arc tangent
         -- in the range [-pi, +pi]
      external
         "C signature (double, double): double use <math.h>"
      alias
         "atan2"
      end
      
feature -- Exponential

   power (x: DOUBLE; y: DOUBLE): DOUBLE is
         -- x to the power of y
      external
         "C signature (double, double): double use <math.h>"
      alias
         "pow"
      end

   fraction_exponent (x: DOUBLE; i_ref: INTEGER_REF): DOUBLE is
         -- returns normalized fraction of x 
         -- Result is 0.5 <= Result <= 1.0
         -- i_ref set to exponent of 2, such that
         -- x := Result ^ i_ref.item
      require
         i_ref_not_void: i_ref /= Void
      external
         "C signature (double, int *): double use <math.h>"
      alias
         "frexp"
      end

   load_exponent (x: DOUBLE; i: INTEGER): DOUBLE is
         -- returns x * 2^i 
      external
         "C signature (double, int): double use <math.h>"
      alias
         "ldexp"
      end
      
feature -- Floating point modulo

   modulo (x: DOUBLE; y: DOUBLE): DOUBLE is
         -- remainder of x/y, same sign as x
      external
         "C signature (double, double): double use <math.h>"
      alias
         "fmod"
      end

   modulo_float (x: DOUBLE; i_ref: INTEGER_REF): DOUBLE is
         -- returns fractional part of x as Result
         -- i_ref set to integral part of x, such that
         -- x := Result + i_ref.item
         -- and Result and i_ref.item have same sign
      require
         i_ref_not_void: i_ref /= Void
      external
         "C signature (double, int *): double use <math.h>"
      alias
         "modf"
      end

feature -- Hyperbolic 

   cosine_hyperbolic (v: DOUBLE): DOUBLE is
         -- Hyperbolic cosine of value 'v'
      external
         "C signature (double): double use <math.h>"
      alias
         "cosh"
      end

   sine_hyperbolic (v: DOUBLE): DOUBLE is
         -- Hyperbolic sine of value 'v'
      external
         "C signature (double): double use <math.h>"
      alias
         "sinh"
      end

   tangent_hyperbolic (v: DOUBLE): DOUBLE is
         -- Hyperbolic tangent of value 'v'
      external
         "C signature (double): double use <math.h>"
      alias
         "tanh"
      end
      
feature -- Trigonometric functions using degrees instead of radians

   sine_degrees( a: DOUBLE ): DOUBLE is
      do
         Result := sine( a*Degrees_to_radians )
      end

   arc_sine_degrees( a: DOUBLE ): DOUBLE is
      do
         Result := Radians_to_degrees*arc_sine(a)
      end

   cosine_degrees( a: DOUBLE ): DOUBLE is
      do
         Result := cosine( a*Degrees_to_radians )
      end

   arc_cosine_degrees( a: DOUBLE ): DOUBLE is
      do
         Result := Radians_to_degrees*arc_cosine(a)
      end

   tangent_degrees( a: DOUBLE ): DOUBLE is
      do
         Result := tangent( a*Degrees_to_radians )
      end

   arc_tangent_degrees( a: DOUBLE ): DOUBLE is
      do
         Result := Radians_to_degrees*arc_tangent(a)
      end

   arc_tangent2_degrees( y: DOUBLE; x: DOUBLE ): DOUBLE is
      do
         Result := Radians_to_degrees*arc_tangent2(y,x)
      end
      
feature -- "Safe" versions of inverse trigometric functions

   arc_tangent2_s (x: DOUBLE; y: DOUBLE): DOUBLE is
         -- Trigonometric four quadrant arc tangent
         -- in the range [-pi, +pi]
      do
         if not ( x = 0.0 and y = 0.0 ) then
            Result := arc_tangent2( x, y )
         end
      end

   arc_tangent2_degrees_s ( x: DOUBLE; y: DOUBLE ): DOUBLE is
         -- Trigonometric four quadrant arc tangent
         -- in the range [-180, +180]
      do
         if not ( x = 0.0 and y = 0.0 ) then
            Result := arc_tangent2_degrees( x, y )
         end
      end
      
   arc_cosine_s ( a: DOUBLE ): DOUBLE is
      local
         x: DOUBLE
      do
         x := a
         if x > 1.0 then
            x := 1.0
         elseif x < -1.0 then
            x := -1.0
         end
         Result := arc_cosine(x)
      end

   arc_cosine_degrees_s ( a: DOUBLE ): DOUBLE is
      local
         x: DOUBLE
      do
         x := a
         if x > 1.0 then
            x := 1.0
         elseif x < -1.0 then
            x := -1.0
         end
         Result := arc_cosine_degrees(x)
      end

   arc_sine_s ( a: DOUBLE ): DOUBLE is
      local
         x: DOUBLE
      do
         x := a
         if x > 1.0 then
            x := 1.0
         elseif x < -1.0 then
            x := -1.0
         end
         Result := arc_sine(x)
      end

   arc_sine_degrees_s ( a: DOUBLE ): DOUBLE is
      local
         x: DOUBLE
      do
         x := a
         if x > 1.0 then
            x := 1.0
         elseif x < -1.0 then
            x := -1.0
         end
         Result := arc_sine_degrees(x)
      end

feature -- Handy angle conversions

   angle_correct( a: DOUBLE ): DOUBLE is
      -- puts angle in radians in the range of -Pi to +Pi
      do
         if a <= -Pi then
            Result := a + Two_pi
         elseif a > Pi then
            Result := a - Two_pi
         else
            Result := a
         end
      end
      
   angle_correct_degrees( a: DOUBLE ): DOUBLE is
      -- puts angle in degrees in the range of -180 to +180
      do
         if a <= -180.0 then
            Result := a + 360.0
         elseif a > 180.0 then
            Result := a - 360.0
         else
            Result := a
         end
      end
      
feature -- Constants

   Two_pi: DOUBLE is
      once
         Result := 2.0*Pi
      end
      
   Radians_to_degrees: DOUBLE is
      once
         Result := 180.0/Pi
      end   
   
   Degrees_to_radians: DOUBLE is
      once
         Result := Pi/180.0
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

end -- class DOUBLE_MATH_EXTENDED
