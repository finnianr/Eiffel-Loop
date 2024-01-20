note
	description: "[
		Windows version object with support for Windows 10 by registry query, and accessible via
		class ${EL_MODULE_WINDOWS_VERSION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_WEL_WINDOWS_VERSION

inherit
	WEL_WINDOWS_VERSION
		rename
			major_version as major,
			minor_version as minor,
			is_windows_nt as is_nt
		redefine
			internal_version
		end

	EL_MODULE_REG_KEY

	EL_MODULE_WIN_REGISTRY

	EL_MODULE_EXECUTION_ENVIRONMENT

feature -- Access

	is_7_or_later: BOOLEAN
		do
			Result := is_nt and then compact >= 6_1
		end

	is_10_or_later: BOOLEAN
		do
			Result := compact >= 10_0
		end

	compact: INTEGER
		do
			Result := major * 10 + minor
		end

feature {NONE} -- Implementation

	Internal_version: INTEGER
			-- Internal version as returned by Windows.
		local
			l_major, win_nt: INTEGER
		once
			l_major := win_10_version ("Major")
			Result := cwin_get_version
			if l_major > 0 then
				-- must be Windows 10 or greater
				win_nt := Result & 0x80000000
				Result := win_nt | (win_10_build |<< 16) | (win_10_version ("Minor") |<< 8) | l_major
			end
		end

	win_10_build: INTEGER
		do
			Result := Win_registry.string_32 (Reg_key.Windows_nt.current_version_path, current_number ("Build")).to_integer
		end

	win_10_version (type: STRING): INTEGER
		do
			Result := Win_registry.integer (Reg_key.Windows_nt.current_version_path, current_number (type + "Version"))
		end

	current_number (type: STRING): STRING
		do
			Result := "CurrentNumber"
			Result.insert_string (type, 8)
		end

end