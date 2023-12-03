note
	description: "[
		Compare {[$source EL_ZSTRING]}.split_list with {[$source EL_ZSTRING_LIST]}.make_split
	]"
	notes: "[
		[$source EL_ZSTRING].split_list now incorporated into [$source EL_ZSTRING_LIST].make_split,
		so benchmark cannot be repeated, but originally this is the score:
		
		Passes over 250 millisecs (in descending order)

			ZSTRING.split_list         : 24500.0 times (100%)
			EL_ZSTRING_LIST.make_split : 14231.0 times (-41.9%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-03 13:46:23 GMT (Sunday 3rd December 2023)"
	revision: "16"

class
	ZSTRING_SPLIT_LIST_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	HEXAGRAM_NAMES
		export
			{NONE} all
		end

create
	make

feature -- Access

	Description: STRING = "{ZSTRING} split_list VS make_split"

feature -- Basic operations

	execute
		local
			string_list: EL_ZSTRING_LIST
		do
			create string_list.make_from_general (Hexagram_1_title_list)

			compare ("compare split list", <<
				["ZSTRING.split_list",			 agent split_list (string_list)],
				["EL_ZSTRING_LIST.make_split", agent make_split (string_list)]
			>>)
		end

feature {NONE} -- Operations

	make_split (string_list: EL_ZSTRING_LIST)
		local
			list: EL_ZSTRING_LIST
		do
			across string_list as str loop
				create list.make_split (str.item, ' ')
			end
		end

	split_list (string_list: EL_ZSTRING_LIST)
		local
			list: EL_ZSTRING_LIST
		do
			across string_list as str loop
				list := str.item.split_list (' ')
			end
		end

end