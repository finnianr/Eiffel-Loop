note
	description: "[
		Locale that defines the language used for translations keys via the
		country code id `key_language'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-23 9:41:05 GMT (Saturday 23rd November 2019)"
	revision: "7"

deferred class
	EL_DEFAULT_LOCALE_I

inherit
	EL_LOCALE_I
		rename
			make as make_with_language
		redefine
			in
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

feature {NONE} -- Initialization

 	make
 		do
 			make_solitary
 			make_with_language (key_language, key_language)
 			create other_locales.make_equal (3, agent new_locale)
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
					Result := other_locales.item (a_language)
				end_restriction
			end
		end

	key_language: STRING
			-- language of translation keys
		deferred
		end

feature {NONE} -- Implementation

	new_locale (a_language: STRING): like in
		do
			create {EL_LOCALE_IMP} Result.make (a_language, Key_language)
		end

feature {NONE} -- Internal attributes

	other_locales: EL_CACHE_TABLE [EL_LOCALE_I, STRING]

end
