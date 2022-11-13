note
	description: "C language text pattern factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-13 6:51:14 GMT (Sunday 13th November 2022)"
	revision: "1"

class
	EL_C_LANGUAGE_PATTERN_FACTORY

inherit
	EL_CODE_LANGUAGE_PATTERN_FACTORY

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