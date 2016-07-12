note
	description: "Summary description for {EL_DEFAULT_LOCALE_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 9:14:54 GMT (Friday 24th June 2016)"
	revision: "4"

deferred class
	EL_DEFAULT_LOCALE_I

inherit
	EL_LOCALE_I
		rename
			make as make_with_language
		end

feature {NONE} -- Initialization

 	make
 		do
 			make_with_language (key_language, key_language)
 			create other_locales.make_equal (3)
 		end

feature -- Access

	in (a_language: STRING): EL_LOCALE_I
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
						create {EL_LOCALE_IMP} Result.make (a_language, Key_language)
						other_locales.extend (Result, a_language)
					end
				end_restriction
			end
		end

	key_language: STRING
			-- language of translation keys
		deferred
		end

feature {NONE} -- Implementation

	other_locales: HASH_TABLE [EL_LOCALE_I, STRING]

end
