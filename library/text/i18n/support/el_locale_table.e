note
	description: "Table of locale data file paths"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:29:02 GMT (Monday 1st July 2019)"
	revision: "2"

class
	EL_LOCALE_TABLE

inherit
	HASH_TABLE [EL_FILE_PATH, STRING]
		rename
			make as make_table
		export
			{NONE} all
			{ANY} is_empty, has, current_keys, item
		end

	EL_SHARED_DIRECTORY

create
	make, make_default

feature {NONE} -- Initialization

	make (a_locale_dir: like locale_dir)
		do
			locale_dir := a_locale_dir
			make_equal (7)
			across named_directory (locale_dir).files as path loop
				if path.item.base.starts_with (Locale_dot) and then path.item.extension.count = 2 then
					extend (path.item, path.item.extension)
				end
			end
		end

	make_default
		do
			make_equal (0)
			create locale_dir
		end

feature -- Access

	locale_dir: EL_DIR_PATH

	new_locale_path (language_id: STRING): EL_FILE_PATH
		do
			Result := locale_dir + (Locale_dot + language_id)
		end

feature {NONE} -- Constants

	Locale_dot: ZSTRING
		once
			Result := "locale."
		end
end
