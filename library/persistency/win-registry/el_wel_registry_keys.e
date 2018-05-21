note
	description: "Wel registry keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "2"

class
	EL_WEL_REGISTRY_KEYS

feature -- Access

	current_control_set (name: STRING): EL_DIR_PATH
		do
			Result := Current_control_set_path.joined_dir_path (name)
		end

feature -- Constants

	Windows: EL_SOFTWARE_MICROSOFT_WINDOWS_REG_KEYS
		once
			create Result.make
		end

	Windows_nt: EL_SOFTWARE_MICROSOFT_WINDOWS_REG_KEYS
		once
			create Result.make_nt
		end

	Internet_explorer: EL_SOFTWARE_MICROSOFT_REG_KEYS
		once
			create Result.make ("Internet Explorer")
		end

	Current_control_set_path: EL_DIR_PATH
		once
			Result := "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet"
		end

end
