note
	description: "Software microsoft windows reg keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:51 GMT (Monday 3rd January 2022)"
	revision: "5"

class
	EL_SOFTWARE_MICROSOFT_WINDOWS_REG_KEYS

inherit
	EL_SOFTWARE_MICROSOFT_REG_KEYS
		rename
			make as make_keys
		end

create
	make, make_nt

feature {NONE} -- Initialization

	make
		do
			make_keys ("Windows")
		end

	make_nt
		do
			make
			path.base.append_string_general (" NT")
		end

feature -- Access

	current_version (name: STRING): DIR_PATH
		do
			Result := current_version_path.joined_dir_path (name)
		end

	current_version_path: DIR_PATH
		do
			Result := sub_dir_path ("CurrentVersion")
		end

end
