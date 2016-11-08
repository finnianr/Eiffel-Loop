note
	description: "Summary description for {EL_SOFTWARE_WINDOWS_REG_KEYS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-20 12:24:06 GMT (Thursday 20th October 2016)"
	revision: "1"

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

	current_version (name: STRING): EL_DIR_PATH
		do
			Result := current_version_path.joined_dir_path (name)
		end

	current_version_path: EL_DIR_PATH
		do
			Result := sub_dir_path ("CurrentVersion")
		end

end
