note
	description: "Summary description for {COPY_UNIQUE_MP3_FILE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:33:25 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	COPY_UNIQUE_MP3_FILE_COMMAND

inherit
	EL_COPY_FILE_COMMAND
		rename
			make as make_copy,
			source_path as intermediate_path
		redefine
			execute
		end

	EL_MODULE_DIRECTORY
		export
			{NONE} all
		undefine
			default_create
		end

	EL_MODULE_FILE_SYSTEM
		export
			{NONE} all
		undefine
			default_create
		end

	EL_ID3_ENCODINGS
		export
			{NONE} all
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_source_path, a_destination_path: EL_FILE_PATH; id3_version: REAL; ID3_tag_encoding: INTEGER)
			--
		require
			valid_id3_version: Valid_ID3_versions.has (id3_version)
		do
			make_copy (Intermediate_directory + a_destination_path.base, a_destination_path)
			source_path := a_source_path
			device_ID3_version := id3_version
			destination_ID3_tag_character_encoding := ID3_tag_encoding
		end

feature -- Basic operations

	execute
			--
		local
			id3_info: EL_ID3_INFO
			has_tag_modifications: BOOLEAN
		do
			File_system.make_directory (Intermediate_directory)
			File_system.copy (source_path, intermediate_path)

			if attached {EL_FILE_PATH} intermediate_path as l_intermediate_path then
				create id3_info.make (l_intermediate_path)

				if device_ID3_version < id3_info.version then
					id3_info.set_version (device_ID3_version)
					has_tag_modifications := true
				else
					if not (destination_ID3_tag_character_encoding = Encoding_unknown
								or destination_ID3_tag_character_encoding = id3_info.encoding)
					then
						has_tag_modifications := true
					end
				end

				if has_tag_modifications then
					id3_info.update
				end
			end

			Precursor
			file_system.delete (intermediate_path)
		end

feature {NONE} -- Implementation: attributes

	source_path: EL_FILE_PATH

	device_ID3_version: REAL
			-- Compatible version for device

	destination_ID3_tag_character_encoding: INTEGER

feature -- Constants

	Intermediate_directory: EL_DIR_PATH
			--
		once
			Result := Directory.Temporary.joined_dir_path ("class-" + generator.as_lower)
		end

end
