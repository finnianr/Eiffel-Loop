note
	description: "C language text pattern factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-18 7:54:30 GMT (Friday 18th November 2022)"
	revision: "4"

class
	EL_C_LANGUAGE_PATTERN_FACTORY

inherit
	EL_CODE_LANGUAGE_PATTERN_FACTORY

feature {NONE} -- C code patterns

	comment: like all_of
			--
		do
			Result := all_of (<<
				string_literal ("/*"),
				while_not_p1_repeat_p2 (string_literal ("*/"), any_character)
			>>)
		end

	one_line_comment: like all_of
			--
		do
			Result := all_of (<<
				string_literal ("//"), while_not_p_match_any (end_of_line_character)
			>>)
		end

	statement_block: like all_of
			--
		do
			Result := all_of ( <<
				character_literal ('{'),
				zero_or_more (
					one_of (<<
							comment,
							one_line_comment,
							quoted_string (Void),
							quoted_character (Void),
							not one_character_from ("{}"),
							recurse (agent statement_block, 1)
					>>)
				),
				character_literal ('}')
			>> )
		end

feature {NONE} -- String patterns

	identifier: EL_MATCH_C_IDENTIFIER_TP
		-- match C language identifier
		do
			Result := core.new_c_identifier
		end

	quoted_character (unescaped_action: detachable PROCEDURE [CHARACTER_32]): EL_MATCH_QUOTED_CHARACTER_TP
		do
		end

	quoted_string (
		unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): EL_MATCH_QUOTED_STRING_TP
		-- match C language string in quotes and call procedure `unescaped_action'
		-- with unescaped value
		do
			Result := core.new_c_quoted_string ('"', unescaped_action)
		end

feature {NONE} -- Implementation

	language_name: STRING
		do
			Result := "C"
		end

feature {NONE} -- Constants

	Code_table: EL_HASH_TABLE [INTEGER, CHARACTER]
		once
			create Result.make (<<
				['a', {ASCII}.bel], -- Bell alert
				['b', {ASCII}.Back_space],
				['e', {ASCII}.Esc], -- Escape
				['f', {ASCII}.Np], -- formfeed
				['n', {ASCII}.Line_feed],
				['r', {ASCII}.Carriage_return],
				['t', {ASCII}.Tabulation],
				['v', {ASCII}.Vt], -- Vertical Tab
				['\', {ASCII}.Backslash],
				['%'',{ASCII}.Singlequote],
				['"', {ASCII}.Doublequote],
				['?', {ASCII}.Questmark]
			>>)
		end

	Escape_character: CHARACTER_32 = '\'

end