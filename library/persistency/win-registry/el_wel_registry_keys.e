note
	description: "Windows common registry keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 13:16:31 GMT (Sunday 8th September 2024)"
	revision: "8"

class
	EL_WEL_REGISTRY_KEYS

feature -- Access

	current_control_set (name: STRING): DIR_PATH
		do
			Result := Current_control_set_path #+ name
		end

feature -- Basic operations

	as_current_user (a_path: DIR_PATH): DIR_PATH
		-- convert HKEY_LOCAL_MACHINE to HKEY_CURRENT_USER path
		local
			path: ZSTRING; slash_index: INTEGER
		do
			path := a_path
			slash_index := path.index_of ('\', 1)
			if slash_index > 0 then
				path.replace_substring_general (HKEY_current_user, 1, slash_index - 1)
			end
			Result := path
		end

feature -- Constants

	Current_control_set_path: DIR_PATH
		once
			Result := "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet"
		end

	HKEY_current_user: STRING = "HKEY_CURRENT_USER"

	Internet_explorer: EL_SOFTWARE_MICROSOFT_REG_KEYS
		once
			create Result.make ("Internet Explorer")
		end

	Windows: EL_SOFTWARE_MICROSOFT_WINDOWS_REG_KEYS
		once
			create Result.make
		end

	Windows_nt: EL_SOFTWARE_MICROSOFT_WINDOWS_REG_KEYS
		once
			create Result.make_nt
		end

end