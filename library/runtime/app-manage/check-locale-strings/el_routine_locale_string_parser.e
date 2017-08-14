note
	description: "Scans lines from a routine for locale string identifiers"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	EL_SHARED_LOCALE_TABLE

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
		end

feature {NONE} -- Patterns

	new_pattern: like one_of
			--
		do
			Result := one_of (<<
				comment,
				pattern_locale_asterisk,
				pattern_routine_argument
			>>)
		end

	pattern_locale_asterisk: like all_of
		do
			Result := all_of_separated_by (non_breaking_white_space, <<
				string_literal ("Locale"), character_literal ('*'), quoted_manifest_string (agent on_locale_string)
			>>)
		end

	pattern_routine_argument: like all_of
		do
			Result := all_of (<<
				string_literal ("Locale."), c_identifier |to| agent on_identifier,
				non_breaking_white_space, character_literal ('('), maybe_white_space,
				quoted_manifest_string (agent on_locale_string)
			>>)
		end

feature {NONE} -- Implementation

	on_identifier (matched: EL_STRING_VIEW)
		do
			last_identifier := matched
		end

	on_locale_string (matched: EL_STRING_VIEW)
		do
			if last_identifier ~ Quantity_translation_extra then
				across Dot_suffixes as suffix loop
					locale_keys.extend (matched.to_string + suffix.item)
				end

			elseif last_identifier /~ Set_next_translation then
				locale_keys.extend (matched)
			end
			last_identifier.wipe_out
		end

feature {NONE} -- Internal attributes

	last_identifier: ZSTRING

feature {NONE} -- Constants

	Quantity_translation_extra: ZSTRING
		once
			Result := "quantity_translation_extra"
		end

	Set_next_translation: ZSTRING
		once
			Result := "set_next_translation"
		end
end
