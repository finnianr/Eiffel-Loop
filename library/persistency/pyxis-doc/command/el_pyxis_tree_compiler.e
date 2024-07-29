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
	date: "2024-07-29 8:20:26 GMT (Monday 29th July 2024)"
	revision: "26"

deferred class
	EL_PYXIS_TREE_COMPILER

inherit
	EL_COMMAND

	EL_MODULE_EXCEPTION; EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO; EL_MODULE_USER_INPUT

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
			create source_tree_path
		end

feature -- Status query

	is_updated: BOOLEAN

feature -- Basic operations

	execute
			--
		do
			if source_changed then
				compile
				is_updated := True
			else
				lio.put_line ("Source has not changed")
				is_updated := False
			end
		end

feature {NONE} -- Deferred

	compile
		deferred
		end

	output_modification_time: INTEGER
		deferred
		end

feature {NONE} -- Implementation

	new_manifest: EL_PYXIS_FILE_MANIFEST
		do
			create Result.make (manifest_path, Pyx_extension)
			if is_lio_enabled then
				from until not Result.has_errors loop
					lio.put_line ("FIX PATH ERRORS")
					Result.display_bad_paths (lio)
					lio.put_new_line
					if User_input.approved_action_y_n ("Retry") then
						create Result.make (manifest_path, Pyx_extension)
					end
				end
			elseif Result.has_errors then
				Exception.raise_developer ("Manifest %S has path errors", [manifest_path.base])
			end
		end

	new_merged_lines: EL_MERGED_PYXIS_LINE_LIST
		do
			create Result.make (new_source_path_list)
		end

	new_source_path_list: EL_FILE_PATH_LIST
		do
			if source_tree_path.exists then
				Result := File_system.files_with_extension (source_tree_path, Pyx_extension, True)

			elseif manifest_path.exists then
				Result := new_manifest.new_file_list
			else
				create Result.make (0)
			end
		end

	new_relative_source_path_list: EL_FILE_PATH_LIST
		do
			if source_tree_path.exists and then
				attached File_system.files_with_extension (source_tree_path, Pyx_extension, True) as path_list
			then
				Result := path_list.relative_list (source_tree_path)

			elseif manifest_path.exists and then attached new_manifest.location_file_map_list as list then
				create Result.make (list.count)
				from list.start until list.after loop
					Result.extend (list.item_value.relative_path (list.item_key))
					list.forth
				end
			else
				create Result.make (0)
			end
		end

	source_changed: BOOLEAN
		local
			modification_time: INTEGER
		do
			modification_time := output_modification_time
			Result := across new_source_path_list as file_path some
				file_path.item.modification_time > modification_time
			end
		end

feature {NONE} -- Internal attributes

	manifest_path: FILE_PATH

	source_tree_path: DIR_PATH

feature {NONE} -- Constants

	Pyx_extension: STRING = "pyx"

end