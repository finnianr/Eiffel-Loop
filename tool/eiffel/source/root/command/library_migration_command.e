note
	description: "[
		Tool to migrate librares to newer compiler version by copying classes one by one to new library structure
		starting with classes that do not depend on other classes within the library
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-18 13:06:48 GMT (Tuesday 18th November 2025)"
	revision: "37"

class
	LIBRARY_MIGRATION_COMMAND
	
obsolete "Use LIBRARY_GRADUAL_COPY_COMMAND"

inherit
	SOURCE_MANIFEST_COMMAND
		rename
			make as make_command
		redefine
			execute, read_manifest_files
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_OS; EL_MODULE_USER_INPUT

	EL_FILE_OPEN_ROUTINES

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (manifest_path, alias_map_path: FILE_PATH; a_home_dir: DIR_PATH; suffix: STRING; dry_run: BOOLEAN)
		require
			home_dir_exists: a_home_dir.exists
			suffix_not_empty: suffix.count > 0
		local
			set_compiler: COMPACT_CLASS_NAME_SET_COMPILER
		do
			home_dir := a_home_dir; destination_dir := a_home_dir.parent #+ (a_home_dir.base + suffix)
			if alias_map_path.exists then
				create set_compiler.make_alias_table (alias_map_path)
			end
			is_dry_run := dry_run
			make_command (manifest_path)
			create class_list.make (0)
			create library_set.make_equal (0)
			create class_path_table.make_equal (0)
			prompt := True
		end

feature -- Constants

	Description: STRING = "Move library contents class by class in order of lowest dependency count"

feature -- Status query

	is_dry_run: BOOLEAN

	prompt: EL_BOOLEAN_OPTION

feature -- Basic operations

	execute
		local
			dependency_set, removal_set: EL_HASH_SET [IMMUTABLE_STRING_8]
			i: INTEGER; destination_path, source_path: FILE_PATH
			name_array: ARRAY [IMMUTABLE_STRING_8]
		do
			Precursor

			create removal_set.make_equal (0)
			from until class_list.is_empty or i > 10 loop
				i := i + 1
				print_iteration (i)
				removal_set.wipe_out
				across class_list as list loop
					dependency_set := list.item.dependency_set
					dependency_set.intersect (library_set)
					print_class_heading (list.item.name)
					if dependency_set.count = 0 then
						print_line ("No dependencies")
						name_array := << list.item.name >>
						prompt_user (name_array)
						if not is_dry_run then
							across name_array as name loop
								removal_set.put (name.item)
								source_path := class_path_table [name.item]
								destination_path := destination_dir + source_path.relative_path (home_dir)
								File_system.make_directory (destination_path.parent)
								OS.copy_file (source_path, destination_path)
							end
						end
					else
						lio.put_columns (dependency_set, 3, 40)
					end
					lio.put_new_line
				end
				class_list.prune_those (agent in_set (?, removal_set))
				library_set.subtract (removal_set)
			end
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		do
			if not source_path.has_step (Excluded_imp_step) then
				class_list.extend (create {CLASS_DEPENDENCIES}.make (source_path))
				if attached class_list.last.name as name then
					class_path_table.extend (source_path, name)
					library_set.put (name)
				end
			end
		end

	in_set (a_class: CLASS_DEPENDENCIES; removal_set: EL_HASH_SET [IMMUTABLE_STRING_8]): BOOLEAN
		do
			Result := removal_set.has (a_class.name)
		end

	print_class_heading (name: IMMUTABLE_STRING_8)
		do
			lio.put_labeled_string ("Class", name)
			lio.put_new_line_x2
		end

	print_iteration (i: INTEGER)
		do
			lio.put_integer_field ("ITERATION", i)
			lio.put_new_line
		end

	print_line (line: IMMUTABLE_STRING_8)
		do
			lio.put_line (line)
		end

	prompt_user (name_array: ARRAY [IMMUTABLE_STRING_8])
		local
			s: EL_STRING_8_ROUTINES
		do
			if attached s.joined_with_string (name_array, " and ") as str then
				if prompt.is_enabled and then attached User_input.line ("Press <Enter> to copy file " + str) then
					do_nothing
				else
					lio.put_labeled_string ("Copying", str)
					lio.put_new_line
				end
			end
		end

	read_manifest_files
		do
			Precursor
			class_list.grow (manifest.file_count)
			library_set.accommodate (manifest.file_count)
			class_path_table.accommodate (manifest.file_count)
		end

feature {NONE} -- Internal attributes

	class_list: EL_ARRAYED_LIST [CLASS_DEPENDENCIES]

	class_path_table: HASH_TABLE [FILE_PATH, IMMUTABLE_STRING_8]

	destination_dir: DIR_PATH

	home_dir: DIR_PATH

	library_set: EL_HASH_SET [IMMUTABLE_STRING_8]

feature {NONE} -- Constants

	Excluded_imp_step: ZSTRING
		once
			Result := if {PLATFORM}.is_unix then "imp_mswin" else "imp_unix" end
		end
end