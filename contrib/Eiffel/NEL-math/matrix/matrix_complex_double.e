indexing
   description: "Matrices of COMPLEX_DOUBLEs"
   author: "Greg Lee"
   copyright: "Copyright (c) 2005, Greg Lee"
   license: "Eiffel Forum License v2 (see below)"
   date: "$Date: 2005/10/31 12:00:00 $"
   revision: "$Revision: 1.0 $"

class MATRIX_COMPLEX_DOUBLE
--
--    <--row-->
--                               ^
--    e11   e12   e13   e14      |
--    e21   e22   e23   e24      |
--    e31   e32   e33   e34      column
--    e41   e42   e43   e44      |
--                               |
--                               v
--
--    element( row, column )
--
--    height is number of rows
--    width is number of columns
--
--    first element ( upper left ) is at row = 1, col = 1
--
--    set_from_array takes a manifest array or array of DOUBLE stored
--    row by row << e11r, e11i, e12r, e12i, e13r, e13i, e14r, e14i,
--                  e21r, e21i, e22r, e22i, e23r, e23i, e24r, e24i,
--                  e31r, e31i, e32r, e32i, e33r, e33i, e34r, e34i,
--                  e41r, e41i, e42r, e42i, e43r, e43i, e44r, e44i >>
--
--    make_from_array adds two elements at the start to define the number of rows and the number of columns
--
--    e11   e12
--    e21   e22      can be initialized from
--    e31   e32      << 3, 2, e11re, e11im, e12re, e12im, e21re, e21im, e22re, e22im, e31re, e31im, e32re, e32im >>
--

inherit
   ARRAY[DOUBLE]
      rename
         make as array_make,
         item as array_item,
         put as array_put,
         force as array_force,
         resize as  array_resize,
         wipe_out as array_wipe_out,
         subcopy as array_subcopy,
         make_from_array as array_make_from_array
      redefine
         out
      end

create {ANY}
   make, make_from_array, make_from

feature {ANY} -- Initialization

   make (nb_rows, nb_columns: INTEGER) is
      -- Create a two dimensional array which has `nb_rows'
      -- rows and `nb_columns' columns,
      -- with lower bounds starting at 1.
      require
         not_flat: nb_rows > 0
         not_thin: nb_columns > 0
      do
         height := nb_rows
         width := nb_columns
         array_make (1, 2 * height * width)
      ensure
         new_count: count = 2 * height * width
      end

   make_from_array( a: ARRAY[DOUBLE] ) is
      require
         a_not_void: a /= Void
         minimum_size: a.count > 2
         size_ok: a.count = 2 + 2*( a.item(1)*a.item(2) ).floor
      local
         i: INTEGER
         i_row: INTEGER
         i_col: INTEGER
         n_row: INTEGER
         n_col: INTEGER
         c: COMPLEX_DOUBLE
      do

         n_row := a.item(1).floor
         n_col := a.item(2).floor

         make( n_row, n_col )

         from
            i := 3
            i_row := 1
            i_col := 1
         until
            i > a.count
         loop
            c.set( a.item(i), a.item(i+1) )
            put( c, i_row, i_col )
            i := i + 2

            i_col := i_col + 1
            if i_col > width then
               i_col := 1
               i_row := i_row + 1
            end
         end

      end

   make_from( a: like Current ) is
      require
         a_not_void: a /= Void
      do
         make( a.rows, a.columns )
         Current.copy(a)
      end

feature -- Access

   columns: INTEGER is
      do
         Result := width
      end

   rows: INTEGER is
      do
         Result := height
      end

   item alias "[]" (i_row: INTEGER; i_col: INTEGER): COMPLEX_DOUBLE assign put is
      local
         i: INTEGER
      do
         i := 2*( (i_row - 1) * width + ( i_col - 1 ) ) + 1
         Result.set( array_item(i), array_item(i+1) )
      end

