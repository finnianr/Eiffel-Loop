note
	description: "Tl id3 picture"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-14 19:04:45 GMT (Saturday 14th March 2020)"
	revision: "1"

class
	TL_ID3_PICTURE

inherit
	ANY

	EL_MODULE_FILE_SYSTEM

	TL_SHARED_PICTURE_TYPE_ENUM
		export
			{ANY} Picture_type
		end

create
	make

feature {NONE} -- Initialization

	make (path: EL_FILE_PATH; a_description: ZSTRING; a_mime_type: STRING; a_type_enum: NATURAL_8)
		-- make from picture `data'
		require
			valid_enum: Picture_type.is_valid_value (a_type_enum)
		do
			if path.exists then
				data := File_system.file_data (path)
			else
				create data.make (0)
			end
			description := a_description
			mime_type := a_mime_type
			type_enum := a_type_enum
		end

feature -- Access

	description: ZSTRING

	mime_type: STRING

	data: MANAGED_POINTER
		-- picture data

	type_enum: NATURAL_8

end
