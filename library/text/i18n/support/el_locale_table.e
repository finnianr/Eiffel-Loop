note
	description: "Table of locale data file paths"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "6"

class
	EL_LOCALE_TABLE

inherit
	HASH_TABLE [FILE_PATH, STRING]
		rename
			make as make_table
		export
			{NONE} all
			{ANY} is_empty, has, current_keys, item
		end

	EL_SHARED_DIRECTORY

	EL_SOLITARY
		rename
			make as make_solitary
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_locale_dir: DIR_PATH)
		require
			locale_dir_exists: a_locale_dir.exists
		do
			make_solitary
			locale_dir := a_locale_dir
			make_equal (7)
			across Directory.named (locale_dir).files as path loop
				if path.item.base.count = 2 then
					extend (path.item, path.item.base)
				end
			end
		end

	make_default
		do
			make_solitary
			make_equal (0)
			create locale_dir
		end

feature -- Access

	locale_dir: DIR_PATH

	new_locale_path (language_id: STRING): FILE_PATH
		do
			Result := locale_dir + language_id
		end

end
