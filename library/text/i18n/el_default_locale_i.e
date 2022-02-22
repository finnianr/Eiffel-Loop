note
	description: "[
		Locale that defines the language used for translations keys via the
		country code id `key_language'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-22 9:48:06 GMT (Tuesday 22nd February 2022)"
	revision: "13"

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

	make_default
		do
			make (Directory.Application_installation)
		end

	make_resources
		-- make using locale files in "resources/locales" directory
		do
			make (Resources_dir)
		end

 	make (locales_parent_dir: DIR_PATH)
 		local
 			table: EL_LOCALE_TABLE
 		do
 			create table.make (locales_parent_dir #+ Locales)

 			make_with_language (user_language_code, key_language)
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

feature {NONE} -- Constants

	Locales: DIR_PATH
		-- directory name for locales
		once
			Result := "locales"
		end

	Resources_dir: DIR_PATH
		once
			Result := "resources"
		end

end