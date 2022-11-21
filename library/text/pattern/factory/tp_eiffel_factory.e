note
	description: "Eiffel language text pattern factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:57 GMT (Monday 21st November 2022)"
	revision: "6"

deferred class
	TP_EIFFEL_FACTORY

inherit
	TP_CODE_LANGUAGE_FACTORY
		redefine
			escaped_character_sequence
		end

	EL_SHARED_ZSTRING_CODEC

	EL_EIFFEL_KEYWORDS

feature {NONE} -- Eiffel text patterns

	bracketed_expression: like all_of
			--
		do
			Result := all_of (<<
				character_literal ('('),
				zero_or_more (
					one_of (<<
						quoted_string (Void),
						not one_character_from ("()"),
						recurse (agent bracketed_expression, 1)
					>>)
				),
				character_literal (')')
			>>)
		end

feature {NONE} -- Eiffel comments

	comment: like all_of
			--
		do
			Result := all_of (<< comment_prefix, while_not_p_match_any (end_of_line_character) >>)
		end

	comment_prefix: TP_LITERAL_PATTERN
		do
			Result := string_literal ("--")
		end

feature -- Identifiers

	class_name: TP_C_IDENTIFIER
			--
		do
			Result := core.new_c_identifier
			Result.set_upper
		end

	identifier: TP_C_IDENTIFIER
			--
		do
			Result := core.new_c_identifier
			Result.set_letter_first
		end

	qualified_identifier: like all_of
			--
		do
			Result := all_of (<<
				identifier, zero_or_more (all_of (<< character_literal ('.'), identifier >>))
			>>)
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

	quoted_character (unescaped_action: detachable PROCEDURE [CHARACTER_32]): TP_QUOTED_CHAR
		do
			Result := core.new_eiffel_quoted_character (unescaped_action)
		end

feature {NONE} -- Eiffel manifest string

	decimal_character_code: like all_of
		do
			Result := all_of (<< character_literal ('/'), digit #occurs (1 |..| 3), character_literal ('/') >>)
		end

	escaped_character_sequence: like all_of
			--
		do
			Result := all_of (<<
				character_literal (Escape_character),
				one_of (<< decimal_character_code, special_character >>)
			>>)
		end

	quoted_string (unescaped_action: detachable PROCEDURE [STRING_GENERAL]): TP_QUOTED_STRING
		-- match Eiffel language string in quotes and call procedure `unescaped_action'
		-- with unescaped value
		do
			Result := core.new_eiffel_quoted_string ('"', unescaped_action)
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




