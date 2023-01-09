note
	description: "[
		Tool to migrate librares to newer compiler version by copying classes one by one to new library structure
		starting with classes that do not depend on other classes within the library
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-09 10:04:02 GMT (Monday 9th January 2023)"
	revision: "27"

class
	LIBRARY_MIGRATION_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		rename
			make as make_command
		redefine
			execute
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_OS; EL_MODULE_USER_INPUT

	EL_FILE_OPEN_ROUTINES

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (manifest_path: FILE_PATH; a_home_dir: DIR_PATH; suffix: STRING)
		require
			home_dir_exists: a_home_dir.exists
			suffix_not_empty: suffix.count > 0
		do
			home_dir := a_home_dir; destination_dir := a_home_dir.parent #+ (a_home_dir.base + suffix)
			make_command (manifest_path)
			create class_list.make (manifest.file_count)
			create library_set.make (manifest.file_count)
			create class_path_table.make (manifest.file_count)
		end

feature -- Constants

	Description: STRING = "Move library contents class by class in order of lowest dependency count"

feature -- Basic operations

	execute
		local
			reference_set, removal_set: EL_HASH_SET [STRING]
			i: INTEGER; destination_path, source_path: FILE_PATH
			name_array: ARRAY [STRING]
		do
			Precursor
			bind_circular

			create removal_set.make (0)
			from until class_list.is_empty or i > 10 loop
				i := i + 1
				print_iteration (i)
				removal_set.wipe_out
				across class_list as list loop
					reference_set := list.item.class_reference_set
					reference_set.intersect (library_set)
					print_class_heading (list.item.name)
					if reference_set.count = 0 then
						print_line ("No dependencies")
						if attached list.item.circular_dependent as dependent then
							name_array := << list.item.name, dependent.name >>
						else
							name_array := << list.item.name >>
						end
						prompt_user (name_array)
						across name_array as name loop
							removal_set.put (name.item)
							source_path := class_path_table [name.item]
							destination_path := destination_dir + source_path.relative_path (home_dir)
							File_system.make_directory (destination_path.parent)
							OS.copy_file (source_path, destination_path)
						end
					else
						across reference_set as set loop
							print_line (set.item)
						end
					end
					print_tab_left
				end
				class_list.prune_those (agent in_set (?, removal_set))
				library_set.subtract (removal_set)
			end
		end

feature {NONE} -- Implementation

	bind_circular
		local
			circular_set: EL_HASH_SET [STRING]
		do
			create circular_set.make (10)
			across class_list as list loop
				if not circular_set.has (list.item.name) then
					across class_list as l_class until attached list.item.circular_dependent loop
						if l_class.item /= list.item then
							list.item.try_bind (l_class.item)
							if attached list.item.circular_dependent as dependent then
								circular_set.put (dependent.name)
							end
						end
					end
				end
			end
			class_list.prune_those (agent in_set (?, circular_set))
			library_set.subtract (circular_set)
		end

	do_with_file (source_path: FILE_PATH)
		local
			name: STRING
		do
			if not source_path.has_step (Excluded_imp_step) then
				class_list.extend (create {LIBRARY_CLASS}.make (source_path))
				name := source_path.base_name; name.to_upper
				class_path_table.extend (source_path, name)
				library_set.put (name)
			end
		end

	in_set (a_class: LIBRARY_CLASS; removal_set: EL_HASH_SET [STRING]): BOOLEAN
		do
			Result := removal_set.has (a_class.name)
		end

	print_iteration (i: INTEGER)
		do
		end

	print_class_heading (name: STRING)
		do
		end

	print_line (line: STRING)
		do
		end

	print_tab_left
		do
		end

	prompt_user (name_array: ARRAY [STRING])
		local
			s: EL_STRING_8_ROUTINES
		do
			if attached User_input.line ("Press <Enter> to copy file " + s.joined_with (name_array, " and ")) then
			end
		end

feature {NONE} -- Internal attributes

	class_list: EL_ARRAYED_LIST [LIBRARY_CLASS]

	class_path_table: HASH_TABLE [FILE_PATH, STRING]

	destination_dir: DIR_PATH

	home_dir: DIR_PATH

	library_set: EL_HASH_SET [STRING]

feature {NONE} -- Constants

	Excluded_imp_step: ZSTRING
		once
			if {PLATFORM}.is_unix then
				Result := "imp_mswin"
			else
				Result := "imp_unix"
			end
		end
end