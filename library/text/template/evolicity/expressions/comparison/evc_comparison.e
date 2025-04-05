note
	description: "Evolicity comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 10:04:57 GMT (Saturday 5th April 2025)"
	revision: "17"

deferred class
	EVC_COMPARISON

inherit
	EVC_BOOLEAN_EXPRESSION

	EL_EXTENDED_REFLECTOR
		export
			{NONE} all
		end

	EL_SHARED_ZSTRING_BUFFER_POOL; EL_SHARED_STRING_8_BUFFER_POOL; EL_SHARED_STRING_32_BUFFER_POOL

feature -- Basic operation

	evaluate (context: EVC_CONTEXT)
			--
		local
			left, right: COMPARABLE; left_type_id, right_type_id: INTEGER
			left_integer: INTEGER_64; left_real: REAL_64
		do
			left_hand_expression.evaluate (context); right_hand_expression.evaluate (context)
			left := left_hand_expression.item; right := right_hand_expression.item

			left_type_id := dynamic_type (left); right_type_id := dynamic_type (right)

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
								left_integer := to_integer_64 (left, left_type_id)
								compare_integer_64 (left_integer, to_integer_64 (right, right_type_id))

							when C_real then
								left_real := to_real_64 (left, left_type_id)
								compare_real_64 (left_real, to_real_64 (right, right_type_id))
						else
						end

					when C_real then
						inspect Class_id.type_category (right_type_id)
							when C_integer, C_natural, C_real then
								left_real := to_real_64 (left, left_type_id)
								compare_real_64 (left_real, to_real_64 (right, right_type_id))
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