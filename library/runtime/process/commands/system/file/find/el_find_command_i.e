note
	description: "Find command abstraction"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-31 9:52:34 GMT (Sunday 31st December 2023)"
	revision: "27"

deferred class
	EL_FIND_COMMAND_I

inherit
	EL_DIR_PATH_OPERAND_COMMAND_I
		undefine
			do_command, is_captured, new_command_parts, reset
		redefine
			getter_function_table, make_default
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			getter_function_table, new_transient_fields
		redefine
			make_default, do_with_lines, reset
		end

	EL_MODULE_OS

feature {NONE} -- Initialization

	make_default
			--
		do
			path_list := new_path_list (20)
			Precursor
			set_defaults
		end

feature -- Access

	depth_range: INTEGER_INTERVAL
		do
			Result := min_depth |..| max_depth
		end

	max_depth: INTEGER
		-- See: man find on Unix

	min_depth: INTEGER
		-- See: man find on Unix

	name_pattern: ZSTRING

	path_list: like new_path_list note option: transient attribute end

	sorted_path_list: like path_list
		do
			Result := path_list
			Result.ascending_sort
		end

	type: STRING
			-- Unix find type or Windows attribute /A
		deferred
		end

feature -- Status

	follow_symbolic_links: BOOLEAN

	limitless_max_depth: BOOLEAN
		do
			Result := max_depth = max_depth.Max_value
		end

feature -- Status change

	set_default_filter
		do
			filter := Default_filter
		end

	set_filter (condition: like filter)
		do
			filter := condition
		end

	set_follow_symbolic_links (flag: like follow_symbolic_links)
			--
		do
			follow_symbolic_links := flag
		end

	set_predicate_filter (condition: EL_PREDICATE_FIND_CONDITION)
		-- set agent predicate filter
		do
			filter := condition
		end

feature -- Element change

	set_default_depths
		do
			min_depth := 0
			max_depth := max_depth.Max_value
		end

	set_defaults
		-- set default settings
		do
			filter := Default_filter
			follow_symbolic_links := True
			set_default_depths
			name_pattern.wipe_out
		end

	set_depth (a_min_depth, a_max_depth: INTEGER)
		require
			valid_range: a_min_depth >= 0 and a_min_depth <= a_max_depth
		do
			set_min_depth (a_min_depth); set_max_depth (a_max_depth)
		end

	set_max_depth (a_max_depth: like max_depth)
		do
			max_depth := a_max_depth
		end

	set_min_depth (a_min_depth: like min_depth)
		do
			min_depth := a_min_depth
		end

	set_name_pattern (a_name_pattern: READABLE_STRING_GENERAL)
			--
		do
			name_pattern.wipe_out
			name_pattern.append_string_general (a_name_pattern)
		end

feature -- Basic operations

	copy_directory_items (destination_dir: DIR_PATH)
		-- copy each directory content item at level 1 to `destination_dir'
		local
			l_depth_range: like depth_range
		do
			l_depth_range := depth_range

			set_depth (1, 1); execute
			across path_list as source_dir loop
				if is_lio_enabled then
					lio.put_path_field ("Copying", source_dir.item)
					lio.tab_right
					lio.put_new_line
					lio.put_path_field ("to", destination_dir)
					lio.tab_left
					lio.put_new_line
				end
				copy_path_item (source_dir.item, destination_dir)
				if is_lio_enabled then
					lio.put_new_line
				end
			end
			set_depth (l_depth_range.lower, l_depth_range.upper)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["name_pattern",		agent: ZSTRING do Result := name_pattern end],
				["use_name_pattern",	agent use_name_pattern],

				["type",					agent: STRING do Result := type end],
				["max_depth",			agent: INTEGER_REF do Result := max_depth.to_reference end],
				["min_depth",			agent: INTEGER_REF do Result := min_depth.to_reference end]
			>>)
		end

	use_name_pattern: BOOLEAN_REF
		do
			Result := not (name_pattern.is_empty or name_pattern.is_character ('*'))
		end

feature {NONE} -- Implementation

	copy_path_item (source_path: like new_path; destination_dir: DIR_PATH)
		deferred
		end

	do_with_lines (lines: like new_output_lines)
			--
		local
			line: ZSTRING
		do
			from lines.start until lines.after loop
				line := lines.item
				if line.count > 0 and then filter.met (line) then
					path_list.extend (new_path (line))
				end
				lines.forth
			end
		end

	new_path (a_path: ZSTRING): EL_PATH
		deferred
		end

	new_path_list (n: INTEGER): EL_SORTABLE_ARRAYED_LIST [like new_path]
		deferred
		end

	reset
			--
		do
			Precursor {EL_CAPTURED_OS_COMMAND_I}
			create path_list.make (0)
		end

feature {NONE} -- Internal attributes

	filter: EL_QUERY_CONDITION [ZSTRING] note option: transient attribute end

feature {NONE} -- Constants

	Default_filter: EL_ANY_FILE_FIND_CONDITION
		once
			create Result
		end

end