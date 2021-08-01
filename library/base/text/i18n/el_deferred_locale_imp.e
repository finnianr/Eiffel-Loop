note
	description: "Default locale implemention for unlocalized applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-01 14:34:23 GMT (Sunday 1st August 2021)"
	revision: "11"

class
	EL_DEFERRED_LOCALE_IMP

inherit
	ANY

	EL_DEFERRED_LOCALE_I
		rename
			make_solitary as make
		end

create
	make

feature -- Status query

	is_valid_quantity_key (key: READABLE_STRING_GENERAL; quantity: INTEGER): BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

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

	set_next_translation (text: READABLE_STRING_GENERAL)
		-- set text to return on next call to `translation' with key enclosed with curly braces "{}"
		do
			Next_translation.wipe_out
			Next_translation.append_string_general (text)
		end

	translated_string (table: like translations; key: READABLE_STRING_GENERAL): ZSTRING
		do
			if is_curly_brace_enclosed (key) then
				Result := next_translation.twin
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
		end

feature {NONE} -- Constants

	All_languages: EL_STRING_8_LIST
		once
			create Result.make_with_csv ("en")
		end

	Date_text: EL_ENGLISH_DATE_TEXT
		once
			create Result.make
		end

	Next_translation: ZSTRING
		once
			create Result.make_empty
		end

	Translations: EL_ZSTRING_HASH_TABLE [ZSTRING]
		once
			create Result.make_equal (0)
		end

end