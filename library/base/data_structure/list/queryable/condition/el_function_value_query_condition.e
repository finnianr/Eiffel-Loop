note
	description: "[
		Query condition to test if value of function with target G is equal to a specified value
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-08 11:34:59 GMT (Tuesday 8th August 2023)"
	revision: "3"

class
	EL_FUNCTION_VALUE_QUERY_CONDITION [G]

inherit
	EL_ROUTINE_QUERY_CONDITION [G]
		rename
			routine as value,
			make as make_condition
		redefine
			value, met
		end

create
	make

feature {NONE} -- Initialization

	make (a_target_value: ANY; a_value: like value)
		do
			make_condition (a_value)
			target_value := a_target_value
		end

feature -- Status query

	met (item: G): BOOLEAN
		-- True if `value' applied to `item' is equal to `target_value'
		do
			Result := Precursor (item) or else value.last_result.is_equal (target_value)
		end

feature {NONE} -- Implementation

	value: FUNCTION [G, ANY]

	target_value: ANY

end