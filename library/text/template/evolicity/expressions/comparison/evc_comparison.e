note
	description: "Evolicity comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-20 15:36:41 GMT (Thursday 20th March 2025)"
	revision: "12"

deferred class
	EVC_COMPARISON

inherit
	EVC_BOOLEAN_EXPRESSION

	EL_TYPE_UTILITIES
		export
			{NONE} all
		end

	EL_SHARED_CLASS_ID

	EL_TYPE_CATEGORY_CONSTANTS

	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

	EL_SHARED_ZSTRING_BUFFER_POOL; EL_SHARED_STRING_8_BUFFER_POOL; EL_SHARED_STRING_32_BUFFER_POOL

feature -- Basic operation

	evaluate (context: EVC_CONTEXT)
			--
		local
			left, right: COMPARABLE; left_type_id, right_type_id: INTEGER
		do
			left_hand_expression.evaluate (context); right_hand_expression.evaluate (context)
			left := left_hand_expression.item; right := right_hand_expression.item

			left_type_id := {ISE_RUNTIME}.dynamic_type (left)
			right_type_id := {ISE_RUNTIME}.dynamic_type (right)

			if left_type_id = right_type_id then
				compare (left, right)
			else
				inspect Class_id.type_category (left_type_id)
					when C_readable_string_8 then
						if attached {READABLE_STRING_8} left as left_string_8 then
							compare_string_8 (left_string_8, right, right_type_id)
						end
					when C_readable_string_32 then
						if attached {READABLE_STRING_32} left as left_string_32 then
							compare_string_32 (left_string_32, right, right_type_id)
						end
					when C_integer, C_natural then
						inspect Class_id.type_category (right_type_id)
							when C_integer, C_natural then
								compare_integer_64 (to_integer_64 (left, left_type_id), to_integer_64 (right, right_type_id))
							when C_real then
								compare_real_64 (to_real_64 (left, left_type_id), to_real_64 (right, right_type_id))
						else
						end

					when C_real then
						inspect Class_id.type_category (right_type_id)
							when C_integer, C_natural, C_real then
								compare_real_64 (to_real_64 (left, left_type_id), to_real_64 (right, right_type_id))
						else
						end

				else
				end
			end
		end

feature -- Element change

	set_left_hand_expression (expression: EVC_COMPARABLE)
			--
		do
			left_hand_expression := expression
		end

	set_right_hand_expression (expression: EVC_COMPARABLE)
			--
		do
			right_hand_expression := expression
		end

feature {NONE} -- Implementation

	compare_like_string_8 (left: READABLE_STRING_8; a_right: COMPARABLE; right_type_id: INTEGER)
		do
			inspect Class_id.type_category (right_type_id)
				when C_readable_string_32 then
					if attached {READABLE_STRING_32} a_right as right_32
						and then attached String_pool.borrowed_batch (2) as borrowed
					then
						compare (borrowed [0].to_same (left), borrowed [1].to_same (right_32))
						String_pool.return (borrowed)
					end
				when C_readable_string_8 then
					if attached {READABLE_STRING_8} a_right as right then
						compare (left.as_string_8, right.as_string_8)
					end
			else
			end
		end

	compare_like_string_32 (left: READABLE_STRING_32; a_right: COMPARABLE; right_type_id: INTEGER)
		do
			if attached {READABLE_STRING_GENERAL} a_right as right
				and then attached String_pool.borrowed_batch (2) as borrowed
			then
				compare (borrowed [0].to_same (left), borrowed [1].to_same (right))
				String_pool.return (borrowed)
			end
		end

	is_real_type (n: COMPARABLE): BOOLEAN
			--
		do
			Result := attached {REAL_64_REF} n or else attached {REAL_32_REF} n
		end

	to_real_64 (n: COMPARABLE; type_id: INTEGER): REAL_64
		do
			inspect abstract_type_of_type (type_id + is_reference_type (type_id).to_integer)
				when Natural_8_type then
					if attached {NATURAL_8_REF} n as n_8 then
						Result := n_8.to_real_64
					end

				when Natural_16_type then
					if attached {NATURAL_16_REF} n as n_16 then
						Result := n_16.to_real_64
					end

				when Natural_32_type then
					if attached {NATURAL_32_REF} n as n_32 then
						Result := n_32.to_real_64
					end

				when Natural_64_type then
					if attached {NATURAL_64_REF} n as n_64 then
						Result := n_64.to_real_64
					end

				when Integer_8_type then
					if attached {INTEGER_8_REF} n as i_8 then
						Result := i_8.to_double
					end

				when Integer_16_type then
					if attached {INTEGER_16_REF} n as i_16 then
						Result := i_16.to_double
					end

				when Integer_32_type then
					if attached {INTEGER_32_REF} n as i_32 then
						Result := i_32.to_double
					end

				when Integer_64_type then
					if attached {INTEGER_64_REF} n as i_64 then
						Result := i_64.to_double
					end

				when Real_32_type then
					if attached {REAL_32_REF} n as r_32 then
						Result := r_32.to_double
					end

				when Real_64_type then
					if attached {REAL_64_REF} n as r_64 then
						Result := r_64.item
					end
			else
			end
		end

	to_integer_64 (n: COMPARABLE; type_id: INTEGER): INTEGER_64
		require
			is_numeric: attached {NUMERIC} n as numeric
			not_real_type: not is_real_type (n)
		do
			inspect abstract_type_of_type (type_id + is_reference_type (type_id).to_integer)
				when Natural_8_type then
					if attached {NATURAL_8_REF} n as n_8 then
						Result := n_8.to_integer_64
					end

				when Natural_16_type then
					if attached {NATURAL_16_REF} n as n_16 then
						Result := n_16.to_integer_64
					end

				when Natural_32_type then
					if attached {NATURAL_32_REF} n as n_32 then
						Result := n_32.to_integer_64
					end

				when Natural_64_type then
					if attached {NATURAL_64_REF} n as n_64 then
						Result := n_64.to_integer_64
					end

				when Integer_8_type then
					if attached {INTEGER_8_REF} n as i_8 then
						Result := i_8.to_integer_64
					end

				when Integer_16_type then
					if attached {INTEGER_16_REF} n as i_16 then
						Result := i_16.to_integer_64
					end

				when Integer_32_type then
					if attached {INTEGER_32_REF} n as i_32 then
						Result := i_32.to_integer_64
					end

				when Integer_64_type then
					if attached {INTEGER_64_REF} n as i_64 then
						Result := i_64.item
					end
			else
			end
		end

feature {NONE} -- Deferred

	compare (left, right: COMPARABLE)
			--
		deferred
		end

	compare_real_64 (left, right: REAL_64)
		deferred
		end

	compare_integer_64 (left, right: INTEGER_64)
		deferred
		end

	compare_string_8 (left: READABLE_STRING_8; right: COMPARABLE; right_type_id: INTEGER)
		deferred
		end

	compare_string_32 (left: READABLE_STRING_32; right: COMPARABLE; right_type_id: INTEGER)
		deferred
		end

feature {NONE} -- Internal attributes

	left_hand_expression: EVC_COMPARABLE

	right_hand_expression: EVC_COMPARABLE

end