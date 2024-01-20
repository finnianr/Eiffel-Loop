note
	description: "Import/Export routines for ${ITERABLE [EL_REFLECTIVELY_SETTABLE]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "7"

deferred class
	CSV_CHAIN_IMPORT_EXPORT [G -> {EL_REFLECTIVELY_SETTABLE_STORABLE} create make_default end]

inherit
	ITERABLE [G]
		undefine
			copy, is_equal
		redefine
			new_cursor
		end

	EL_MODULE_ENCODING
		export
			{ANY} Encoding
		end

	EL_MODULE_FILE_SYSTEM

feature -- Basic operations

	export_csv (a_file_path: FILE_PATH; a_encoding: NATURAL)
		require
			valid_encoding: Encoding.is_valid (a_encoding)
		local
			file: EL_PLAIN_TEXT_FILE; line: ZSTRING; s: EL_STRING_8_ROUTINES
			csv: EL_REFLECTIVE_CSV_ROUTINES
		do
			create file.make_open_write (a_file_path)
			file.set_encoding (a_encoding)
			create line.make (100)
			across Current as list loop
				if attached list.item as item implies not item.is_deleted then
					if file.position = 0 then
						file.put_string_8 (s.joined_list (list.item.field_name_list, ','))
						file.put_new_line
					end
					line.wipe_out
					csv.put_comma_separated_values (list.item, line)
					file.put_line (line)
				end
			end
			file.close
		end

	import_csv (a_file_path: FILE_PATH)
		local
			import_list: CSV_IMPORTABLE_ARRAYED_LIST [G]
		do
			create import_list.make_empty
			import_list.import_csv_utf_8 (a_file_path)
			on_import (import_list)
		end

feature {NONE} -- Implementation

	new_cursor: INDEXABLE_ITERATION_CURSOR [G]
			-- <Precursor>
		deferred
		end

	on_import (list: EL_ARRAYED_LIST [G])
		deferred
		end

end