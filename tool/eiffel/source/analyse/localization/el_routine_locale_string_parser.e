note
	description: "Scans lines from a routine for locale string identifiers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_ROUTINE_LOCALE_STRING_PARSER

inherit
	EL_PARSER
		rename
			make_default as make
		redefine
			reset, make
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
				string_literal ("-- quantity_translation:"), non_breaking_white_space,
				all_of_separated_by (maybe_non_breaking_white_space, <<
					integer |to| agent on_lower , string_literal (".."), integer |to| agent on_upper
				>>)
			>>)
		end

	pattern_locale_string: like all_of
		-- Parse for eg. ["currency_label", agent locale_string ("{currency-label}")]
		-- `locale_string' is only defined in client code that uses i18n library
		do
			Result := all_of_separated_by (maybe_non_breaking_white_space, <<
				string_literal ("locale_string"),
				character_literal ('('),
				quoted_manifest_string (agent on_locale_string)
			>>)
		end

	pattern_locale_asterisk: like all_of
		do
			Result := all_of (<<
				pattern_locale_variable, optional (pattern_in_language),
				maybe_non_breaking_white_space, character_literal ('*'), maybe_non_breaking_white_space,
				quoted_manifest_string (agent on_locale_string)
			>>)
		end

	pattern_routine_argument: like all_of
		do
			Result := all_of (<<
				pattern_locale_variable, optional (pattern_in_language), dot_literal,
				c_identifier |to| agent on_identifier,
				non_breaking_white_space, character_literal ('('), maybe_white_space,
				quoted_manifest_string (agent on_locale_string)
			>>)
		end

	pattern_in_language: like all_of
		-- matches:
		-- 	in ("en")
		--		in (lang)
		do
			Result := all_of (<<
				string_literal (".in"),
				maybe_non_breaking_white_space, character_literal ('('),
				one_of (<< quoted_manifest_string (Default_action), qualified_identifier >>),
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

	on_lower (matched: EL_STRING_VIEW)
		do
			quantity_lower := matched.to_string.to_integer
		end

	on_upper (matched: EL_STRING_VIEW)
		do
			quantity_upper := matched.to_string.to_integer
		end

	on_identifier (matched: EL_STRING_VIEW)
		do
			last_identifier := matched
		end

	on_locale_string (matched: EL_STRING_VIEW)
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
						locale_keys.extend (matched.to_string + suffix.item)
					end
				end

			elseif last_identifier /~ Set_next_translation then
				locale_keys.extend (matched)
			end
			last_identifier.wipe_out
		end

feature {NONE} -- Internal attributes

	last_identifier: ZSTRING

	quantity_lower: INTEGER

	quantity_upper: INTEGER

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