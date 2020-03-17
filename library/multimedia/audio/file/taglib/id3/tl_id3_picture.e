note
	description: "ID3 picture without any C dependencies"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-17 12:17:00 GMT (Tuesday 17th March 2020)"
	revision: "2"

class
	TL_ID3_PICTURE

inherit
	ANY
		redefine
			is_equal
		end

	EL_MODULE_FILE_SYSTEM

	TL_SHARED_PICTURE_TYPE_ENUM
		export
			{ANY} Picture_type
		end

	EL_STRING_8_CONSTANTS

create
	make, make_empty, make_from_frame

feature {NONE} -- Initialization

	make (path: EL_FILE_PATH; a_description: ZSTRING; a_type_enum: NATURAL_8)
		-- make from picture `data'
		require
			valid_enum: Picture_type.is_valid_value (a_type_enum)
		local
			extension: STRING
		do
			description := a_description; type_enum := a_type_enum
			if path.exists then
				data := File_system.file_data (path)
			else
				create data.make (0)
			end
			extension := path.extension; extension.to_lower
			
			Mime_types.find_first_true (agent type_matches (?, extension))
			if Mime_types.found then
				mime_type := Mime_types.item
			else
				mime_type := Mime_types [1]
			end
		end

	make_empty
		do
			make (create {EL_FILE_PATH}, "", Picture_type.other)
		end

	make_from_frame (frame: TL_PICTURE_ID3_FRAME)
		do
			description := frame.description
			mime_type := frame.mime_type
			data := frame.picture.data
			type_enum := frame.type_enum
		end

feature -- Access

	data: MANAGED_POINTER
		-- picture data

	description: ZSTRING

	mime_type: STRING

	type_enum: NATURAL_8

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := description ~ other.description and then mime_type ~ other.mime_type
				and then type_enum = other.type_enum and then data ~ other.data
		end

feature {NONE} -- Implementation

	type_matches (type, extension: STRING): BOOLEAN
		do
			Result := type.fuzzy_index (extension, 1, 1) > 0
		end

feature {NONE} -- Constants

	Mime_types: EL_ARRAYED_LIST [STRING]
		once
			create Result.make_from_array (<< "image/jpeg", "image/png", "image/bmp", "image/ico" >>)
		end

end
