note
	description: "File synchronization item with CRC-32 checksum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-20 16:16:52 GMT (Saturday 20th March 2021)"
	revision: "5"

class
	EL_FILE_SYNC_ITEM

inherit
	HASHABLE
		redefine
			is_equal
		end

	EL_MODULE_FILE_SYSTEM

	EL_FILE_SYNC_CONSTANTS undefine is_equal end

	EL_FILE_OPEN_ROUTINES

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

create
	make, make_from_other

feature {NONE} -- Initialization

	make (a_home_dir: EL_DIR_PATH; a_file_path: EL_FILE_PATH)
		require
			valid_file_path: a_file_path.is_absolute implies a_home_dir.is_parent_of (a_file_path)
		local
			l_crc: like crc_generator
		do
			home_dir := a_home_dir
			if a_file_path.is_absolute then
				file_path := a_file_path.relative_path (a_home_dir)
			else
				file_path := a_file_path
			end
			l_crc := crc_generator
			sink_content (l_crc)
			current_digest := l_crc.checksum
			if attached digest_path as path and then path.exists and then attached open_raw (path, Read) as file then
				file.read_natural_32
				previous_digest := file.last_natural_32
				file.close
			end
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

	file_path: EL_FILE_PATH
		-- relative path

	hash_code: INTEGER
			-- Hash code value
		do
			Result := file_path.hash_code
		end

	previous_digest: NATURAL

	home_dir: EL_DIR_PATH

	source_path: EL_FILE_PATH
		do
			Result := home_dir + file_path
		end

feature -- Duplication

	frozen bare_item: EL_FILE_SYNC_ITEM
		do
			create Result.make_from_other (Current)
		ensure
			is_bare_type: {ISE_RUNTIME}.dynamic_type (Result) = File_sync_item_type_id
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := file_path ~ other.file_path
		end

feature -- Status query

	is_modified: BOOLEAN
		do
			Result := previous_digest /= current_digest
		end

feature -- Basic operations

	store
		do
			if attached digest_path as path and then attached open_raw (path, Write) as file then
				file.put_natural_32 (current_digest)
				file.close
				previous_digest := current_digest
			end
		end

	remove
		do
			across << source_path, digest_path >> as path loop
				if path.item.exists then
					File_system.remove_file (path.item)
				end
			end
		end

feature {NONE} -- Implementation

	digest_path: EL_FILE_PATH
		do
			Result := source_path
			Result.base.prepend_character ('.')
			Result.replace_extension (Crc_32)
		end

	sink_content (crc: like crc_generator)
		do
			if attached source_path as path and then path.exists then
				crc.add_file (path)
			end
		end

end
