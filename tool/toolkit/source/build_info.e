note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.build"

	date: "2025-03-29 14:48:56 GMT (Saturday 29th March 2025)"
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

	Build_number: NATURAL = 672

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/toolkit"
		end

	Version_number: NATURAL = 01_13_05

end