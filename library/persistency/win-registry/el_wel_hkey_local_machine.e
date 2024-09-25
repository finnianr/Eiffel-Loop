note
	description: "[
		Common HKEY_LOCAL_MACHINE registry keys accessible via ${EL_MODULE_HKEY_LOCAL_MACHINE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 7:52:25 GMT (Wednesday 25th September 2024)"
	revision: "9"

class
	EL_WEL_HKEY_LOCAL_MACHINE

feature -- Conversion

	as_current_user (path: DIR_PATH): DIR_PATH
		-- convert HKEY_LOCAL_MACHINE to HKEY_CURRENT_USER path
		do
			if path.parent_string (False).starts_with (HKEY_local_machine)
				and then attached path.to_string as str
			then
				str.replace_substring (HKEY_current_user, 1, HKEY_local_machine.count)
				Result := str
			else
				Result := path
			end
		end

feature -- HKEY_LOCAL_MACHINE paths

	System_current_control_set: DIR_PATH
		-- HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet
		once
			Result := HKEY_local_machine + "\SYSTEM\CurrentControlSet"
		end

feature -- SOFTWARE\Microsoft (LM)

	Internet_explorer: DIR_PATH
		-- HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer
		once
			Result := Software_microsoft #+ "Internet Explorer"
		end

	Microsoft_windows: DIR_PATH
		-- HKEY_LOCAL_MACHINE\Software\Microsoft\Windows
		once
			Result := Software_microsoft #+ "Windows"
		end

	Microsoft_windows_NT: DIR_PATH
		-- HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT
		once
			Result := Microsoft_windows.to_string + " NT"
		end

	Software_microsoft: DIR_PATH
		-- HKEY_LOCAL_MACHINE\Software\Microsoft
		once
			Result := HKEY_local_machine + "\SOFTWARE\Microsoft"
		end

	Windows_nt_current_version: DIR_PATH
		-- HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion
		once
			Result := Microsoft_windows_nt #+ "CurrentVersion"
		end

feature -- Root names

	HKEY_current_user: ZSTRING
		once
			Result := "HKEY_CURRENT_USER"
		end

	HKEY_local_machine: ZSTRING
		once
			Result := "HKEY_LOCAL_MACHINE"
		end

end