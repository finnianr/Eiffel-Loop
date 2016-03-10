indexing
   description: "Fast Fourrier Transform"
   author: "Greg Lee"
   copyright: "Copyright (c) 2005, Greg Lee"
   license: "Eiffel Forum License v2 (see below)"
   date: "$Date: 2005/10/31 12:00:00 $"
   revision: "$Revision: 1.0 $"

class
   FFT_COMPLEX_DOUBLE

inherit
   DOUBLE_MATH_EXTENDED

create
   make

feature -- Initialization

   make( n: INTEGER ) is
      require
         n_is_power_of_two: is_power_of_two(n)
      do
         length := n
         log_length := log_2i( n )
         set_bit_reverse
         set_coefficients
         set_default_windower
      ensure
         length_set: length = n
         bit_reverse_set: bit_reverse /= Void
         coefficients_set: coefficients /= Void
         window_set: window /= Void
      end

feature -- Access

   length: INTEGER
   log_length: INTEGER

   input: VECTOR_COMPLEX_DOUBLE
   output: VECTOR_COMPLEX_DOUBLE

   bit_reverse: ARRAY[INTEGER]
      -- bit reverse elements are offsets, not indices

   coefficients: VECTOR_COMPLEX_DOUBLE
      -- cosine + i*sine

   window: VECTOR_DOUBLE

   windower: WINDOWER_DOUBLE

   psd: VECTOR_DOUBLE
   log_psd: VECTOR_DOUBLE
   phase: VECTOR_DOUBLE

feature -- Element change

   set_input( a_input: like input) is
      require
         a_input_length_ok: a_input.length = length
      do
         input := a_input
      end

   set_output( a_output: like output) is
      require
         a_output_length_ok: a_output.length = length
      do
         output := a_output
      end

   set_psd( a_psd: VECTOR_DOUBLE ) is
      require
         a_psd_length_ok: a_psd.length = length
      do
         psd := a_psd
      end

   set_phase( a_phase: VECTOR_DOUBLE ) is
      require
         a_phase_length_ok: a_phase.length = length
      do
         phase := a_phase
      end

   set_windower( a_windower: WINDOWER_DOUBLE ) is
      require
         a_windower_not_void: a_windower /= Void
      do
         windower := a_windower
         windower.set_window( window )
      end

feature -- Miscellaneous

   is_power_of_two( n: INTEGER ): BOOLEAN is
      local
         i: INTEGER
         m: INTEGER
      do
         m := 1
         from
            i := 1
         until
            i > 65536 or Result
         loop
            m := 2*m
            if m = n then
               Result := True
            end
            i := i + 1
         end
      end

   log_2i( n: INTEGER ): INTEGER is
      do
         Result := ( log( 1.0*n )/log(2.0) ).rounded
      end