feature -- Measurement


   height: INTEGER
         -- Number of rows

   width: INTEGER
         -- Number of columns

feature -- Status report

   max_item_magnitude: DOUBLE is
      local
         i: INTEGER
         j: INTEGER
      do
         Result := item( 1,1 ).magnitude

         from
            i := 1
         until
            i > height
         loop

            from
               j := 1
            until
               j > width
            loop
               if item(i,j).magnitude > Result then
                  Result := item(i,j).magnitude
               end
               j := j + 1
            end

            i := i + 1
         end
      end

   is_symmetric: BOOLEAN is
      local
         i: INTEGER
         j: INTEGER
      do
         if height /= width then
            Result := False
         else

            Result := True
            from
               i := 1
            until
               i > height or not Result
            loop

               from
                  j := 1
               until
                  j > width or not Result
               loop
                  if not item(i,j).is_equal( item(j,i) ) then
                     Result := False
                  end
                  j := j + 1
               end

               i := i + 1
            end
         end

      end

   is_hermitian_symmetric: BOOLEAN is
      local
         i: INTEGER
         j: INTEGER
      do
         if height /= width then
            Result := False
         else
            Result := True
            from
               i := 1
            until
               i > height or not Result
            loop

               from
                  j := i + 1
               until
                  j > width or not Result
               loop
                  if not item(i,j).is_equal( item(j,i).conjugated ) then
                     Result := False
                  end
                  j := j + 1
               end

               i := i + 1
            end
         end
      end

   is_approximately_symmetric( precision: DOUBLE ): BOOLEAN is
      local
         i: INTEGER
         j: INTEGER
         dr: DOUBLE
         di: DOUBLE
         m: DOUBLE
         p: DOUBLE
      do
         if height /= width then
            Result := False
         else

            m := max_item_magnitude

            p := m*precision

            Result := True
            from
               i := 1
            until
               i > height or not Result
            loop

               from
                  j := 1
               until
                  j > width or not Result
               loop
                  dr := ( item(i,j).r - item(j,i).r ).abs
                  di := ( item(i,j).i - item(j,i).i ).abs
                  if dr > p or di > p then
                     Result := False
                  end

                  j := j + 1
               end

               i := i + 1
            end
         end

      end

   is_approximately_hermitian_symmetric( precision: DOUBLE ): BOOLEAN is
      local
         i: INTEGER
         j: INTEGER
         dr: DOUBLE
         di: DOUBLE
         m: DOUBLE
         p: DOUBLE
      do
         if height /= width then
            Result := False
         else

            m := max_item_magnitude

            p := m*precision

            Result := True
            from
               i := 1
            until
               i > height or not Result
            loop

               from
                  j := 1
               until
                  j > width or not Result
               loop
                  dr := ( item(i,j).r - item(j,i).r ).abs
                  di := ( item(i,j).i + item(j,i).i ).abs
                  if dr > p or di > p then
                     Result := False
                  end

                  j := j + 1
               end

               i := i + 1
            end
         end

      end

feature -- Comparison

   is_approximately_equal(other: like Current; precision: DOUBLE ): BOOLEAN is
      local
         i: INTEGER
         j: INTEGER
         m: DOUBLE
         p: DOUBLE
         dr: DOUBLE
         di: DOUBLE
      do
         Result := True

         m := max_item_magnitude
         if other.max_item_magnitude > m then
            m := other.max_item_magnitude
         end

         p := m*precision

         from
            i := 1
         until
            i > height
         loop

            from
               j := 1
            until
               j > width
            loop

               dr := ( item(i,j).r - other.item(i,j).r ).abs
               di := ( item(i,j).i - other.item(i,j).i ).abs
               if dr > p or di > p then
                  Result := False
               end

               j := j + 1
            end

            i := i + 1
         end

      end

