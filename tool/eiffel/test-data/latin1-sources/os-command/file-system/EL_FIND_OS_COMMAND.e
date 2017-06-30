indexing
	description: "Summary description for {EL_FIND_OS_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_FIND_OS_COMMAND  [T -> EL_COMMAND_IMPL create default_create end, P -> PATH_NAME create make end]

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [T]
		rename
			make as make_path_command
		redefine
			Line_processing_enabled, do_with_lines
		end

feature {NONE} -- Initialization

	make (a_path: like path) is
			--
		do
			make_path_command (a_path)
			create exclude_containing_list.make
			create exclude_ending_list.make
			create path_list.make (20)
		end

feature -- Access

	path_list: EL_SHARED_PARENT_PATH_LIST [P]

feature -- Exclusion setting

	remove_exclusions is
			--
		do
			exclude_containing_list.wipe_out
			exclude_ending_list.wipe_out
		end

	exclude_path_containing_any_of (path_fragments: ARRAY [STRING]) is
			-- List of directory path fragments that exclude directories
		do
			path_fragments.do_all (agent exclude_containing_list.extend)
		end

	exclude_path_containing (path_fragment: STRING) is
			-- List of directory path fragments that exclude directories
		do
			exclude_containing_list.extend (path_fragment)
		end

	exclude_path_ending_any_of (path_endings: ARRAY [STRING]) is
			-- List of directory path fragments that exclude directories
		do
			path_endings.do_all (agent exclude_ending_list.extend)
		end

	exclude_path_ending (path_ending: STRING) is
			-- List of directory path fragments that exclude directories
		do
			exclude_ending_list.extend (path_ending)
		end

feature {EL_COMMAND_IMPL} -- Implementation

	do_with_lines (lines: EL_FILE_STRING_LIST) is
			--
		do
			from lines.start until lines.after loop
				if not is_output_line_excluded (lines.item) then
					path_list.extend (create {EL_PARENT_AND_BASENAME_PATH}.make (lines.item))
				end
				lines.forth
			end
		end

	exclude_containing_list: LINKED_LIST [STRING]

	exclude_ending_list: LINKED_LIST [STRING]

	is_output_line_excluded (line: STRING): BOOLEAN is
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

	Line_processing_enabled: BOOLEAN is true

end

