note
	description: "[
		Tool to migrate librares to newer compiler version by copying classes one by one to new library structure
		starting with classes that have the fewest dependencies on other classes in same library.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-21 14:33:15 GMT (Friday 21st November 2025)"
	revision: "3"

class
	LIBRARY_GRADUAL_COPY_COMMAND

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
			create class_table.make_equal (1)
			create class_list.make (100)
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
			done: BOOLEAN; level, small_count: INTEGER
		do
			Precursor
			lio.put_integer_field ("Total classes", class_table.count)
			lio.put_new_line
			from until done loop
				level := level + 1
				reduce_class_table (level)
				done := class_list.is_empty
			end

			if attached new_dependency_count_map_list as list then
				lio.put_new_line

				print_level (level)
				lio.put_integer_field ("Remaining classes", class_table.count)
				lio.put_new_line
				small_count := class_table.count // 10
				from list.start until list.after or else list.item_value > small_count loop
					lio.put_integer_field (list.item_key, list.item_value)
					lio.put_new_line
					list.forth
				end
				lio.put_new_line

				if attached new_big_dependency_count_group_table (list, small_count) as table then
					table.sort_by_key (True)
					from done := False; table.start until table.after or else done loop
						level := level + 1
						print_level (level)
						lio.put_integer_field ("Extensive dependency count", table.key_for_iteration)
						lio.put_new_line

						if attached table.item_for_iteration as level_list then
							level_list.sort (True)
							lio.put_columns (level_list, 3, 0)
							lio.put_new_line
							User_input.press_enter
							done := User_input.escape_pressed
						end
						table.forth
					end
				end
			end
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		local
			l_class: CLASS_DEPENDENCIES
		do
			if not source_path.has_step (Excluded_imp_step) then
				create l_class.make (source_path)
				class_table.extend (l_class, l_class.name)
			end
		end

	new_dependency_count_map_list: EL_ARRAYED_MAP_LIST [IMMUTABLE_STRING_8, INTEGER]
		do
			create Result.make (class_table.count)
			across class_table as table loop
				if table.cursor_index \\ 100 = 0 then
					lio.put_character ('.')
				end
				Result.extend (table.key, table.item.dependency_count (class_table))
			end
			Result.sort_by_value (True)
		end

	new_big_dependency_count_group_table (
		list: like new_dependency_count_map_list; threshold_count: INTEGER
	): EL_GROUPED_LIST_TABLE [IMMUTABLE_STRING_8, INTEGER]
		require
			valid_item: not list.off
		local
			done: BOOLEAN
		do
			create Result.make_equal (list.count // 10)
			from done := False until list.after or else done loop
				if class_table.has_key (list.item_key) then
					Result.extend (class_table.found_item.big_dependency_count (class_table, threshold_count), list.item_key)
				end
				list.forth
			end
		end

	print_level (n: INTEGER)
		do
			lio.put_integer_field ("LEVEL", n)
			lio.put_new_line_x2
		end

	read_manifest_files
		do
			Precursor
			class_table.accommodate (manifest.file_count)
		end

	reduce_class_table (level: INTEGER)
		do
			class_list.wipe_out
			across class_table.key_list as list loop
				if attached list.item as key and then class_table.has_key (key) then
					if across class_table.found_item.dependency_set as set all not class_table.has (set.item) end then
						class_list.extend (key)
						class_table.remove (key)
					end
				end
			end
			if class_list.count > 0 then
				class_list.sort (True)
				print_level (level)
				lio.put_columns (class_list, 3, 0)
				lio.put_integer_field ("count", class_list.count)
				lio.put_new_line_x2
			end
		end

feature {NONE} -- Internal attributes

	class_list: EL_ARRAYED_LIST [IMMUTABLE_STRING_8]

	class_table: EL_HASH_TABLE [CLASS_DEPENDENCIES, IMMUTABLE_STRING_8]

	destination_dir: DIR_PATH

	home_dir: DIR_PATH

feature {NONE} -- Constants

	Excluded_imp_step: ZSTRING
		once
			Result := if {PLATFORM}.is_unix then "imp_mswin" else "imp_unix" end
		end
end