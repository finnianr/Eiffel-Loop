note
	description: "Summary description for {EL_FIND_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:21 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_FIND_OS_COMMAND  [T -> EL_FIND_COMMAND_IMPL create default_create end, P -> EL_PATH create make end]

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [T]
		rename
			make as make_path_command
		redefine
			execute, do_with_line, path, make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create exclude_containing_list.make
			create exclude_ending_list.make
			create path_list.make (20)
			is_recursive := True
		end

	make (a_path: like path)
			--
		do
			make_path_command (a_path)
		end

feature -- Access

	path_list: ARRAYED_LIST [P]

	path: EL_DIR_PATH

feature -- Status

	follow_symbolic_links: BOOLEAN

	is_recursive: BOOLEAN

feature -- Element change

	set_follow_symbolic_links (flag: like follow_symbolic_links)
			--
		do
			follow_symbolic_links := flag
		end

	set_is_recursive (flag: like is_recursive)
			--
		do
			is_recursive := flag
		end

feature -- Basic operations

	execute
			--
		do
			path_list.wipe_out
			Precursor
		end

feature -- Exclusion setting

	remove_exclusions
			--
		do
			exclude_containing_list.wipe_out
			exclude_ending_list.wipe_out
		end

	exclude_path_containing_any_of (path_fragments: ARRAY [STRING])
			-- List of directory path fragments that exclude directories
		do
			path_fragments.do_all (agent exclude_containing_list.extend)
		end

	exclude_path_containing (path_fragment: STRING)
			-- List of directory path fragments that exclude directories
		do
			exclude_containing_list.extend (path_fragment)
		end

	exclude_path_ending_any_of (path_endings: ARRAY [STRING])
			-- List of directory path fragments that exclude directories
		do
			path_endings.do_all (agent exclude_ending_list.extend)
		end

	exclude_path_ending (path_ending: STRING)
			-- List of directory path fragments that exclude directories
		do
			exclude_ending_list.extend (path_ending)
		end

feature {EL_COMMAND_IMPL} -- Implementation

	do_with_line (line: STRING)
			--
		do
			if not is_recursive then
				implementation.adjust_for_non_recursive (Current, line)
			end
			if not is_output_line_excluded (line) then
				if is_path_latin1 then
					path_list.extend (create {P}.make (String.utf8_as_latin1 (line)))
				else
					path_list.extend (create {P}.make (line))
				end
			end
		end

	is_output_line_excluded (line: STRING): BOOLEAN
			--
		do
			Result := line.is_empty
			if not exclude_containing_list.is_empty then
				Result := not exclude_containing_list.for_all (agent String.not_a_has_substring_b (line, ?))
			end
			if not Result and then not exclude_ending_list.is_empty then
				Result := not exclude_ending_list.for_all (agent String.not_a_ends_with_b (line, ?))
			end
		end

	exclude_containing_list: LINKED_LIST [STRING]

	exclude_ending_list: LINKED_LIST [STRING]

end
