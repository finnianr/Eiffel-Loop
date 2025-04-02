note
	description: "Evolicity equal to comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-01 9:30:43 GMT (Tuesday 1st April 2025)"
	revision: "12"

class
	EVC_EQUAL_TO_COMPARISON

inherit
	EVC_COMPARISON

create
	make

feature {NONE} -- Implementation

	compare (left, right: COMPARABLE)
			--
		do
			is_true := left.is_equal (right)
		end

	compare_real_64 (left, right: REAL_64)
		do
			is_true := left = right
		end

	compare_integer_64 (left, right: INTEGER_64)
		do
			is_true := left = right
		end

	compare_string_8 (left: READABLE_STRING_8; a_right: COMPARABLE; right_type_id: INTEGER)
		do
			inspect Class_id.type_category (right_type_id)
				when C_readable_string_8 then
					if attached {READABLE_STRING_8} a_right as right then
						is_true := left.same_string (right)
					end
				when C_readable_string_32 then
					if attached {READABLE_STRING_32} a_right as right_32 then
						if right_32.is_valid_as_string_8
							and then attached String_8_pool.sufficient_item (right_32.count) as borrowed
						then
							is_true := left.same_string (borrowed.copied_general (right_32))
							borrowed.return
						end
					end
			else
			end
		end

	compare_string_32 (left: READABLE_STRING_32; a_right: COMPARABLE; right_type_id: INTEGER)
		do
			inspect Class_id.type_category (right_type_id)
				when C_readable_string_32 then
					if attached {READABLE_STRING_32} a_right as right then
						is_true := left.same_string (right)
					end
				when C_readable_string_8 then
					if attached {READABLE_STRING_8} a_right as right_8 then
						if attached String_32_pool.sufficient_item (right_8.count) as borrowed then
							is_true := left.same_string (borrowed.copied_general (right_8))
							borrowed.return
						end
					end
			else
			end
		end

end