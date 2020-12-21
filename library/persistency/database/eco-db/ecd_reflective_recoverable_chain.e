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
	date: "2020-12-17 12:32:39 GMT (Thursday 17th December 2020)"
	revision: "3"

deferred class
	ECD_REFLECTIVE_RECOVERABLE_CHAIN [G -> EL_REFLECTIVELY_SETTABLE_STORABLE create make_default end]

inherit
	ECD_RECOVERABLE_CHAIN [G]

	EL_ENCODING_CONSTANTS

feature -- Access

	csv_file_path: EL_FILE_PATH
		do
			Result := file_path.with_new_extension ("csv")
		end

	meta_data_file_path: EL_FILE_PATH
		do
			Result := file_path.parent.joined_file_tuple (["meta_data", file_path.base_sans_extension + ".e"])
		end

	pyxis_file_path: EL_FILE_PATH
		do
			Result := file_path.parent.joined_file_tuple (["pyxis", file_path.base_sans_extension + ".pyx"])
		end

feature {NONE} -- Implementation

	export_csv (a_file_path: EL_FILE_PATH; encoding: NATURAL)
		require
			valid_encoding: valid_encoding (encoding)
		local
			file: EL_PLAIN_TEXT_FILE
		do
			create file.make_open_write (a_file_path)
			file.set_encoding (encoding)
			from start until after loop
				if not item.is_deleted then
					if file.position = 0 then
						file.put_string_8 (item.field_name_list.joined (','))
						file.put_new_line
					end
					file.put_string (item.comma_separated_values)
					file.put_new_line
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

feature {NONE} -- Constants

	Pyxis_header: ZSTRING
		once
			Result := "[
				pyxis-doc:
					version = 1.0; encoding = "#"
			]"
		end
end