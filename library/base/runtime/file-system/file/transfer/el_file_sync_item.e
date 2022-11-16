note
	description: "File synchronization item with CRC-32 checksum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	EL_FILE_SYNC_ITEM

inherit
	EL_SET_MEMBER [EL_FILE_SYNC_ITEM]
		redefine
			is_equal
		end

	EL_MODULE_FILE_SYSTEM

	EL_FILE_SYNC_ROUTINES undefine is_equal end

	EL_FILE_OPEN_ROUTINES

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

create
	make, make_from_other

feature {NONE} -- Initialization

	make (a_home_dir: DIR_PATH; a_destination_name: READABLE_STRING_GENERAL; a_file_path: FILE_PATH)
		require
			valid_file_path: a_file_path.is_absolute implies a_home_dir.is_parent_of (a_file_path)
		do
			home_dir := a_home_dir; destination_name := a_destination_name
			if a_home_dir.is_parent_of (a_file_path) then
				file_path := a_file_path.relative_path (a_home_dir)
			else
				file_path := a_file_path
			end
			digest_path := new_crc_sync_dir (home_dir, destination_name) + file_path
			digest_path.replace_extension (Crc_extension)

			if attached crc_generator as crc then
				sink_content (crc)
				current_digest := crc.checksum
			end
			if attached digest_path as path and then path.exists and then attached open_raw (path, Read) as file then
				file.read_natural_32
				previous_digest := file.last_natural_32
				file.close
			end

		ensure
			file_path_is_relative: not file_path.is_absolute
		end

	make_from_other (other: EL_FILE_SYNC_ITEM)
		do
			current_digest := other.current_digest
			previous_digest := other.previous_digest
			file_path := other.file_path
			home_dir := other.home_dir
		end

feature -- Access

	current_digest: NATURAL

	destination_name: READABLE_STRING_GENERAL

	digest_path: FILE_PATH

	file_path: FILE_PATH
		-- relative path

	hash_code: INTEGER
			-- Hash code value
		do
			Result := file_path.hash_code
		end

	home_dir: DIR_PATH

	previous_digest: NATURAL

	source_path: FILE_PATH
		do
			Result := home_dir + file_path
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			if Current = other then
				Result := True
			elseif current_digest = other.current_digest then
				Result := is_same_as (other) and then home_dir ~ other.home_dir
			end
		end

	is_same_as (other: EL_FILE_SYNC_ITEM): BOOLEAN
		do
			if Current = other then
				Result := True
			else
				Result := file_path ~ other.file_path
			end
		end

feature -- Status query

	is_modified: BOOLEAN
		do
			Result := previous_digest /= current_digest
		end

feature -- Basic operations

	remove
		do
			across << source_path, digest_path >> as path loop
				if path.item.exists then
					File_system.remove_file (path.item)
				end
			end
		end

	store
		do
			if attached digest_path as path then
				File_system.make_directory (path.parent)
				if attached open_raw (path, Write) as file then
					file.put_natural_32 (current_digest)
					file.close
				end
				previous_digest := current_digest
			end
		end

feature -- Element change

	set_current_digest (a_current_digest: NATURAL)
		do
			current_digest := a_current_digest
		end

	update
		do
		end

feature {NONE} -- Implementation

	sink_content (crc: like crc_generator)
		do
			if attached source_path as path and then path.exists then
				crc.add_file (path)
			end
		end

end