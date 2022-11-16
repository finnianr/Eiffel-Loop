note
	description: "C language text pattern factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 17:35:10 GMT (Wednesday 16th November 2022)"
	revision: "3"

class
	EL_C_LANGUAGE_PATTERN_FACTORY

inherit
	EL_CODE_LANGUAGE_PATTERN_FACTORY

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
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]
	): EL_MATCH_QUOTED_STRING_TP
		-- match C language string in quotes and call procedure `unescaped_action'
		-- with unescaped value
		do
			Result := core.new_c_quoted_string (quote, unescaped_action)
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