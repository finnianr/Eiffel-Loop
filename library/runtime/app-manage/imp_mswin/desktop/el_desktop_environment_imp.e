note
	description: "Windows implementation of ${EL_DESKTOP_ENVIRONMENT_I}' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 14:52:46 GMT (Sunday 8th September 2024)"
	revision: "10"

deferred class
	EL_DESKTOP_ENVIRONMENT_IMP

inherit
	EL_DESKTOP_ENVIRONMENT_I
		redefine
			set_compatibility_mode
		end

	EL_WINDOWS_IMPLEMENTATION

	EL_MODULE_OS_RELEASE; EL_MODULE_REG_KEY; EL_MODULE_WIN_REGISTRY

feature -- Access

	registered_compatibility_mode: STRING
		-- compatibility mode stored in Windows registry. Eg. WIN7
		do
			Result := Win_registry.string_8 (HKLM_compatibility_layers, executable_name)
		end

feature -- Basic operations

	install
		do
			if attached compatibility_mode as mode then
				Win_registry.set_string (HKLM_compatibility_layers, executable_name, mode)
			end
		end

	uninstall
		do
			if attached compatibility_mode as mode then
				Win_registry.remove_key_value (HKLM_compatibility_layers, executable_name)
			end
		end

feature -- Element change

	set_compatibility_mode (mode: STRING)
		-- set compatibility mode for Windows for registry entry. Eg. WIN7
		do
			compatibility_mode := mode
		end

feature {NONE} -- Implementation

	executable_name: ZSTRING
		do
			Result := Directory.Application_bin + Executable.name
		end

	new_script_path (path: FILE_PATH): FILE_PATH
		do
			Result := path.with_new_extension ("bat")
		end

feature {NONE} -- Internal attributes

	compatibility_mode: detachable STRING
		-- compatibility mode for Windows for registry entry. Eg. WIN7

feature {NONE} -- Constants

	HKLM_compatibility_layers: DIR_PATH
		-- HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers
		once
			Result := Reg_key.Windows_nt.current_version ("AppCompatFlags\Layers")
		end

	WIN7: STRING = "WIN7"

end