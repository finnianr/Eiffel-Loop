note
	description: "[
		Sub-key of registry keys `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows'
		or `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 9:24:50 GMT (Sunday 8th September 2024)"
	revision: "8"

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
			path.set_base (path.base + " NT")
		end

feature -- Access

	current_version (name: STRING): DIR_PATH
		do
			Result := current_version_path #+ name
		end

	current_version_path: DIR_PATH
		do
			Result := sub_dir_path ("CurrentVersion")
		end

end