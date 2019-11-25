note
	description: "Shared locale table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-25 11:37:12 GMT (Monday 25th November 2019)"
	revision: "6"

deferred class
	EL_SHARED_LOCALE_TABLE

inherit
	EL_MODULE_DIRECTORY

feature {NONE} -- Factory

	new_translation_table (language: STRING): EL_TRANSLATION_TABLE
		local
			items_list: EL_TRANSLATION_ITEMS_LIST
		do
			create items_list.make_from_file (Locale_table [language])
			items_list.retrieve
			Result := items_list.to_table (language)
		end

feature {NONE} -- Constants

	Locale_table: EL_LOCALE_TABLE
	 	-- Table of all locale data file paths
	 	once
			create Result.make (Locales_dir)
	 	end

	Locales_dir_name: ZSTRING
		once
			Result := "locales"
		end

	Locales_dir: EL_DIR_PATH
		once
			Result := Directory.Application_installation.joined_dir_tuple ([Locales_dir_name])
		end

end
