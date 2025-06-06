note
	description: "[
		Compare ${EL_ZSTRING}.split_list with ${EL_ZSTRING_LIST}.make_split
	]"
	notes: "[
		${EL_ZSTRING}.split_list now incorporated into ${EL_ZSTRING_LIST}.make_split,
		so benchmark cannot be repeated, but originally this is the score:
		
		Passes over 500 millisecs (in descending order)

			ZSTRING.split_list         :  49048.0 times (100%)
			EL_ZSTRING_LIST.make_split :  45982.0 times (-6.3%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-03 9:26:46 GMT (Saturday 3rd May 2025)"
	revision: "23"

class
	ZSTRING_SPLIT_LIST_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	HEXAGRAM_NAMES_I

create
	make

feature -- Access

	Description: STRING = "ZSTRING.split_list VS make_split"

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