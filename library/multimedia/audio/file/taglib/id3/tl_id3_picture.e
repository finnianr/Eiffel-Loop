note
	description: "ID3 picture without any C dependencies"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-29 10:34:21 GMT (Sunday 29th March 2020)"
	revision: "8"

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

	EL_MODULE_STRING_8

create
	make, make_default, make_from_frame

feature {NONE} -- Initialization

	make (a_path: EL_FILE_PATH; a_description: READABLE_STRING_GENERAL; a_type_enum: NATURAL_8)
		-- make from picture `data'
		require
			valid_enum: Picture_type.is_valid_value (a_type_enum)
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
			internal_data := frame.picture.data
			type_enum := frame.type_enum
		end

feature -- Access

	checksum: NATURAL
		do
			Result := Mod_checksum.data (data)
		end

	data: MANAGED_POINTER
		-- picture data
		do
			if attached internal_data as l_data then
				Result := l_data
			elseif file_path.exists then
				Result := File_system.file_data (file_path)
				internal_data := Result
			else
				create Result.make (0)
			end
		end

	description: ZSTRING

	file_path: EL_FILE_PATH

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
			Result := file_path = Default_file_path and not attached internal_data
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
			Mime_types.start
			Mime_types.search (a_mime_type.substring (Image_prefix.count + 1, a_mime_type.count))
			if Mime_types.found then
				mime_type_index := Mime_types.index
			else
				mime_type_index := Mime_types.count
			end
		ensure
			set: a_mime_type ~ mime_type
		end

feature {NONE} -- Internal attributes

	internal_data: detachable MANAGED_POINTER

	mime_type_index: INTEGER

feature {NONE} -- Constants

	Default_file_path: EL_FILE_PATH
		once ("PROCESS")
			Result := "image.jpeg"
		end

	Mime_types: EL_STRING_8_LIST
		once
			create Result.make_with_csv ("bmp, exif, gif, ico, jpeg, png, svg, tiff, webp, xxx")
		end

invariant
	valid_mime_type_index: Mime_types.valid_index (mime_type_index)

end
