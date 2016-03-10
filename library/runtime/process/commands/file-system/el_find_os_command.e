note
	description: "Summary description for {EL_FIND_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:07:47 GMT (Wednesday 16th December 2015)"
	revision: "6"

class
	EL_FIND_OS_COMMAND  [
		T -> EL_FIND_COMMAND_IMPL create make end,
		P -> EL_PATH create make end
	]

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [T]
		rename
			path as dir_path
		redefine
			Line_processing_enabled, do_command, do_with_lines, getter_function_table, make_default,
			new_output_lines, dir_path
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			create exclude_containing_list.make
			create exclude_ending_list.make
			create path_list.make (20)
			is_recursive := True
			follow_symbolic_links := True
			Precursor
		end

feature -- Access

	path_list: ARRAYED_LIST [EL_PATH]

	dir_path: EL_DIR_PATH

feature -- Status

	follow_symbolic_links: BOOLEAN

	is_recursive: BOOLEAN

feature -- Element change

	set_follow_symbolic_links (flag: like follow_symbolic_links)
			--
		do
			follow_symbolic_links := flag
		end

	enable_recursion
			--
		do
			is_recursive := True
		end

	disable_recursion
			--
		do
			is_recursive := False
		end

feature -- Exclusion setting

	remove_exclusions
			--
		do
			exclude_containing_list.wipe_out
			exclude_ending_list.wipe_out
		end

	exclude_path_containing_any_of (path_fragments: ARRAY [ZSTRING])
			-- List of directory path fragments that exclude directories
		do
			path_fragments.do_all (agent exclude_containing_list.extend)
		end

	exclude_path_containing (path_fragment: ZSTRING)
			-- List of directory path fragments that exclude directories
		do
			exclude_containing_list.extend (path_fragment)
		end

	exclude_path_ending_any_of (path_endings: ARRAY [ZSTRING])
			-- List of directory path fragments that exclude directories
		do
			path_endings.do_all (agent exclude_ending_list.extend)
		end

	exclude_path_ending (path_ending: ZSTRING)
			-- List of directory path fragments that exclude directories
		do
			exclude_ending_list.extend (path_ending)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["follow_symbolic_links", 	agent: BOOLEAN_REF do Result := follow_symbolic_links.to_reference end],
				["is_recursive",			 	agent: BOOLEAN_REF do Result := is_recursive.to_reference end]
			>>)
		end

feature {EL_COMMAND_IMPL} -- Implementation

	do_command (a_system_command: ZSTRING)
			--
		do
			path_list.wipe_out
			Precursor (a_system_command)
		end

	do_with_lines (lines: EL_FILE_LINE_SOURCE)
			--
		local
			line: ZSTRING
		do
			from lines.start until lines.after loop
				line := lines.item
				if not is_output_line_excluded (line) then
					path_list.extend (create {P}.make (line))
				end
				lines.forth
			end
		end

	new_output_lines (output_file_path: EL_FILE_PATH): EL_FILE_LINE_SOURCE
		do
			implementation.adjust (Current, output_file_path)
			Result := Precursor (output_file_path)
		end

	is_output_line_excluded (line: ZSTRING): BOOLEAN
			--
		do
			Result := line.is_empty
			if not exclude_containing_list.is_empty then
				Result := across exclude_containing_list as excluded some line.has_substring (excluded.item) end
			end
			if not Result and then not exclude_ending_list.is_empty then
				Result := across exclude_ending_list as excluded some line.ends_with (excluded.item)  end
			end
		end

	exclude_containing_list: LINKED_LIST [ZSTRING]

	exclude_ending_list: LINKED_LIST [ZSTRING]

	Line_processing_enabled: BOOLEAN = true

end
