note
	description: "Eiffel loop build info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-24 11:51:03 GMT (Tuesday 24th September 2024)"
	revision: "12"

class
	EIFFEL_LOOP_BUILD_INFO

inherit
	ANY

	EL_BUILD_INFO

	EL_MODULE_EXECUTABLE

	SHARED_DEV_ENVIRON

feature -- Constants

	Build_number: NATURAL = 0

	App_compatibility_flags: STRING = ""
		-- For installed entry in registry key: CurrentVersion\AppCompatFlags\Layers
		-- Under: HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT

	Installation_sub_directory: DIR_PATH
		once
			Result := Dev_environ.Eiffel_loop
			Result := Result #+ Executable.name
		end

	Version_number: NATURAL = 01_00_00

end