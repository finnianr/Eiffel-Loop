note
	description: "[
		Locale that defines the language used for translations keys via the
		country code id `key_language'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-17 10:34:40 GMT (Sunday 17th June 2018)"
	revision: "5"

deferred class
	EL_DEFAULT_LOCALE_I

inherit
	EL_LOCALE_I
		rename
			make as make_with_language
		redefine
			in
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
		require else
			language_has_translation: has_translation (a_language)
		do
			if a_language ~ Key_language then
				Result := Current
			else
				restrict_access
					if other_locales.has_key (a_language) then
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