feature -- Element change

   put( v: COMPLEX_DOUBLE; row, column: INTEGER ) is
      require
         valid_row: 1 <= row and row <= height
         valid_column: 1 <= column and column <= width
      local
         i: INTEGER
      do
         i := 2*( (row - 1) * width + ( column - 1 ) ) + 1
         array_put(v.r, i)
         array_put(v.i, i+1)
      end

   set_from_array( a: ARRAY[DOUBLE] ) is
      require
         size_ok: a.count = 2*width*height
      local
         i: INTEGER
         i_row: INTEGER
         i_col: INTEGER
         c: COMPLEX_DOUBLE
      do

         from
            i := 1
            i_row := 1
            i_col := 1
         until
            i > a.count
         loop
            c.set( a.item(i), a.item(i+1) )
            put( c, i_row, i_col )
            i := i + 2

            i_col := i_col + 1
            if i_col > width then
               i_col := 1
               i_row := i_row + 1
            end

         end

      end

    set_from( other: MATRIX_COMPLEX_DOUBLE ) is
       require
          other_same_size: height = other.height and width = other.width
       local
          i: INTEGER
          j: INTEGER
       do
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               put( other.item(i,j), i, j)
               j := j + 1
            end
            i := i + 1
         end
       end

feature -- Iteration

   do_and_set_all (action: FUNCTION [ANY, TUPLE [COMPLEX_DOUBLE_REF], COMPLEX_DOUBLE_REF]) is
      -- Apply `action' to every non-void item.
      -- Semantics not guaranteed if `action' changes the structure;
      -- in such a case, apply iterator to clone of structure instead.
      require
         action_not_void: action /= Void
      local
         t: TUPLE [COMPLEX_DOUBLE_REF]
         i, j: INTEGER
         c: COMPLEX_DOUBLE_REF
      do
         from
            create t
            create c
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               c.set_from_expanded( item(i,j) )
               t.put( c, 1 )
               c := action.item(t)
               put( c.item, i, j )
               j := j + 1
            end
            i := i + 1
         end
      end

   do_and_set_if (action: FUNCTION [ANY, TUPLE [COMPLEX_DOUBLE_REF], COMPLEX_DOUBLE_REF]; test: FUNCTION [ANY, TUPLE [COMPLEX_DOUBLE_REF], BOOLEAN]) is
      -- Apply `action' to every non-void item that satisfies `test'.
      -- Semantics not guaranteed if `action' or `test' changes the structure;
      -- in such a case, apply iterator to clone of structure instead.
      require
         action_not_void: action /= Void
         test_not_void: test /= Void
      local
         t: TUPLE [COMPLEX_DOUBLE_REF]
         i, j: INTEGER
         c: COMPLEX_DOUBLE_REF
      do
         from
            create t
            create c
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               c.set_from_expanded( item(i,j) )
               t.put( c, 1 )
               if test.item(t) then
                  c := action.item(t)
                  put( c.item, i, j )
               end
               j := j + 1
            end
            i := i + 1
         end
      end

feature -- Output

   out: STRING is
      local
         i: INTEGER
         j: INTEGER
      do
         create Result.make(32)
         from
            i := 1
         until
            i > height
         loop
            Result.append("|%T")
            from
               j := 1
            until
               j > width
            loop
               Result.append(item(i,j).out)
               Result.append("%T")
               j := j + 1
            end
            Result.append("|%N")
            i := i + 1
         end
      end

   indexed_out: STRING is
      local
         i: INTEGER
         j: INTEGER
      do
         create Result.make(32)
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               Result.append( i.out )
               Result.append( "%T" )
               Result.append( j.out )
               Result.append("%T")
               Result.append(item(i,j).r.out)
               Result.append("%T")
               Result.append(item(i,j).i.out)
               Result.append("%N")
               j := j + 1
            end
            i := i + 1
         end
      end

