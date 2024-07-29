note
	description: "Default locale implemention for unlocalized applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-29 9:38:30 GMT (Monday 29th July 2024)"
	revision: "22"

class
	EL_DEFERRED_LOCALE_IMP

inherit
	ANY

	EL_DEFERRED_LOCALE_I
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create next_translations.make_empty (3)
			from until next_translations.count = 3 loop
				next_translations.extend (create {ZSTRING}.make_empty)
			end
			create date_text.make (Current)
		end

feature -- Access

	date_text: EL_DATE_TEXT

	double_as_string (d: DOUBLE; likeness: STRING): STRING
		do
			Result := Format.double (likeness).formatted (d)
		end

	Decimal_point: CHARACTER = '.'

feature -- Status query

	has_language (a_language: STRING): BOOLEAN
		do
			Result := language ~ Default_language
		end

	is_valid_quantity_key (key: READABLE_STRING_GENERAL; quantity: INTEGER): BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	has_item_key (key: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `key' is present
		do
			Result := True
		end

	in (a_language: STRING): EL_DEFERRED_LOCALE_I
		do
			Result := Current
		end

	is_curly_brace_enclosed (key: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := key.count > 2 and then key [1] = '{' and then key [key.count] = '}'
		end

	language: STRING
		do
			Result := "en"
		end

	set_next_quantity_translation (quantity: INTEGER; text: READABLE_STRING_GENERAL)
		-- set text for next call to `quantity_translation_extra' with key enclosed with curly braces "{}"
		local
			index: INTEGER
		do
			index := quantity.abs.min (2)
			if attached next_translations [index] as zstr then
				zstr.wipe_out; zstr.append_string_general (text)
			end
		end

	set_next_translation (text: READABLE_STRING_GENERAL)
		-- set text to return on next call to `translation' with key enclosed with curly braces "{}"
		do
			set_next_quantity_translation (0, text)
		end

	translation_item (key: READABLE_STRING_GENERAL): ZSTRING
		-- by default returns `key' as a `ZSTRING' unless localization is enabled at an
		-- application level
		do
			if is_curly_brace_enclosed (key) then
				Result := next_translations [0].twin
			else
				create Result.make_from_general (key)
			end
		end

	translation_keys: ARRAY [ZSTRING]
		do
			create Result.make_empty
		end

	translation_template (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): EL_TEMPLATE [ZSTRING]
		do
			create Result.make (next_translations [quantity.abs.min (2)])
		end

feature {NONE} -- Internal attributes

	next_translations: SPECIAL [ZSTRING]

feature {NONE} -- Constants

	All_languages: EL_STRING_8_LIST
		once
			create Result.make_comma_split ("en")
		end

	Default_language: STRING = "en"

end