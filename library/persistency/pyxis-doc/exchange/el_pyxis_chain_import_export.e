note
	description: "Import/Export routines for [$source ITERABLE [EL_REFLECTIVELY_SETTABLE]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-28 10:04:58 GMT (Wednesday 28th December 2022)"
	revision: "1"

deferred class
	EL_PYXIS_CHAIN_IMPORT_EXPORT [G -> EL_REFLECTIVELY_SETTABLE create make_default end]

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

	export_pyxis (a_file_path: FILE_PATH; a_encoding: NATURAL)
		require
			valid_encoding: Encoding.is_valid (a_encoding)
		local
			file: EL_PLAIN_TEXT_FILE; exporter: EL_PYXIS_OBJECT_EXPORTER [G]
		do
			File_system.make_directory (a_file_path.parent)
			create exporter.make
			create file.make_open_write (a_file_path)
			file.set_encoding (a_encoding)
			exporter.write_header (file, software_version)
			across Current as list loop
				if attached {EL_STORABLE} list.item as item implies not item.is_deleted then
					exporter.write_item_to (list.item, file, 0)
				end
			end
			file.close
		end

	import_pyxis (a_file_path: FILE_PATH)
		-- replace all items with imported Pyxis data
		local
			importer: EL_PYXIS_OBJECT_IMPORTER [G]
		do
			create importer.make (a_file_path)
			on_import (importer.software_version, importer.list)
		end

feature {NONE} -- Implementation

	new_cursor: INDEXABLE_ITERATION_CURSOR [G]
			-- <Precursor>
		deferred
		end

	on_import (import_software_version: NATURAL; list: EL_ARRAYED_LIST [G])
		deferred
		end

	software_version: NATURAL
		deferred
		end

end