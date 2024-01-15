note
	description: "[
		{[$source ZSTRING]}.append_general VS {[$source ZSTRING]}.append for [$source ZSTRING]
		argument
	]"
	notes: "[
		Passes over 500 millisecs (in descending order)

			append         : 28782.0 times (100%)
			append_general : 21594.0 times (-25.0%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-15 11:56:25 GMT (Monday 15th January 2024)"
	revision: "10"

class
	ZSTRING_APPEND_GENERAL_VS_APPEND

inherit
	STRING_BENCHMARK_COMPARISON

	EL_SHARED_ZSTRING_CODEC

create
	make

feature -- Access

	Description: STRING = "ZSTRING.append_general VS append"

feature -- Basic operations

	execute
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_from_general (Hexagram.English_titles)

			compare ("compare append_general VS append", <<
				["append_general", agent append_general (list)],
				["append",			 agent append (list)]
			>>)
		end

feature {NONE} -- append

	append (string_list: EL_ZSTRING_LIST)
		local
			str: ZSTRING
		do
			create str.make (string_list.character_count)
			across string_list as list loop
				str.append (list.item)
			end
		end

	append_general (string_list: EL_ZSTRING_LIST)
		local
			str: ZSTRING
		do
			create str.make (string_list.character_count)
			across string_list as list loop
				str.append_string_general (list.item)
			end
		end

end