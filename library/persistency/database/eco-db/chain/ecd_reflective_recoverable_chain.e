note
	description: "[
		Adds features to [$source ECD_RECOVERABLE_CHAIN] to do reflective CSV and Pyxis format exports
		By 'reflective' is meant that the exported CSV field names match the fields name of the
		class implementing [$source EL_REFLECTIVELY_SETTABLE_STORABLE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 14:30:35 GMT (Monday 3rd May 2021)"
	revision: "7"

deferred class
	ECD_REFLECTIVE_RECOVERABLE_CHAIN [G -> EL_REFLECTIVELY_SETTABLE_STORABLE create make_default end]

inherit
	ECD_RECOVERABLE_CHAIN [G]

	EL_ENCODING_CONSTANTS
		export
			{ANY} valid_encoding
		end

feature -- Access

	csv_file_path: EL_FILE_PATH
		do
			Result := exported_file_path ("csv", "csv")
		end

	meta_data_file_path: EL_FILE_PATH
		do
			Result := exported_file_path ("meta_data", "e")
		end

	pyxis_file_path: EL_FILE_PATH
		do
			Result := exported_file_path ("pyxis", "pyx")
		end

feature -- Basic operations

	export_csv (a_file_path: EL_FILE_PATH; encoding: NATURAL)
		require
			valid_encoding: valid_encoding (encoding)
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

	export_meta_data (a_file_path: EL_FILE_PATH)
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

	export_pyxis (a_file_path: EL_FILE_PATH; encoding: NATURAL)
		require
			valid_encoding: valid_encoding (encoding)
		local
			file: EL_PLAIN_TEXT_FILE
		do
			File_system.make_directory (a_file_path.parent)
			create file.make_open_write (a_file_path)
			file.set_encoding (encoding)
			file.put_string (Pyxis_header #$ [file.encoding_name])
			file.put_new_line
			file.put_new_line
			file.put_string (file_path.base_sans_extension)
			file.put_character_8 (':')
			file.put_new_line
			from start until after loop
				if not item.is_deleted then
					file.put_indent (1)
					file.put_string_8 ("item:")
					file.put_new_line
					item.write_as_pyxis (file, 2)
				end
				forth
			end
			file.close
		end

	import_csv (a_file_path: EL_FILE_PATH)
		local
			import_list: EL_IMPORTABLE_ARRAYED_LIST [G]
		do
			create import_list.make_empty
			wipe_out
			import_list.import_csv_utf_8 (a_file_path)
			append_sequence (import_list)
			safe_store
		end

	import_pyxis (a_file_path: EL_FILE_PATH)
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

	exported_file_path (dir_name, extension: STRING): EL_FILE_PATH
		do
			Result := file_path.parent.joined_file_tuple ([dir_name, file_path.base])
			Result.replace_extension (extension)
		end

feature {NONE} -- Constants

	Pyxis_header: ZSTRING
		once
			Result := "[
				pyxis-doc:
					version = 1.0; encoding = "#"
			]"
		end
end