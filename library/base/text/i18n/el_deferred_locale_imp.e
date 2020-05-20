note
	description: "Default locale implemention for unlocalized applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-23 9:44:32 GMT (Saturday 23rd November 2019)"
	revision: "7"

class
	EL_DEFERRED_LOCALE_IMP

inherit
	EL_DEFERRED_LOCALE_I

	EL_SOLITARY

create
	make

feature {NONE} -- Implementation

	in (a_language: STRING): EL_DEFERRED_LOCALE_I
		do
			Result := Current
		end

	is_curly_brace_enclosed (key: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := key.count > 2 and then key [1] = '{' and then key [key.count] = '}'
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

feature {NONE} -- Constants

	All_languages: ARRAYED_LIST [STRING]
		once
			create Result.make_from_array (<< "en" >>)
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
