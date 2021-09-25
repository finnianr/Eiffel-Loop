note
	description: "[
		Command to compile a manifest list of UTF-8 encoded Pyxis source files into something else.
		Performs file date time checking to decide if compilation target is up to date.
	]"
	notes: "[
		The file manifest list is compiled in two ways:

		1. If the `a_source_tree_dir' argument exists then all `*.pyx' files under that directory are
		added to manifest list.

		2. If the `a_manifest_path' argument exists then the lines are iterated ignoring empty lines and lines
		starting with the # symbol.

		Lines expanded as paths with extension ''pyx'' are added to manifest, but if the path ends with a '/'
		character, the path is treated like a `a_source_tree_dir' argument.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-24 18:32:00 GMT (Friday 24th September 2021)"
	revision: "11"

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

	EL_LAZY_ATTRIBUTE_2
		rename
			item as output_modification_time,
			new_item as new_output_modification_time
		end

	EL_MODULE_PYXIS

	EL_FILE_OPEN_ROUTINES

feature {NONE} -- Initialization

	make (a_manifest_path: EL_FILE_PATH; a_source_tree_path: EL_DIR_PATH)
		do
			make_default
			manifest_path := a_manifest_path
			source_tree_path := a_source_tree_path
		end

	make_default
		do
			Precursor
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

	manifest_list: ARRAYED_LIST [EL_PATH]
		local
			line: ZSTRING; file_path: EL_FILE_PATH; path: EL_PATH
		do
			if source_tree_path.exists then
				create Result.make_from_array (<< source_tree_path >>)
			else
				create Result.make (0)
			end
			if manifest_path.exists then
				across open_lines (manifest_path, Utf_8) as list loop
					line := list.item
					if line.count > 0 and then line [1] /= '#' then
						if line.ends_with_character ('/') then
							line.remove_tail (1)
							create {EL_DIR_PATH} path.make (line)
						else
							file_path := line
							if file_path.has_extension ("pyx") then
								path := file_path
							else
								create {EL_DIR_PATH} path.make (line)
							end
						end
						path.expand
						if path.exists then
							Result.extend (path)
							lio.put_path_field ("Found", path)
						else
							lio.put_path_field ("Cannot find", path)
						end
						lio.put_new_line
					end
				end
			end
		end

	merged_lines: EL_ZSTRING_LIST
		local
			path_list: like pyxis_file_path_list
			count: INTEGER; markup: EL_MARKUP_ENCODING
		do
			path_list := pyxis_file_path_list
			across path_list as source_path loop
				count := count + File_system.file_byte_count (source_path.item)
			end
			create Result.make (count // 60)
			file_count := 0
			across path_list as source_path loop
				markup := Pyxis.encoding (source_path.item)
				lio.put_labeled_string ("Merging " + markup.name + " file", source_path.item.base)
				lio.put_new_line
				file_count := file_count + 1
				do_once_with_file_lines (agent find_root_element (?, Result), open_lines (source_path.item, markup.encoding))
			end
		end

	new_output_modification_time: EL_DATE_TIME
		deferred
		end

	pyxis_file_path_list: ARRAYED_LIST [EL_FILE_PATH]
		do
			create Result.make (0)
			across manifest_list as path loop
				if attached {EL_FILE_PATH} path.item as file_path then
					Result.extend (file_path)

				elseif attached {EL_DIR_PATH} path.item as dir_path then
					Result.append (File_system.files_with_extension (dir_path, "pyx", True))
				end
			end
		end

	source_changed: BOOLEAN
		do
			Result := across pyxis_file_path_list as file_path some
				file_path.item.modification_date_time > output_modification_time
			end
		end

feature {NONE} -- Internal attributes

	manifest_path: EL_FILE_PATH

	source_tree_path: EL_DIR_PATH

	file_count: INTEGER

feature {NONE} -- Constants

	Zero_time: EL_DATE_TIME
		once
			create Result.make_from_epoch (0)
		end

	Pyxis_doc: ZSTRING
		once
			Result := "pyxis-doc"
		end
end