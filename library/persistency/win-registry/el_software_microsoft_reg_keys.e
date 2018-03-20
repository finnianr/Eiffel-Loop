note
	description: "Sub-key of registry key HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-07 12:10:21 GMT (Wednesday 7th March 2018)"
	revision: "2"

class
	EL_SOFTWARE_MICROSOFT_REG_KEYS

create
	make

feature {NONE} -- Initialization

	make (name: STRING)
		do
			path := Microsoft_path.joined_dir_path (name)
		end

feature -- Access

	path: EL_DIR_PATH

	sub_dir_path (name: STRING): EL_DIR_PATH
		do
			Result := path.joined_dir_path (name)
		end

feature {NONE} -- Constants

	Microsoft_path: EL_DIR_PATH
		once
			Result := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft"
		end

end
