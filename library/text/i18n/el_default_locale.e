note
	description: "[
		Locale that defines the language used for translations keys via the
		country code id `key_language'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 11:10:54 GMT (Wednesday 25th September 2024)"
	revision: "23"

class
	EL_DEFAULT_LOCALE

inherit
	EL_LOCALE
		rename
			make as make_with_language,
			make_with_table as make_locale_with_table
		redefine
			in, make_default
		end

	EL_SHARED_KEY_LANGUAGE

create
	make, make_resources, make_from_location

feature {NONE} -- Initialization

	make
		do
			make_from_location (Directory.Application_installation)
		end

	make_resources
		-- make using locale files in "resources/locales" directory
		do
			make_from_location (Resources_dir)
		end

	make_from_location (locales_parent_dir: DIR_PATH)
		-- make from location `locales_parent_dir' with optional Pyxis source `a_adhoc_translations'
		-- (Useful for supplying decrypted credits for "about dialog")
		local
			table: EL_LOCALE_TABLE
		do
			create table.make (locales_parent_dir.plus_dir (Locales))

			make_with_language (user_language_code)
		end

	make_with_table (a_language: STRING; a_translation_table: detachable EL_TRANSLATION_TABLE)
		do
			make_locale_with_table (a_language, a_translation_table)
		end

	make_default
		do
			Precursor
			create other_locales.make_equal (3, agent new_locale)
		end

feature -- Access

	in (a_language: STRING): EL_LOCALE
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

feature -- Element change

	set_new_other_locale (a_new_locale: FUNCTION [STRING, EL_LOCALE])
		do
			other_locales.set_new_item (a_new_locale)
		end

feature {NONE} -- Implementation

	new_locale (a_language: STRING): EL_LOCALE
		do
			create Result.make (a_language)
		end

feature {NONE} -- Internal attributes

	other_locales: EL_AGENT_CACHE_TABLE [EL_LOCALE, STRING]

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