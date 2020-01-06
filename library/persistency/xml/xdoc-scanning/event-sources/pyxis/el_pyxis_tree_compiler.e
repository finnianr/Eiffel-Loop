note
	description: "[
		Command to compile tree of UTF-8 encoded Pyxis source files into something else
		Performs file date time checking to decide if compilation target is up to date.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-14 9:34:59 GMT (Friday 14th June 2019)"
	revision: "3"

deferred class
	EL_PYXIS_TREE_COMPILER

inherit
	EL_COMMAND

	EL_MODULE_LIO

	EL_MODULE_FILE_SYSTEM

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_default
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make (a_source_tree_path: EL_DIR_PATH)
		do
			make_default
			source_tree_path := a_source_tree_path
		end

	make_default
		do
			Precursor
			create output_modification_time.make (agent new_output_modification_time)
			create source_tree_path
		end

feature -- Basic operations

	execute
			--
		do
			if source_changed then
				compile_tree
			else
				lio.put_line ("Source has not changed")
			end
		end

feature {NONE} -- Implementation

	compile_tree
		deferred
		end

	find_root_element (line: ZSTRING; merged: like merged_lines)
		local
			l_line: ZSTRING
		do
			l_line := line.twin
			l_line.right_adjust
			if not l_line.is_empty
				and then l_line [l_line.count] = ':'
				and then l_line [1] /= '#'
				and then not l_line.starts_with (Pyxis_doc)
			then
				if file_count = 1 then
					merged.extend (line)
				end
				state := agent merged.extend
			elseif file_count = 1 then
				merged.extend (line)
			end
		end

	merged_lines: EL_ZSTRING_LIST
		local
			path_list: like pyxis_file_path_list
			count: INTEGER
		do
			path_list := pyxis_file_path_list
			across path_list as source_path loop
				count := count + File_system.file_byte_count (source_path.item)
			end
			create Result.make (count // 60)
			file_count := 0
			across path_list as source_path loop
				lio.put_path_field ("Merging", source_path.item)
				lio.put_new_line
				file_count := file_count + 1
				do_once_with_file_lines (
					agent find_root_element (?, Result), create {EL_PLAIN_TEXT_LINE_SOURCE}.make (source_path.item)
				)
			end
		end

	new_output_modification_time: DATE_TIME
		deferred
		end

	pyxis_file_path_list: like File_system.recursive_files
		do
			Result := File_system.recursive_files_with_extension (source_tree_path, "pyx")
		end

	source_changed: BOOLEAN
		do
			Result := across pyxis_file_path_list as file_path some
				file_path.item.modification_date_time > output_modification_time.item
			end
		end

feature {NONE} -- Internal attributes

	output_modification_time: EL_DEFERRED_CELL [DATE_TIME]

	source_tree_path: EL_DIR_PATH

	file_count: INTEGER

feature {NONE} -- Constants

	Zero_time: DATE_TIME
		once
			create Result.make (0, 0, 0, 0, 0, 0)
		end

	Pyxis_doc: ZSTRING
		once
			Result := "pyxis-doc"
		end
end