feature -- Basic operations

   fft is
      require
         input_not_void: input /= Void
         output_exists_implies_length_ok: output /= Void implies output.length = length
      local
         i: INTEGER
         j: INTEGER
         jrv: INTEGER
         k: INTEGER
         l: INTEGER
         n2: INTEGER
         ibrv: INTEGER
         cis: COMPLEX_DOUBLE
         g: COMPLEX_DOUBLE
         d: DOUBLE
      do
         if output = Void then
            create output.make_column( length )
         end

         from
            i := 1
         until
            i > input.length
         loop
            g.set( window.item(i)*input.item(i).r, window.item(i)*input.item(i).i )
            output.put( g, i )
            i := i + 1
         end

         from
            n2 := length//2
            l := log_length - 1
            j := 0
            i := 0
         until
            i >= log_length
         loop

            from
            until
               j >= length
            loop

               from
                  k := 0
               until
                  k >= n2
               loop

                  jrv := j.bit_shift_right(l)

                  ibrv := bit_reverse.item( jrv + 1 )

                  cis := coefficients.item(ibrv+1)

                  g := output.item(j+n2+1)*cis

                  output.put( output.item(j+1) - g, j+n2+1 )
                  output.put( output.item(j+1) + g, j+1 )

                  j := j + 1
                  k := k + 1

               end

               j := j + n2

            end


            j := 0
            l := l - 1
            n2 := n2//2
            i := i + 1
         end

         d := 2.0/length
         g.set( d, 0.0 )
         output.scale_by( g )

         bit_reverse_output

      end

   ifft, inverse_fft is
      require
         input_not_void: input /= Void
         output_exists_implies_length_ok: output /= Void implies output.length = length
      local
         i: INTEGER
         j: INTEGER
         jrv: INTEGER
         k: INTEGER
         l: INTEGER
         n2: INTEGER
         ibrv: INTEGER
         cis: COMPLEX_DOUBLE
         g: COMPLEX_DOUBLE
         d: DOUBLE
      do
         if output = Void then
            create output.make( 1, length )
         end

         output.copy( input )

         from
            n2 := length//2
            l := log_length - 1
            j := 0
            i := 0
         until
            i >= log_length
         loop

            from
            until
               j >= length
            loop

               from
                  k := 0
               until
                  k >= n2
               loop

                  jrv := j.bit_shift_right(l)

                  ibrv := bit_reverse.item( jrv +1)
                  cis := coefficients.item(ibrv+1)

                  g := output.item(j+n2+1)*cis.conjugated

                  output.put( output.item(j+1) - g, j+n2+1 )
                  output.put( output.item(j+1) + g, j+1 )

                  j := j + 1
                  k := k + 1

               end

               j := j + n2

            end


            j := 0
            l := l - 1
            n2 := n2//2
            i := i + 1
         end

         d := 0.5
         g.set( d, 0.0 )

         output.scale_by( g )

         bit_reverse_output

      end

   compute_psd is
      local
         i: INTEGER
         d: DOUBLE
         h: DOUBLE
      do
         if psd = Void then
            create psd.make_column( length )
         end

         from
            i := 1
         until
            i > length
         loop
            d := output.item(i).magnitude
            h := d
            psd.put(h, i)
            i := i + 1
         end
      end

   compute_log_psd is
      local
         i: INTEGER
         d: DOUBLE
         h: DOUBLE
      do
         if log_psd = Void then
            create log_psd.make_column( length )
         end

         from
            i := 1
         until
            i > length
         loop
            d := 10.0*log10( output.item(i).squared_magnitude )
            h := d
            log_psd.put(h, i)
            i := i + 1
         end
      end

   compute_phase is
      local
         i: INTEGER
         d: DOUBLE
         re: DOUBLE
         im: DOUBLE
         h: DOUBLE
      do
         if phase = Void then
            create phase.make_column( length )
         end

         from
            i := 1
         until
            i > length
         loop
            re := output.item(i).r
            im := output.item(i).i
            d := arc_tangent2_s( im, re )
            h := d
            phase.put(h, i)
            i := i + 1
         end
      end

feature {NONE} -- Implementation

   set_bit_reverse is
      local
         i: INTEGER
         j: INTEGER
         ui: INTEGER
         uj: INTEGER
      do
         create bit_reverse.make( 1, length )

         from
            i := 0
         until
            i >= length
         loop

            ui := 0
            uj := i
            from
               j := 0
            until
               j >= log_length
            loop

               ui := ui * 2
               if ( uj \\ 2 ) = 1 then
                  ui := ui + 1
               end

               uj := uj // 2
               j := j + 1
            end
            bit_reverse.put( ui, i + 1 )
            i := i + 1
         end

      end

   set_coefficients is
      local
         i: INTEGER
         g: COMPLEX_DOUBLE
         x: DOUBLE
         y: DOUBLE
      do
         create coefficients.make_column( length )

         y := 2.0*Pi/( 1.0*coefficients.length )

         from
            i := 0
         until
            i >= length
         loop
            x := y*i
            g.set( cosine(x), sine(x) )
            coefficients.put( g, i + 1 )
            i := i + 1
         end

      end

   set_default_windower is
      local
         default_windower: DEFAULT_WINDOWER_DOUBLE
      do
         create window.make_column( length )
         create default_windower.make( length )
         set_windower( default_windower )
      end

   bit_reverse_output is
      require
         output_length_ok: output /= Void and then output.length = length
      local
         i: INTEGER
         ibrv: INTEGER
         g: COMPLEX_DOUBLE
      do

         from
            i := 0
         until
            i >= length
         loop

            ibrv := bit_reverse.item(i+1)

            if ibrv >= i then
               g := output.item(i+1)
               output.put( output.item(ibrv+1), i+1)
               output.put( g, ibrv+1)
            end

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

end -- class FFT_COMPLEX_DOUBLE
