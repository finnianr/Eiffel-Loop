note
	description: "[
		Compare old method of paragraph tokenization to new one using 
		routine {[$source ZSTRING]}**.fill_alpha_numeric_intervals**
	]"
	notes: "[

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-26 18:48:29 GMT (Saturday 26th August 2023)"
	revision: "16"

class
	ZSTRING_TOKENIZATION_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	HEXAGRAM_NAMES
		export
			{NONE} all
		end

create
	make

feature -- Access

	Description: STRING = "{ZSTRING} fill_alpha_numeric_intervals VS str.zcode (i)"

feature -- Basic operations

	execute
		local
			part_list, paragraph_list: EL_ZSTRING_LIST
		do
			create paragraph_list.make (64)
			across Hexagram.String_arrays as array loop
				create part_list.make_from_general (array.item)
				paragraph_list.extend (part_list.joined (' '))
			end

			compare ("compare split list", <<
				["fill_alpha_numeric_intervals",	agent fill_alpha_numeric_intervals (paragraph_list)],
				["str.zcode (i)",						agent i_th_zcode (paragraph_list)]
			>>)
		end

feature {NONE} -- Operations

	fill_alpha_numeric_intervals (paragraph_list: EL_ZSTRING_LIST)
		local
			table: EL_WORD_TOKEN_TABLE; token_list: EL_WORD_TOKEN_LIST
		do
			create table.make (50)
			token_list := table.paragraph_list_tokens_2 (paragraph_list)
		end

	i_th_zcode (paragraph_list: EL_ZSTRING_LIST)
		local
			table: EL_WORD_TOKEN_TABLE; token_list: EL_WORD_TOKEN_LIST
		do
			create table.make (50)
			token_list := table.paragraph_list_tokens (paragraph_list)
		end

end