feature -- Miscellaneous

   one: like Current is
      -- Neutral element for "*" and "/".
      local
         i, j: INTEGER
         c1: COMPLEX_DOUBLE
         c0: COMPLEX_DOUBLE
      do

         create Result.make(height,width)
         c1.set( 1.0, 0.0 )
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               if i /= j then
                  Result.put(c0,i,j)
               else
                  Result.put(c1,i,j)
               end
               j := j + 1
            end
            i := i + 1
         end
      end

   zero: like Current is
      -- Neutral element for "+" and "-".
      local
         i, j: INTEGER
         c0: COMPLEX_DOUBLE
      do
         create Result.make(height,width)
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               Result.put(c0,i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   set_to_one is
      -- set to Neutral element for "*" and "/".
      local
         i, j: INTEGER
         c1: COMPLEX_DOUBLE
         c0: COMPLEX_DOUBLE
      do
         c1.set( 1.0, 0.0 )
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               if i /= j then
                  put(c0,i,j)
               else
                  put(c1,i,j)
               end
               j := j + 1
            end
            i := i + 1
         end
      end

   set_to_zero is
      -- set to Neutral element for "+" and "-".
      local
         i, j: INTEGER
         c0: COMPLEX_DOUBLE
      do
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               put(c0,i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   copied: like Current is
      -- copy of Current
      do
         create Result.make(height,width)
         Result.copy( Current )
      end

   subcopied( i_row: INTEGER; n_row: INTEGER; i_col: INTEGER; n_col: INTEGER ): like Current is
      -- subcopy of Current, starting at i_row, i_col and extending for n_row, n_col
      local
         i, j: INTEGER
      do
         create Result.make(n_row,n_col)
         from
            i := 1
         until
            i > n_row
         loop
            from
               j := 1
            until
               j > n_col
            loop
               Result.put( item( i + i_row - 1, j + i_col - 1 ), i, j )
               j := j + 1
            end
            i := i + 1
         end
      end

   subcopy( other: like Current; i_row: INTEGER; i_row_other: INTEGER; n_row_other: INTEGER; i_col: INTEGER; i_col_other: INTEGER; n_col_other: INTEGER ) is
         -- subcopy of other into Current( i_row, i_col ), starting at other( i_row_other, i_col_other ) and extending for n_row_other, n_col_other
         -- elements not overwritten are not changed
      require
         other_not_void: other /= Void
         other_size_ok: ( other.height >= i_row_other + n_row_other - 1 ) and ( other.width >= i_col_other + n_col_other - 1 )
         current_size_ok: ( height >= i_row + n_row_other - 1) and ( width >= i_col + n_col_other -1 )
      local
         i, j: INTEGER
      do
         from
            i := 1
         until
            i > n_row_other
         loop
            from
               j := 1
            until
               j > n_col_other
            loop
               put( other.item( i + i_row_other - 1, j + i_col_other - 1 ), i + i_row - 1, j + i_col - 1)
               j := j + 1
            end
            i := i + 1
         end
      end

   vector_from_row( index: INTEGER ): VECTOR_COMPLEX_DOUBLE is
      require
         index_ok: index >= 1 and index <= height
      local
         i: INTEGER
      do
         create Result.make_row( width )
         from
            i := 1
         until
            i > width
         loop
            Result.put( item( index, i ), i )
            i := i + 1
         end
      end

   vector_from_column( index: INTEGER ): VECTOR_COMPLEX_DOUBLE is
      require
         index_ok: index >= 1 and index <= width
      local
         i: INTEGER
      do
         create Result.make_column( height )
         from
            i := 1
         until
            i > height
         loop
            Result.put( item( i, index ), i )
            i := i + 1
         end
      end

   row_vector_dot( index1: INTEGER; index2: INTEGER ): COMPLEX_DOUBLE is
      require
         index1_ok: index1 >= 1 and index1 <= height
         index2_ok: index2 >= 1 and index2 <= height
      local
         i: INTEGER
      do
         from
            i := 1
         until
            i > width
         loop
            Result := Result + item( index1, i ) * item( index2, i ).conjugated
            i := i + 1
         end
      end

   row_vector_squared_magnitude( index: INTEGER ): DOUBLE is
      require
         index_ok: index >= 1 and index <= height
      local
         i: INTEGER
      do
         from
            i := 1
         until
            i > width
         loop
            Result := Result + item( index, i ).r*item( index, i ).r + item( index, i ).i*item( index, i ).i
            i := i + 1
         end
      end

   row_vector_scale( g: COMPLEX_DOUBLE; index: INTEGER ) is
      require
         index_ok: index >= 1 and index <= height
      local
         i: INTEGER
      do
         from
            i := 1
         until
            i > width
         loop
            put( g*item( index, i ), index, i )
            i := i + 1
         end
      end

   column_vector_dot( index1: INTEGER; index2: INTEGER ): COMPLEX_DOUBLE is
      require
         index1_ok: index1 >= 1 and index1 <= width
         index2_ok: index2 >= 1 and index2 <= width
      local
         i: INTEGER
      do
         from
            i := 1
         until
            i > height
         loop
            Result := Result + item( i, index1 ) * item( i, index2 ).conjugated
         i := i + 1
         end
      end

   column_vector_squared_magnitude( index: INTEGER ): DOUBLE is
      require
         index_ok: index >= 1 and index <= width
      local
         i: INTEGER
      do
         from
            i := 1
         until
            i > height
         loop
            Result := Result + item( i, index ).r*item( i, index ).r + item( i, index ).i*item( i, index ).i
            i := i + 1
         end
      end

   column_vector_scale( g: COMPLEX_DOUBLE; index: INTEGER ) is
      require
         index_ok: index >= 1 and index <= width
      local
         i: INTEGER
      do
         from
            i := 1
         until
            i > height
         loop
            put( g*item( i, index ), i, index )
            i := i + 1
         end
      end

feature -- Basic operations

   infix "+"(other: like Current): like Current is
      require
         other_not_void: other /= Void
         other_same_height: other.height = height
         other_same_width: other.width = width
      local
         i, j: INTEGER
      do
         create Result.make(height,width)
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               Result.put(item(i,j) + other.item(i,j),i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   add(other: like Current) is
      require
         other_not_void: other /= Void
         other_same_height: other.height = height
         other_same_width: other.width = width
      local
         i, j: INTEGER
      do
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               put(item(i,j) + other.item(i,j),i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   infix "-"(other: like Current): like Current is
      require
         other_not_void: other /= Void
         other_same_height: other.height = height
         other_same_width: other.width = width
      local
         i, j: INTEGER
      do
         create Result.make(height,width)
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               Result.put(item(i,j) - other.item(i,j),i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   subtract(other: like Current) is
      require
         other_not_void: other /= Void
         other_same_height: other.height = height
         other_same_width: other.width = width
      local
         i, j: INTEGER
      do
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               put(item(i,j) - other.item(i,j),i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   infix "*"(other: like Current): like Current is
      -- Multiplication of `Current' by `other'
      require
         other_not_void: other /= Void
         compatible_size: width = other.height
      local
         i, j, k: INTEGER
         sum: COMPLEX_DOUBLE
      do
         create Result.make(height,other.width)
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > other.width
            loop
               sum := complex_double.zero
               from
                  k := 1
               until
                  k > width
               loop
                  sum := sum + item(i,k) * other.item(k,j)
                  k := k + 1
               end
               Result.put(sum,i,j)
               j := j + 1
            end
            i := i + 1
         end
      ensure
         Result.height = height
         Result.width = other.width
      end

   multiply(other: like Current) is
      -- Multiplication of `Current' by `other'
      require
         other_not_void: other /= Void
         compatible_size: width = other.height
      local
         i, j, k: INTEGER
         sum: COMPLEX_DOUBLE
         temp: like Current
      do
         temp := Current.zero
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > other.width
            loop
               sum := complex_double.zero
               from
                  k := 1
               until
                  k > width
               loop
                  sum := sum + item(i,k) * other.item(k,j)
                  k := k + 1
               end
               temp.put(sum,i,j)
               j := j + 1
            end
            i := i + 1
         end
         Current.copy( temp )
      end

   item_by_item_multiplied, infix "#*"(other: like Current): like Current is
      -- Item-by-item multiplication of `Current' by `other'
      require
         other_not_void: other /= Void
         other_same_height: other.height = height
         other_same_width: other.width = width
      local
         i, j: INTEGER
      do
         create Result.make(height,other.width)
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               Result.put(item(i,j) * other.item(i,j),i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   item_by_item_multiply(other: like Current) is
      -- Item-by-item multiplication of `Current' by `other'
      require
         other_not_void: other /= Void
         other_same_height: other.height = height
         other_same_width: other.width = width
      local
         i, j: INTEGER
      do
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               put(item(i,j) * other.item(i,j),i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   scaled_by( g: COMPLEX_DOUBLE): like Current is
      -- Item-by-item multiplication of `Current' by g
      local
         i, j: INTEGER
      do
         create Result.make_from( Current )
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               Result.put(item(i,j) * g,i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   scale_by( g: COMPLEX_DOUBLE) is
      -- Item-by-item multiplication of `Current' by g
      local
         i, j: INTEGER
      do
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               put(item(i,j) * g,i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   prefix "+": like Current is
      -- Deep copy of Current
      do
         create Result.make_from(Current)
      ensure
         result_exists: Result /= Void
         same_height: Result.height = height
         same_width: Result.width = width
      end

   prefix "-": like Current is
      -- If Current is A + iB then
      -- result will be -A -iB
      do
         create Result.make_from(Current)
         Result.negate
      ensure
         result_exists: Result /= Void
         same_height: Result.height = height
         same_width: Result.width = width
      end

   negate is
      local
         i, j: INTEGER
      do
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               put(- item(i,j),i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   transposed: like Current is
      local
         i: INTEGER
         j: INTEGER
      do
         create Result.make(width,height)
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               Result.put(item(i,j),j,i)
               j := j + 1
            end
            i := i + 1
         end
      end

   transpose is
      require
         square_matrix: height = width
      local
         i: INTEGER
         j: INTEGER
         x: COMPLEX_DOUBLE
      do
         from
            i := 1
         until
            i > height
         loop
            from
               j := i
            until
               j > width
            loop
               if i /= j then
                  x := item(i,j)
                  put(item(j,i),i,j)
                  put(x,j,i)
               end
               j := j + 1
            end
            i := i + 1
         end
      end

   hermitian_transposed: like Current is
      local
         i: INTEGER
         j: INTEGER
      do
         create Result.make(width,height)
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               Result.put(item(i,j).conjugated,j,i)
               j := j + 1
            end
            i := i + 1
         end
      end

   hermitian_transpose is
      require
         square_matrix: height = width
      local
         i: INTEGER
         j: INTEGER
         x: COMPLEX_DOUBLE
      do
         from
            i := 1
         until
            i > height
         loop
            from
               j := i
            until
               j > width
            loop
               if i /= j then
                  x := item(i,j).conjugated
                  put(item(j,i).conjugated,i,j)
                  put(x,j,i)
               end
               j := j + 1
            end
            i := i + 1
         end
      end

   conjugated: like Current is
      local
         i: INTEGER
         j: INTEGER
      do
         create Result.make(height,width)
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               Result.put(item(i,j).conjugated,i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   conjugate is
      local
         i: INTEGER
         j: INTEGER
         c: COMPLEX_DOUBLE
      do
         from
            i := 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > width
            loop
               c := item(i,j)
               c.conjugate
               put(c,i,j)
               j := j + 1
            end
            i := i + 1
         end
      end

   swapped ( size: INTEGER ): like Current is
      local
         i, j: INTEGER
      do
         create Result.make( height, width )
         from
            i := 1
         until
            i > height - size
         loop
            from
               j := 1
            until
               j > width - size
            loop
               Result.put( item ( size + i, size + j ), i, j )
               j := j + 1
            end
            i := i + 1
         end
         from
            i := 1
         until
            i > size
         loop
            from
               j := 1
            until
               j > size
            loop
               Result.put( item ( i, j ), height - size + i, width -  size + j  )
               j := j + 1
            end
            i := i + 1
         end

         from
            i := 1
         until
            i > size
         loop
            from
               j := size + 1
            until
               j > width
            loop
               Result.put( item ( i, j ), height - size + i, j - size )
               j := j + 1
            end
            i := i + 1
         end

         from
            i := size + 1
         until
            i > height
         loop
            from
               j := 1
            until
               j > size
            loop
               Result.put( item ( i, j ), i - size, width - size + j )
               j := j + 1
            end
            i := i + 1
         end
      end

   invert is
      require
         square_matrix: rows = columns
         determinant_nonzero: determinant /= complex_double.zero
      local
         i: INTEGER
         j: INTEGER
         k: INTEGER
         u: COMPLEX_DOUBLE
         v: COMPLEX_DOUBLE
         temp: COMPLEX_DOUBLE
         flag: BOOLEAN
         a: like Current
         b: like Current
      do
         a := Current.copied
         create b.make( a.rows, a.columns )
         b.set_to_one

         from
            i := 1
         until
            i > a.rows
         loop

            if a.item(i, i ) = complex_double.zero then

            -- if the main diagonal value is zero
            -- re-sort the remaining columns

               from
                  j := i + 1
                  flag := False
               until
                  j > a.rows or flag
               loop
                  if a.item(j, i) /= complex_double.zero then
                     from
                        k := 1
                     until
                        k > a.rows
                     loop
                        temp := a.item(i, k)
                        a.put( a.item(j, k), i, k)
                        a.put( temp, j, k)
                        temp := b.item(i, k)
                        b.put( b.item(j, k), i, k)
                        b.put( temp, j, k)
                        k := k + 1
                     end
                     flag := True
                  end
                  j := j + 1
               end

            end

            u := a.item( i, i ).inverse

            from
               j := 1
            until
               j > a.rows
            loop
               v := a.item(i, j)*u
               a.put( v, i, j )
               v := b.item(i, j)*u
               b.put( v, i, j )
               j := j + 1
            end

            from
               k := 1
            until
               k > a.rows
            loop

               if k /= i then

                   u := a.item(k, i)

                  from
                     j := 1
                  until
                     j > a.rows
                  loop
                     v := a.item(k, j) - a.item(i, j)*u
                     a.put(v, k, j)
                     v := b.item(k, j) - b.item(i, j)*u
                     b.put(v, k, j)
                     j := j + 1
                  end

               end

               k := k + 1
            end

            i := i + 1
         end

         set_from( b )

      end

   inverse: like Current is
      require
         square_matrix: rows = columns
         determinant_nonzero: determinant /= complex_double.zero
      local
         i: INTEGER
         j: INTEGER
         k: INTEGER
         u: COMPLEX_DOUBLE
         v: COMPLEX_DOUBLE
         temp: COMPLEX_DOUBLE
         flag: BOOLEAN
         a: like Current
         b: like Current
      do
         a := Current.copied
         create b.make( a.rows, a.columns )
         b.set_to_one

         from
            i := 1
         until
            i > a.rows
         loop

            if a.item(i, i ) = complex_double.zero then

            -- if the main diagonal value is zero
            -- re-sort the remaining columns

               from
                  j := i + 1
                  flag := False
               until
                  j > a.rows or flag
               loop
                  if a.item(j, i) /= complex_double.zero then
                     from
                        k := 1
                     until
                        k > a.rows
                     loop
                        temp := a.item(i, k)
                        a.put( a.item(j, k), i, k)
                        a.put( temp, j, k)
                        temp := b.item(i, k)
                        b.put( b.item(j, k), i, k)
                        b.put( temp, j, k)
                        k := k + 1
                     end
                     flag := True
                  end
                  j := j + 1
               end

            end

            u := a.item( i, i ).inverse

            from
               j := 1
            until
               j > a.rows
            loop
               v := a.item(i, j)*u
               a.put( v, i, j )
               v := b.item(i, j)*u
               b.put( v, i, j )
               j := j + 1
            end

            from
               k := 1
            until
               k > a.rows
            loop

               if k /= i then

                   u := a.item(k, i)

                  from
                     j := 1
                  until
                     j > a.rows
                  loop
                     v := a.item(k, j) - a.item(i, j)*u
                     a.put(v, k, j)
                     v := b.item(k, j) - b.item(i, j)*u
                     b.put(v, k, j)
                     j := j + 1
                  end

               end

               k := k + 1
            end

            i := i + 1
         end

         Result := b

      end


   determinant: COMPLEX_DOUBLE is
      require
         square_matrix: rows = columns
      local
         a: like Current
         i: INTEGER
         j: INTEGER
         k: INTEGER
         factor: COMPLEX_DOUBLE
         temp: COMPLEX_DOUBLE
         det: COMPLEX_DOUBLE
         flag: BOOLEAN
      do
         -- Use Gauss-Jordan elimination to transform the matrix into
         -- an upper-triangular form (all matrix entries below the main
         -- diagonal equal to zero). The determinant of the transformed matrix
         -- is equal to the product of the entries on the main diagonal, and
         -- is also equal to the determinant of the original matrix.

         a := copied

         det := det.one

         from
            i := 1
         until
            ( i > a.rows ) or ( det = complex_double.zero )
         loop
            -- if the main diagonal value is zero
            -- swap the current column with one of the remaining columns

            if a.item(i, i) = complex_double.zero then

               from
                  j := i + 1
                  flag := False
               until
                  j > a.rows or flag
               loop
                  if a.item(j, i) /= complex_double.zero then
                     from
                        k := 1
                     until
                        k > a.rows
                     loop
                        temp := a.item(i, k)
                        a.put( a.item(j, k), i, k)
                        a.put( temp, j, k)
                        k := k + 1
                     end
                     -- For Gauss-Jordan elimination,
                     -- if we swap columns, the determinant
                     -- gets multiplied by -1
                     det := -det
                     flag := True
                  end
                  j := j + 1
               end

            end

            -- if after the resorting attempts, the main diagonal value is
            -- still zero, then the determinant is definitely zero
            if a.item(i, i) /= complex_double.zero then

               -- eliminate the items below the main diagonal to transform
               -- to upper triangular form
               from
                  j := i + 1
               until
                  j > a.rows
               loop
                  if a.item(j, i) /= complex_double.zero then
                     factor := a.item(j, i) / a.item(i, i)
                     from
                        k := i
                     until
                        k > a.rows
                     loop
                        a.put( ( a.item(j, k) - factor * a.item(i, k) ), j, k)
                        k := k + 1
                     end
                  end
                  j := j + 1
               end
            else
               det := complex_double.zero
            end

            i := i + 1
         end

         -- calculate the product of the entries on the main diagonal
         from
            i := 1
         until
            i > a.rows
         loop
            det := det * a.item(i, i)
            i := i + 1
         end

         Result := det
      end


   trace: COMPLEX_DOUBLE is
      require
         square_matrix: rows = columns
      local
         i: INTEGER
      do
         -- sum the entries on the main diagonal
         from
            i := 1
         until
            i > rows
         loop
            Result := Result + item(i, i)
            i := i + 1
         end
      end

feature -- Inapplicable

   complex_double: COMPLEX_DOUBLE is
      local
         c: COMPLEX_DOUBLE
      once
         Result := c
      end

invariant

   valid_height: height >= 1
   valid_width: width >= 1

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

end -- class MATRIX_COMPLEX_DOUBLE
