note
	description: "[
		Compare original {${WORD_TOKEN_TABLE}}.paragraph_list_tokens implementation to
		new one using routine {${ZSTRING}}.fill_alpha_numeric_intervals
	]"
	notes: "[
		Passes over 2500 millisecs (in descending order)

			fill_alpha_numeric_intervals :  962.0 times (100%)
			str.zcode (i)                :  861.0 times (-10.5%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-15 12:08:48 GMT (Monday 15th January 2024)"
	revision: "19"

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

	Description: STRING = "ZSTRING.fill_alpha_numeric_intervals VS str.zcode (i)"

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
			token_list := table.paragraph_list_tokens (paragraph_list)
		end

	i_th_zcode (paragraph_list: EL_ZSTRING_LIST)
		local
			table: WORD_TOKEN_TABLE; token_list: EL_WORD_TOKEN_LIST
		do
			create table.make (50)
			token_list := table.paragraph_list_tokens (paragraph_list)
		end

end