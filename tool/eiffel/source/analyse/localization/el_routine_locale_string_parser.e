note
	description: "Scans lines from a routine for locale string identifiers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 17:41:58 GMT (Wednesday 16th November 2022)"
	revision: "8"

class
	EL_ROUTINE_LOCALE_STRING_PARSER

inherit
	EL_PARSER
		rename
			make_default as make
		redefine
			reset, make, source_text
		end

	EL_EIFFEL_TEXT_PATTERN_FACTORY

	EL_LOCALE_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			create locale_keys.make_empty
			create last_identifier.make_empty
			Precursor
		end

feature -- Access

	locale_keys: EL_ZSTRING_LIST

feature -- Element change

	reset
		do
			Precursor
			locale_keys.wipe_out
			quantity_lower := 1
			quantity_upper := 0
		end

feature {NONE} -- Patterns

	new_pattern: like one_of
			--
		do
			Result := one_of (<<
				pattern_quantity_translation_hint, comment,
				pattern_locale_asterisk,
				pattern_routine_argument,
				pattern_locale_string
			>>)
		end

	pattern_quantity_translation_hint: like all_of
		-- parse `Locale.quantity_translation' hint, for example:
		-- quantity_translation: 1 .. 2
		do
			Result := all_of (<<
				string_literal ("-- quantity_translation:"), nonbreaking_white_space,
				all_of_separated_by (optional_nonbreaking_white_space, <<
					signed_integer |to| agent on_lower , string_literal (".."), signed_integer |to| agent on_upper
				>>)
			>>)
		end

	pattern_locale_string: like all_of
		-- Parse for eg. ["currency_label", agent locale_string ("{currency-label}")]
		-- `locale_string' is only defined in client code that uses i18n library
		do
			Result := all_of_separated_by (optional_nonbreaking_white_space, <<
				string_literal ("locale_string"),
				character_literal ('('),
				quoted_string (Void) |to| agent on_locale_string
			>>)
		end

	pattern_locale_asterisk: like all_of
		do
			Result := all_of (<<
				pattern_locale_variable, optional (pattern_in_language),
				optional_nonbreaking_white_space, character_literal ('*'), optional_nonbreaking_white_space,
				quoted_string (Void) |to| agent on_locale_string
			>>)
		end

	pattern_routine_argument: like all_of
		do
			Result := all_of (<<
				pattern_locale_variable, optional (pattern_in_language), dot_literal,
				identifier |to| agent on_identifier,
				nonbreaking_white_space, character_literal ('('), optional_white_space,
				quoted_string (Void) |to| agent on_locale_string
			>>)
		end

	pattern_in_language: like all_of
		-- matches:
		-- 	in ("en")
		--		in (lang)
		do
			Result := all_of (<<
				string_literal (".in"),
				optional_nonbreaking_white_space, character_literal ('('),
				one_of (<< quoted_string (Void), qualified_identifier >>),
				character_literal (')')
			>>)
		end

	pattern_locale_variable: like one_of
		do
			Result := one_of (<<
				string_literal ("Locale"), string_literal ("locale"), string_literal ("a_locale")
			>>)
		end

	dot_literal: like character_literal
		do
			Result := character_literal ('.')
		end

feature {NONE} -- Event handlers

	on_lower (start_index, end_index: INTEGER)
		do
			quantity_lower := source_substring (start_index, end_index, False).to_integer
		end

	on_upper (start_index, end_index: INTEGER)
		do
			quantity_upper := integer_32_substring (start_index, end_index)
		end

	on_identifier (start_index, end_index: INTEGER)
		do
			last_identifier := source_substring (start_index, end_index, True)
		end

	on_locale_string (start_index, end_index: INTEGER)
		local
			quantity_interval: INTEGER_INTERVAL
		do
			if last_identifier.starts_with (Quantity_translation) then
				if quantity_lower <= quantity_upper then
					quantity_interval := quantity_lower |..| quantity_upper
				else
					quantity_interval := 0 |..| 2
				end
				across Number_suffix as suffix loop
					if quantity_interval.has (suffix.cursor_index - 1) then
						locale_keys.extend (source_substring (start_index, end_index, False) + suffix.item)
					end
				end

			elseif last_identifier /~ Set_next_translation then
				locale_keys.extend (source_substring (start_index, end_index, True))
			end
			last_identifier.wipe_out
		end

feature {NONE} -- Internal attributes

	last_identifier: ZSTRING

	quantity_lower: INTEGER

	quantity_upper: INTEGER

	source_text: ZSTRING

feature {NONE} -- Constants

	Quantity_translation: ZSTRING
		once
			Result := "quantity_translation"
		end

	Set_next_translation: ZSTRING
		once
			Result := "set_next_translation"
		end
end