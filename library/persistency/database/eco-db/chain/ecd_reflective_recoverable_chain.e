note
	description: "[
		Adds features to [$source ECD_RECOVERABLE_CHAIN] to do reflective CSV and Pyxis format exports
		By 'reflective' is meant that the exported CSV field names match the fields name of the
		class implementing [$source EL_REFLECTIVELY_SETTABLE_STORABLE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-22 10:14:34 GMT (Thursday 22nd December 2022)"
	revision: "16"

deferred class
	ECD_REFLECTIVE_RECOVERABLE_CHAIN [G -> EL_REFLECTIVELY_SETTABLE_STORABLE create make_default end]

inherit
	ECD_RECOVERABLE_CHAIN [G]
		export
			{ANY} Mod_encoding
		end

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_SHARED_DIGESTS

feature -- Access

	csv_file_path: FILE_PATH
		do
			Result := exported_file_path ("csv", "csv")
		end

	meta_data_file_path: FILE_PATH
		local
			version: EL_SOFTWARE_VERSION
		do
			Result := exported_file_path ("meta_data", "e")
			create version.make (software_version, 0)
			Result.set_parent (Result.parent #+ version.string)
		end

	pyxis_file_path: FILE_PATH
		do
			Result := exported_file_path ("pyxis", "pyx")
		end
feature -- Digests

	crc_32_digest: NATURAL
		-- CRC-32 digest of all data in list
		local
			crc: like crc_generator
		do
			crc := crc_generator
			across Current as list loop
				if not list.item.is_deleted then
					list.item.write (crc)
				end
			end
			Result := crc.checksum
		end

	md5_digest: SPECIAL [NATURAL_8]
		-- MD5 digest of all data in list
		do
			Result := md5.digest
		end

	md5_digest_base_64: STRING
		do
			Result := md5.digest_base_64
		end

	md5_digest_string: STRING
		do
			Result := md5.digest_string
		end

feature -- Basic operations

	export_csv (a_file_path: FILE_PATH; encoding: NATURAL)
		require
			valid_encoding: Mod_encoding.is_valid (encoding)
		local
			file: EL_PLAIN_TEXT_FILE; line: ZSTRING
		do
			create file.make_open_write (a_file_path)
			file.set_encoding (encoding)
			create line.make (100)
			from start until after loop
				if not item.is_deleted then
					if file.position = 0 then
						file.put_string_8 (item.field_name_list.joined (','))
						file.put_new_line
					end
					line.wipe_out
					item.put_comma_separated_values (line)
					file.put_line (line)
				end
				forth
			end
			file.close
		end

	export_meta_data (a_file_path: FILE_PATH)
		local
			file: EL_PLAIN_TEXT_FILE; l_item: like item
		do
			File_system.make_directory (a_file_path.parent)
			create file.make_open_write (a_file_path)
			file.set_encoding (Latin_1)
			if is_empty then
				create l_item.make_default
			else
				l_item := first
			end
			l_item.write_meta_data (file, 0)
			file.close
		end

	export_pyxis (a_file_path: FILE_PATH; encoding: NATURAL)
		require
			valid_encoding: Mod_encoding.is_valid (encoding)
		local
			file: EL_PLAIN_TEXT_FILE; exporter: EL_PYXIS_OBJECT_EXPORTER
		do
			File_system.make_directory (a_file_path.parent)
			if count > 0 then
				create exporter.make (first)
			else
				create exporter.make (create {G}.make_default)
			end
			create file.make_open_write (a_file_path)
			file.set_encoding (encoding)
			exporter.write_header (file, software_version)
			from start until after loop
				if item.not_deleted then
					exporter.write_item_to (item, file, 0)
				end
				forth
			end
			file.close
		end

	import_csv (a_file_path: FILE_PATH)
		local
			import_list: CSV_IMPORTABLE_ARRAYED_LIST [G]
		do
			create import_list.make_empty
			wipe_out
			import_list.import_csv_utf_8 (a_file_path)
			append_sequence (import_list)
			safe_store
		end

	import_pyxis (a_file_path: FILE_PATH)
		-- replace all items with imported Pyxis data
		local
			importer: EL_PYXIS_TABLE_DATA_IMPORTER [G]
		do
			wipe_out
			create importer.make (Current, pyxis_file_path)
			importer.execute
			safe_store
		end

feature {NONE} -- Implementation

	exported_file_path (dir_name, extension: STRING): FILE_PATH
		do
			Result := file_path.parent.joined_file_tuple ([dir_name, file_path.base])
			Result.replace_extension (extension)
		end

	md5: like Md5_128
		-- shared MD5 digest of all data in list
		do
			Result := Md5_128
			Result.reset
			across Current as list loop
				if not list.item.is_deleted then
					list.item.write (Result)
				end
			end
		end

end