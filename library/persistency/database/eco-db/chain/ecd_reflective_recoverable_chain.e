note
	description: "[
		Adds features to ${ECD_RECOVERABLE_CHAIN} to do reflective CSV and Pyxis format exports
		By 'reflective' is meant that the exported CSV field names match the fields name of the
		class implementing ${EL_REFLECTIVELY_SETTABLE_STORABLE}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-12 12:43:15 GMT (Friday 12th July 2024)"
	revision: "20"

deferred class
	ECD_REFLECTIVE_RECOVERABLE_CHAIN [G -> EL_REFLECTIVELY_SETTABLE_STORABLE create make_default end]

inherit
	ECD_RECOVERABLE_CHAIN [G]
		export
			{ANY} Encoding_
		end

	EL_PYXIS_CHAIN_IMPORT_EXPORT [G]
		rename
			on_import as on_pyxis_import,
			Encoding as Encoding_
		end

	CSV_CHAIN_IMPORT_EXPORT [G]
		rename
			on_import as on_csv_import,
			Encoding as Encoding_
		end

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

feature -- Basic operations

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

feature {NONE} -- Implementation

	exported_file_path (dir_name, extension: STRING): FILE_PATH
		do
			Result := file_path.parent.joined_file_tuple ([dir_name, file_path.base])
			Result.replace_extension (extension)
		end

	on_csv_import (list: EL_ARRAYED_LIST [G])
		do
			wipe_out
			append_sequence (list)
			safe_store
		end

	on_pyxis_import (import_software_version: NATURAL; list: EL_ARRAYED_LIST [G])
		do
			wipe_out
			append_sequence (list)
			safe_store
		end

end