note
	description: "Default locale implemention for unlocalized applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-24 15:10:41 GMT (Friday 24th September 2021)"
	revision: "15"

class
	EL_DEFERRED_LOCALE_IMP

inherit
	ANY

	EL_DEFERRED_LOCALE_I

create
	make

feature {NONE} -- Initialization

	make
		do
			make_solitary
			create next_translations.make_empty (3)
			from until next_translations.count = 3 loop
				next_translations.extend (create {ZSTRING}.make_empty)
			end
		end

feature -- Status query

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
			next_translations [index].wipe_out
			next_translations [index].append_string_general (text)
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
			create Result.make_with_csv ("en")
		end

	Default_language: STRING = "en"

	Date_text: EL_ENGLISH_DATE_TEXT
		once
			create Result.make
		end

end