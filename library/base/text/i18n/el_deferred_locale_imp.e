note
	description: "Deferred locale imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-22 17:49:26 GMT (Friday 22nd November 2019)"
	revision: "6"

class
	EL_DEFERRED_LOCALE_IMP

inherit
	EL_DEFERRED_LOCALE_I

create
	make

feature {NONE} -- Initialization

	in (a_language: STRING): EL_DEFERRED_LOCALE_I
		do
			Result := Current
		end

	make
		do
			create translations.make_equal (0)
			create next_translation.make_empty
			create date_text.make
		end

feature {NONE} -- Implementation

	is_curly_brace_enclosed (key: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := key.count > 2 and then key [1] = '{' and then key [key.count] = '}'
		end

	set_next_translation (text: READABLE_STRING_GENERAL)
		-- set text to return on next call to `translation' with key enclosed with curly braces "{}"
		do
			create next_translation.make_from_general (text)
		end

	translated_string (table: like translations; key: READABLE_STRING_GENERAL): ZSTRING
		do
			if is_curly_brace_enclosed (key) then
				Result := next_translation
			else
				create Result.make_from_general (key)
			end
		end

	translation_keys: ARRAY [ZSTRING]
		do
			create Result.make_empty
		end

feature {NONE} -- Internal attributes

	date_text: EL_ENGLISH_DATE_TEXT

	next_translation: ZSTRING

	translations: EL_ZSTRING_HASH_TABLE [ZSTRING]

feature {NONE} -- Constants

	All_languages: ARRAYED_LIST [STRING]
		once
			create Result.make_from_array (<< "en" >>)
		end

end
