note
	description: "Summary description for {EL_DEFERRED_LOCALE_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-29 10:39:28 GMT (Tuesday 29th August 2017)"
	revision: "2"

class
	EL_DEFERRED_LOCALE_IMP

inherit
	EL_DEFERRED_LOCALE_I

create
	make

feature {NONE} -- Initialization

	make
		do
			create translations.make_equal (0)
			create next_translation.make_empty
			create date_text.make
		end

feature {NONE} -- Implementation

	set_next_translation (text: READABLE_STRING_GENERAL)
		-- set text to return on next call to `translation' with key enclosed with curly braces "{}"
		do
			create next_translation.make_from_general (text)
		end

	translation_keys: ARRAY [ZSTRING]
		do
			create Result.make_empty
		end

	translated_string (table: like translations; key: READABLE_STRING_GENERAL): ZSTRING
		do
			if is_curly_brace_enclosed (key) then
				Result := next_translation
			else
				create Result.make_from_general (key)
			end
		end

	is_curly_brace_enclosed (key: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := key.count > 2 and then key [1] = '{' and then key [key.count] = '}'
		end

feature {NONE} -- Internal attributes

	next_translation: ZSTRING

	translations: EL_ZSTRING_HASH_TABLE [ZSTRING]

	date_text: EL_ENGLISH_DATE_TEXT
end
