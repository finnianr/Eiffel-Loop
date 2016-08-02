note
	description: "Summary description for {EL_FIND_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-30 10:18:54 GMT (Thursday 30th June 2016)"
	revision: "1"

deferred class
	EL_FIND_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as dir_path
		undefine
			do_command, new_command_string, reset
		redefine
			getter_function_table, make_default,
			dir_path
		end

	EL_CAPTURED_OS_COMMAND_I
		redefine
			make_default,
			do_with_lines, getter_function_table, reset
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			is_path_included := agent is_any_path
			create path_list.make (20)
			follow_symbolic_links := True
			set_limitless_max_depth
			create name_pattern.make_empty
			Precursor {EL_SINGLE_PATH_OPERAND_COMMAND_I}
		end

feature -- Access

	dir_path: EL_DIR_PATH

	max_depth: INTEGER
		-- See: man find on Unix

	min_depth: INTEGER
		-- See: man find on Unix

	name_pattern: ZSTRING

	path_list: EL_ARRAYED_LIST [like new_path]

	type: STRING
			-- Unix find type
		deferred
		end

feature -- Status

	follow_symbolic_links: BOOLEAN

	limitless_max_depth: BOOLEAN
		do
			Result := max_depth = max_depth.Max_value
		end

feature -- Status change

	set_follow_symbolic_links (flag: like follow_symbolic_links)
			--
		do
			follow_symbolic_links := flag
		end

feature -- Path filter change

	set_any_path_included
		do
			is_path_included := agent is_any_path
			not_path_included := False
		end

	set_path_included_condition (condition: like is_path_included)
		do
			is_path_included := condition
			not_path_included := False
		end

	set_not_path_included_condition (condition: like is_path_included)
			-- set inverse of `set_path_included_condition'
		do
			is_path_included := condition
			not_path_included := True
		end

feature -- Element change

	set_depth (interval: INTEGER_INTERVAL)
		do
			min_depth := interval.lower; max_depth := interval.upper
		end

	set_limitless_max_depth
		do
			max_depth := max_depth.Max_value
		end

	set_max_depth (a_max_depth: like max_depth)
		do
			max_depth := a_max_depth
		end

	set_min_depth (a_min_depth: like min_depth)
		do
			min_depth := a_min_depth
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["name_pattern", 				agent: ZSTRING do Result := name_pattern end],
				["follow_symbolic_links", 	agent: BOOLEAN_REF do Result := follow_symbolic_links.to_reference end],
				["limitless_max_depth",		agent: BOOLEAN_REF do Result := limitless_max_depth.to_reference end],
				["max_depth", 					agent: INTEGER_REF do Result := max_depth.to_reference end],
				["min_depth", 					agent: INTEGER_REF do Result := min_depth.to_reference end],
				["type",							agent: STRING do Result := type end]
			>>)
		end

feature {NONE} -- Implementation

	do_with_lines (lines: like adjusted_lines)
			--
		local
			line: ZSTRING; is_included, all_included: BOOLEAN
		do
			all_included := (create {EL_PREDICATE}.make (agent is_any_path)).same_predicate (is_path_included)
			from lines.start until lines.after loop
				line := lines.item
				if line.is_empty then
					is_included := False
				elseif all_included then
					is_included := True
				elseif not_path_included then
					is_included := not is_path_included (line)
				else
					is_included := is_path_included (line)
				end
				if is_included then
					path_list.extend (new_path (line))
				end
				lines.forth
			end
		end

	is_any_path (line: ZSTRING): BOOLEAN
		do
			Result := True
		end

	new_path (a_path: ZSTRING): EL_PATH
		deferred
		end

	reset
			--
		do
			Precursor {EL_CAPTURED_OS_COMMAND_I}
			path_list.wipe_out
		end

feature {NONE} -- Internal attributes

	is_path_included: PREDICATE [ANY, TUPLE [ZSTRING]]

	not_path_included: BOOLEAN

end