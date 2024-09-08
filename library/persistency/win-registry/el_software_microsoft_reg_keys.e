note
	description: "[
		Sub-key of registry key `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 12:50:21 GMT (Sunday 8th September 2024)"
	revision: "7"

class
	EL_SOFTWARE_MICROSOFT_REG_KEYS

create
	make

feature {NONE} -- Initialization

	make (name: STRING)
		do
			path := Microsoft_path #+ name
		end

feature -- Access

	path: DIR_PATH

	sub_dir_path (name: STRING): DIR_PATH
		do
			Result := path #+ name
		end

feature {NONE} -- Constants

	Microsoft_path: DIR_PATH
		once
			Result := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft"
		end

end