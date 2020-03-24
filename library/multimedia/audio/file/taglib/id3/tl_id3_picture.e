note
	description: "ID3 picture without any C dependencies"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-24 12:16:19 GMT (Tuesday 24th March 2020)"
	revision: "5"

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

	EL_MODULE_CHECKSUM
		rename
			checksum as Mod_checksum
		end

create
	make, make_default, make_from_frame

feature {NONE} -- Initialization

	make (path: EL_FILE_PATH; a_description: READABLE_STRING_GENERAL; a_type_enum: NATURAL_8)
		-- make from picture `data'
		require
			valid_enum: Picture_type.is_valid_value (a_type_enum)
		local
			extension: STRING
		do
			create description.make_from_general (a_description)
			type_enum := a_type_enum
			if path.exists then
				data := File_system.file_data (path)
				checksum := Mod_checksum.data (data)
			else
				create data.make (0)
			end
			extension := path.extension; extension.to_lower

			Mime_types.find_first_true (agent type_matches (?, extension))
			if Mime_types.found then
				mime_type := Mime_types.item
			else
				mime_type := Mime_types.first
			end
		end

	make_default
		do
			make (create {EL_FILE_PATH}, "", Picture_type.other)
		end

	make_from_frame (frame: TL_PICTURE_ID3_FRAME)
		do
			description := frame.description
			Mime_types.start
			Mime_types.search (frame.mime_type)
			if Mime_types.found then
				mime_type := Mime_types.item
			else
				mime_type := frame.mime_type
			end
			data := frame.picture.data
			checksum := Mod_checksum.data (data)
			type_enum := frame.type_enum
		end

feature -- Access

	data: MANAGED_POINTER
		-- picture data

	description: ZSTRING

	checksum: NATURAL

	mime_type: STRING

	type_enum: NATURAL_8

feature -- Status query

	is_default: BOOLEAN
		do
			Result := data.count = 0 and then description.is_empty and then type_enum = Picture_type.other
		end

feature -- Conversion

	to_frame: TL_PICTURE_ID3_FRAME
		do
			create Result.make (Current)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := description ~ other.description and then mime_type ~ other.mime_type
				and then type_enum = other.type_enum and then data ~ other.data
		end

feature {NONE} -- Implementation

	type_matches (type, extension: STRING): BOOLEAN
		-- matches both "jpg" and "jpeg" to "image/jpeg"
		local
			pos_slash, ext_count: INTEGER
		do
			ext_count := extension.count
			if ext_count > 0 and then extension [ext_count] = type [type.count] then
				pos_slash := type.index_of ('/', 1)
				if type.count - pos_slash = extension.count then
					Result := extension ~ type.substring (pos_slash + 1, type.count)
				else
					Result := extension.starts_with (type.substring (pos_slash + 1, pos_slash + 2))
				end
			end
		end

feature {NONE} -- Constants

	Mime_types: EL_STRING_8_LIST
		once
			create Result.make (10)
			across ("jpeg,png,bmp,ico,gif,svg,exif,tiff,webp").split (',') as type loop
				Result.extend ("image/" + type.item)
			end
		end

end
