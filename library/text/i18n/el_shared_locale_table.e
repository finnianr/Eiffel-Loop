note
	description: "Shared locale table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_SHARED_LOCALE_TABLE

inherit
	EL_MODULE_DIRECTORY

feature {NONE} -- Factory

	new_locale_table: EL_LOCALE_TABLE
		do
			create Result.make (Directory.Application_installation)
		end

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
	 		Result := new_locale_table
	 	end

end
