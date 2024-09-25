note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2024-09-24 16:28:26 GMT (Tuesday 24th September 2024)"
	revision: "3"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	App_compatibility_flags: STRING = "~Win7RTM"
		-- For installed entry in registry key: CurrentVersion\AppCompatFlags\Layers
		-- Under: HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT

	Build_number: NATURAL = 0

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/test-id3"
		end

	Version_number: NATURAL = 01_00_00

end