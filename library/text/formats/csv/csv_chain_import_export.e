note
	description: "Import/Export routines for [$source ITERABLE [EL_REFLECTIVELY_SETTABLE]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-28 10:16:45 GMT (Wednesday 28th December 2022)"
	revision: "1"

deferred class
	CSV_CHAIN_IMPORT_EXPORT [G -> EL_REFLECTIVELY_SETTABLE_STORABLE create make_default end]

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
			file: EL_PLAIN_TEXT_FILE; line: ZSTRING
		do
			create file.make_open_write (a_file_path)
			file.set_encoding (a_encoding)
			create line.make (100)
			across Current as list loop
				if attached {EL_STORABLE} list.item as item implies not item.is_deleted then
					if file.position = 0 then
						file.put_string_8 (list.item.field_name_list.joined (','))
						file.put_new_line
					end
					line.wipe_out
					list.item.put_comma_separated_values (line)
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