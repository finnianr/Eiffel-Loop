note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.build"

	date: "2025-03-09 8:55:57 GMT (Sunday 9th March 2025)"
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

	Build_number: NATURAL = 109

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/manage-mp3"
		end

	Version_number: NATURAL = 02_05_00

end