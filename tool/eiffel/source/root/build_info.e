note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.build"

	date: "2025-04-02 18:32:30 GMT (Wednesday 2nd April 2025)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	App_compatibility_flags: STRING = ""
		-- For installed entry in registry key: CurrentVersion\AppCompatFlags\Layers
		-- Under: HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT

	Build_number: NATURAL = 533

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/eiffel"
		end

	Version_number: NATURAL = 02_03_00

end