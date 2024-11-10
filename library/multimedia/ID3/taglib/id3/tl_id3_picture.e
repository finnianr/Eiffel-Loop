note
	description: "ID3 picture without any C dependencies"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 17:19:31 GMT (Sunday 10th November 2024)"
	revision: "19"

class
	TL_ID3_PICTURE

inherit
	EL_LAZY_ATTRIBUTE
		rename
			new_item as new_data,
			cached_item as actual_data
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
			checksum as Checksum_
		end

	EL_MODULE_FILE

create
	make, make_default, make_from_frame

feature {NONE} -- Initialization

	make (a_path: FILE_PATH; a_description: READABLE_STRING_GENERAL; a_type_enum: NATURAL_8)
		-- make from picture `data'
		require
			valid_enum: Picture_type.valid_value (a_type_enum)
		local
			extension: STRING
		do
			file_path := a_path
			create description.make_from_general (a_description)
			type_enum := a_type_enum
			extension := a_path.extension; extension.to_lower
			if extension ~ "jpg" then
				extension := "jpeg"
			end
			set_mime_type (Image_prefix + extension)
		end

	make_default
		do
			make (Default_file_path, "", Picture_type.other)
		end

	make_from_frame (frame: TL_PICTURE_ID3_FRAME)
		do
			file_path := Default_file_path
			description := frame.description
			set_mime_type (frame.mime_type)
			actual_data := frame.picture.data
			type_enum := frame.type_enum
		end

feature -- Access

	checksum: NATURAL
		do
			Result := Checksum_.data (data)
		end

	data: like new_data
		do
			Result := lazy_item
		end

	description: ZSTRING

	file_path: FILE_PATH

	mime_type: STRING
		do
			Result := Image_prefix + Mime_types.i_th (mime_type_index)
		end

	type_enum: NATURAL_8

	type_name: STRING
		do
			Result := Picture_type.name (type_enum)
		end

feature -- Constants

	Image_prefix: STRING = "image/"

feature -- Status query

	is_default: BOOLEAN
		do
			Result := file_path = Default_file_path and not attached actual_data
		end

	same_type_and_description (other: TL_ID3_PICTURE): BOOLEAN
		do
			Result := type_enum = other.type_enum and then description ~ other.description
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

feature -- Element change

	set_mime_type (a_mime_type: STRING)
		require
			valid_type: a_mime_type.starts_with (Image_prefix)
		do
			Mime_types.start; Mime_types.search (image_type (a_mime_type))
			if Mime_types.found then
				mime_type_index := Mime_types.index
			else
				mime_type_index := Mime_types.count
			end
		ensure
			set: mime_type_index /= Mime_types.count implies mime_type ~ Image_prefix + image_type (a_mime_type)
		end

feature {NONE} -- Implementation

	image_type (a_mime_type: STRING): STRING
		do
			Result := a_mime_type.substring (a_mime_type.index_of ('/', 1) + 1, a_mime_type.count)
			if Result ~ once "jpg" then
				Result.insert_character ('e', 3)
			end
		end

	new_data: MANAGED_POINTER
		-- picture data
		do
			if file_path.exists then
				Result := File.data (file_path)
			else
				create Result.make (0)
			end
		end

feature {NONE} -- Internal attributes

	mime_type_index: INTEGER

feature {NONE} -- Constants

	Default_file_path: FILE_PATH
		once ("PROCESS")
			Result := "image.jpeg"
		end

	Mime_types: EL_STRING_8_LIST
		once
			Result := "bmp, exif, gif, ico, jpeg, png, svg, tiff, webp, xxx"
		end

invariant
	valid_mime_type_index: Mime_types.valid_index (mime_type_index)

end