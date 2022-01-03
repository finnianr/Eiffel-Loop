note
	description: "Id3 album picture"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "10"

class
	ID3_ALBUM_PICTURE

inherit
	ANY
		redefine
			default_create
		end

	EL_MODULE_CHECKSUM
		rename
			checksum as Mod_checksum
		end

	EL_MODULE_FILE_SYSTEM

create
	default_create, make, make_from_file

feature {NONE} -- Initialization

	default_create
		do
			create data.make (0)
			create description.make_empty
			mime_type := "image/jpeg"
		end

	make (a_data: like data; a_description, a_mime_type: STRING)
		do
			data := a_data; description := a_description; mime_type := a_mime_type
			checksum := Mod_checksum.data (data)
		end

	make_from_file (a_file_path: FILE_PATH; a_description: like description)
		do
			mime_type := a_file_path.extension.as_lower
			if mime_type.is_equal ("jpg") then
				mime_type := "jpeg"
			end
			mime_type.prepend_string_general ("image/")
			make (File_system.file_data (a_file_path), a_description, mime_type)
		end

feature -- Access

	data: MANAGED_POINTER

	description: ZSTRING

	checksum: NATURAL

	mime_type: STRING

feature -- Element change

	set_description (a_description: like description)
		do
			description := a_description
		end

end
