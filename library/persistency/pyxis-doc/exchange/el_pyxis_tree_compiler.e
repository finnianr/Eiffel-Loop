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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-30 16:14:21 GMT (Saturday 30th December 2023)"
	revision: "23"

deferred class
	EL_PYXIS_TREE_COMPILER

inherit
	EL_COMMAND

	EL_MODULE_FILE_SYSTEM; EL_MODULE_FILE; EL_MODULE_LIO

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_default
		redefine
			make_default
		end

	EL_MODULE_PYXIS; EL_MODULE_USER_INPUT

	EL_FILE_OPEN_ROUTINES

feature {NONE} -- Initialization

	make (a_manifest_path: FILE_PATH; a_source_tree_path: DIR_PATH)
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

feature -- Status query

	is_updated: BOOLEAN

feature -- Basic operations

	execute
			--
		do
			if source_changed then
				compile_tree
				is_updated := True
			else
				lio.put_line ("Source has not changed")
				is_updated := False
			end
		end

feature {NONE} -- Line states

	find_root_element (line: ZSTRING; merged: like merged_lines)
		do
			line.right_adjust
			if line.count > 0
				and then line [line.count] = ':'
				and then line [1] /= '#'
				and then not Pyxis.is_declaration (line)
			then
				if file_count = 1 then
					merged.extend (line)
				end
				state := agent merged.extend
			elseif file_count = 1 then
				merged.extend (line)
			end
		end

feature {NONE} -- Deferred

	compile_tree
		deferred
		end

	output_modification_time: INTEGER
		deferred
		end

feature {NONE} -- Implementation

	merged_lines: EL_ZSTRING_LIST
		local
			path_list: like translations_path_list
			count: INTEGER; markup: EL_MARKUP_ENCODING
		do
			path_list := translations_path_list
			across path_list as source_path loop
				count := count + File.byte_count (source_path.item)
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

	source_changed: BOOLEAN
		local
			modification_time: INTEGER
		do
			modification_time := output_modification_time
			Result := across translations_path_list as file_path some
				file_path.item.modification_time > modification_time
			end
		end

	translations_path_list: EL_FILE_PATH_LIST
		local
			manifest: EL_PYXIS_FILE_MANIFEST
		do
			if source_tree_path.exists then
				Result := File_system.files_with_extension (source_tree_path, Pyx_extension, True)

			elseif manifest_path.exists then
				create manifest.make (manifest_path, Pyx_extension)
				from until not manifest.has_errors loop
					lio.put_line ("FIX PATH ERRORS")
					manifest.display_bad_paths (lio)
					lio.put_new_line
					if User_input.approved_action_y_n ("Retry") then
						create manifest.make (manifest_path, Pyx_extension)
					end
				end
				Result := manifest.file_list
			else
				create Result.make (0)
			end
		end

feature {NONE} -- Internal attributes

	file_count: INTEGER

	manifest_path: FILE_PATH

	source_tree_path: DIR_PATH

feature {NONE} -- Constants

	Pyx_extension: STRING = "pyx"

end