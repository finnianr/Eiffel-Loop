note
	description: "Windows implementation of ${EL_DESKTOP_ENVIRONMENT_I}' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 7:54:42 GMT (Wednesday 25th September 2024)"
	revision: "11"

deferred class
	EL_DESKTOP_ENVIRONMENT_IMP

inherit
	EL_DESKTOP_ENVIRONMENT_I
		redefine
			set_app_compatibility
		end

	EL_WINDOWS_IMPLEMENTATION

	EL_MODULE_OS_RELEASE; EL_MODULE_HKEY_LOCAL_MACHINE; EL_MODULE_WIN_REGISTRY

feature -- Access

	registry_compatibility_flags: STRING
		-- compatibility mode flags stored in Windows registry. Eg. ~WIN7RTM
		do
			Result := Win_registry.string_8 (HKLM_compatibility_layers, executable_name)
		end

feature -- Basic operations

	install
		do
			if attached app_compatibility_flags as flags and then flags.count > 0 then
				Win_registry.set_string (HKLM_compatibility_layers, executable_name, flags)
			end
		end

	uninstall
		do
			if attached app_compatibility_flags as flags and then flags.count > 0 then
				Win_registry.remove_key_value (HKLM_compatibility_layers, executable_name)
			end
		end

feature -- Element change

	set_app_compatibility (flags: STRING)
		-- set Windows registry compatibility mode flags Eg. ~WIN7RTM
		do
			app_compatibility_flags := flags
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

	app_compatibility_flags: detachable STRING
		-- compatibility mode for Windows for registry entry. Eg. WIN7

feature {NONE} -- Constants

	HKLM_compatibility_layers: DIR_PATH
		-- HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers
		once
			Result := Key_local.Windows_nt_current_version #+ "AppCompatFlags\Layers"
		end

	WIN7: STRING = "WIN7"

end