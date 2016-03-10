note
	description: "[
		Establishes English as the key language to use for translation lookups
		Override this in EL_MODULE_LOCALE for other languages
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_ENGLISH_DEFAULT_LOCALE_ROUTINES

inherit
	EL_LOCALE_ROUTINES
		rename
			make as make_with_language
		end

create
	make

feature {NONE} -- Initialization

 	make
 		do
 			make_with_language (Key_language, Key_language)
 			create other_locales.make_equal (3)
 		end

feature -- Access

	in (a_language: STRING): EL_LOCALE_ROUTINES
		-- translation in another available language
		require
			language_has_translation: has_translation (a_language)
		do
			if a_language ~ Key_language then
				Result := Current
			else
				restrict_access
					other_locales.search (a_language)
					if other_locales.found then
						Result := other_locales.found_item
					else
						create Result.make (a_language, Key_language)
						other_locales.extend (Result, a_language)
					end
				end_restriction
			end
		end

feature {NONE} -- Implementation

	other_locales: HASH_TABLE [EL_LOCALE_ROUTINES, STRING]

feature {NONE} -- Constants

	Key_language: STRING
			-- language of translation keys
		once
			Result := "en"
		end

end
