note
	description: "Match quoted C language string with escaping"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 17:22:02 GMT (Monday 31st October 2022)"
	revision: "1"

class
	EL_MATCH_QUOTED_C_LANG_STRING_TP

inherit
	EL_MATCH_QUOTED_STRING_TP

create
	make

feature {NONE} -- Deferred

	language_name: STRING
		do
			Result := "C lang"
		end

	new_escape_sequence: like all_of
		do
			Result := all_of (<<
				character_literal ('\'), one_character_from (Code_key_string)
			>>)
		end

	unescaped (text: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): CHARACTER_32
		local
			l_count: INTEGER
		do
			l_count := end_index - start_index + 1
			if l_count = 2 then
				Result := Code_table [text [end_index].to_character_8].to_character_32
			end
		end

feature {NONE} -- Constants

	Code_key_string: STRING
		once
			create Result.make (Code_table.count)
			Code_table.current_keys.do_all (agent Result.extend)
		end

	Code_table: EL_HASH_TABLE [INTEGER, CHARACTER]
		once
			create Result.make (<<
				['a', {ASCII}.bel],
				['b', {ASCII}.Back_space],
				['e', {ASCII}.Esc],
				['f', {ASCII}.Np], -- formfeed
				['n', {ASCII}.Line_feed],
				['r', {ASCII}.Carriage_return],
				['t', {ASCII}.Tabulation],
				['v', {ASCII}.Vt], -- Vertical Tab
				['\', {ASCII}.Backslash],
				['%'', {ASCII}.Singlequote],
				['"', {ASCII}.Doublequote],
				['?', {ASCII}.Questmark]
			>>)
		end

end