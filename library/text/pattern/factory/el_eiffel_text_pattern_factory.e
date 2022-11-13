note
	description: "Eiffel language text pattern factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-13 9:20:10 GMT (Sunday 13th November 2022)"
	revision: "7"

deferred class
	EL_EIFFEL_TEXT_PATTERN_FACTORY

inherit
	EL_CODE_LANGUAGE_PATTERN_FACTORY
		redefine
			escaped_character_sequence
		end

feature {NONE} -- Eiffel comments

	comment: like all_of
			--
		do
			Result := all_of (<< comment_prefix, zero_or_more (not character_literal ('%N')) >>)
		end

	comment_prefix: EL_LITERAL_TEXT_PATTERN
		do
			Result := string_literal ("--")
		end

feature -- Identifiers

	class_name: like c_identifier
			--
		do
			Result := c_identifier
			Result.set_upper
		end

	identifier: like c_identifier
			--
		do
			Result := c_identifier
			Result.set_letter_first
		end

feature -- Type specifier

	class_type: like all_of
		do
			Result := all_of (<<
				class_name,
				optional (all_of (<< optional_white_space, type_list >>)) -- Generic parameter
			>>)
		end

	type_list: like all_of
		do
			Result := all_of (<<
				character_literal ('['),
				optional_white_space,
				recurse (agent class_type, 1),
				zero_or_more (
					all_of (<<
						optional_white_space, character_literal (','),
						optional_white_space,
						recurse (agent class_type, 1)
					>>)
				),
				character_literal (']')
			>>)
		end

feature {NONE} -- Eiffel character manifest

	character_manifest (unescaped_action: detachable PROCEDURE [STRING_GENERAL]): like quoted_eiffel_string
			--
		do
			Result := quoted_eiffel_string ('%'', unescaped_action)
		end

feature {NONE} -- Eiffel manifest string

	decimal_character_code: like all_of
		do
			Result :=  all_of (<< character_literal ('/'), digit #occurs (1 |..| 3), character_literal ('/') >>)
		end

	escaped_character_sequence: like all_of
			--
		do
			Result := all_of (<<
				character_literal (Escape_character),
				one_of (<< decimal_character_code, special_character >>)
			>>)
		end

	unescaped_manifest_string (action_to_process_content: like OPTIONAL_ACTION): like all_of
			-- String starting with
			--
			--		"[
			-- 		and ending with
			--		]"
		local
			characters_plus_end_quote: like while_not_p1_repeat_p2
			end_delimiter: like all_of
		do
			end_delimiter := all_of (<<
				end_of_line_character,
				optional_white_space,
				string_literal ("]%"")
			>>)
			characters_plus_end_quote := while_not_p1_repeat_p2 (end_delimiter, any_character)
			Result := all_of (<<
				string_literal ("%"["),
				optional_nonbreaking_white_space,
				one_of (<<
					end_delimiter,
					all_of (<< end_of_line_character, characters_plus_end_quote >>)
				>>)
			>>)
			if attached action_to_process_content as action then
				characters_plus_end_quote.set_action_combined_p2 (action)
			end
		end

feature {NONE} -- Implementation

	language_name: STRING
		do
			Result := "Eiffel"
		end

feature {NONE} -- Constants

	Code_table: EL_HASH_TABLE [INTEGER, CHARACTER]
		once
			create Result.make (<<
				['A', {ASCII}.Commercial_at], -- @
				['B', {ASCII}.Back_space],
				['C', {ASCII}.Circumflex], -- ^
				['D', {ASCII}.Dollar], -- $
				['F', {ASCII}.np], -- formfeed, new page
				['H', {ASCII}.Backslash], -- \
				['L', {ASCII}.Tilde], -- ~
				['N', {ASCII}.Line_feed],
				['Q', {ASCII}.Grave_accent], -- `
				['R', {ASCII}.Carriage_return],
				['T', {ASCII}.Tabulation],
				['U', {ASCII}.Nul],
				['V', {ASCII}.Bar], -- |
				['%%', {ASCII}.Percent],
				['%'', {ASCII}.Singlequote],
				['"', {ASCII}.Doublequote],
				['(', {ASCII}.Lbracket], -- [
				[')', {ASCII}.Rbracket], -- ]
				['<', {ASCII}.Opening_brace], -- {
				['>', {ASCII}.Closing_brace] -- }
			>>)
		end

	Escape_character: CHARACTER_32 = '%%'

end