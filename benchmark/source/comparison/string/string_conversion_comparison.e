note
	description: "[
		Compare ${READABLE_STRING_GENERAL}.to_integer with ${EL_STRING_TO_INTEGER_32}.as_type
	]"
	notes: "[
		Passes over 500 millisecs (in descending order)

			{READABLE_STRING_GENERAL}.to_integer : 1128.0 times (100%) -- WINNER
			{EL_STRING_TO_INTEGER_32}.as_type    :  503.0 times (-55.4%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-24 11:28:29 GMT (Monday 24th March 2025)"
	revision: "1"

class
	STRING_CONVERSION_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON
		redefine
			initialize
		end

create
	make

feature {NONE} -- Internal attributes

	initialize
		do
			create integer_32_converter.make
			create string_list.make_filled (1000, agent to_string)
		end

feature -- Access

	Description: STRING = "STRING.to_integer VS EL_STRING_TO_INTEGER_32.as_type"

feature -- Basic operations

	execute
		do
			compare (Description, <<
				["{READABLE_STRING_GENERAL}.to_integer", agent to_integer],
				["{EL_STRING_TO_INTEGER_32}.as_type",	  agent as_type]
			>>)
		end

feature {NONE} -- String append variations

	as_type: STRING
		local
			n: INTEGER
		do
			across string_list as list loop
				if integer_32_converter.is_convertible (list.item) then
					n := integer_32_converter.as_type (list.item)
				end
			end
		end

	to_integer: STRING
		local
			n: INTEGER
		do
			across string_list as list loop
				if list.item.is_integer then
					n := list.item.to_integer
				end
			end
		end

feature {NONE} -- Implementation

	to_string (n: INTEGER): STRING
		do
			Result := n.out
		end

feature {NONE} -- Internal attributes

	integer_32_converter: EL_STRING_TO_INTEGER_32

	string_list: EL_STRING_8_LIST

end