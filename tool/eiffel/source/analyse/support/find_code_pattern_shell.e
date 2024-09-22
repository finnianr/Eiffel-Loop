note
	description: "Command shell to find Eiffel code patterns in sources defined by manifest"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 17:07:04 GMT (Sunday 22nd September 2024)"
	revision: "4"

class
	FIND_CODE_PATTERN_SHELL

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		undefine
			error_check
		select
			execute
		end

	SOURCE_MANIFEST_COMMAND
		rename
			execute as read_sources
		redefine
			make_default
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_LIO; EL_MODULE_USER_INPUT

	EL_ZSTRING_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make_default
		do
			Precursor
			create match_table.make_equal (20)
			make_shell ("PATTERN MENU", 10)
		end

feature -- Constants

	Description: STRING = "Command shell to find Eiffel code patterns in sources defined by manifest"

feature {NONE} -- Commands

	class_link_reference (source_lines: EL_PLAIN_TEXT_LINE_SOURCE)
		local
			line: ZSTRING; start_index, end_index, right_index: INTEGER
			found: BOOLEAN
		do
			if attached Occurrence_intervals as intervals_list then
				across source_lines as list loop
					line := list.shared_item
					intervals_list.fill_by_string (line, Dollor_brace, 0)
					found := False
					across intervals_list as interval until found loop
						start_index := interval.item_lower
						end_index := line.index_of ('}', start_index + 2)
						if end_index > 0 then
							right_index := line.index_of (']', start_index + 2)
							if right_index > 0 and then right_index < end_index then
								match_table.extend (source_lines.file_path, line.twin)
								found := True
							end
						end
					end
				end
			end
		end

	find_if_else_end (source_lines: EL_PLAIN_TEXT_LINE_SOURCE)
		local
			line, word: ZSTRING; match_list: like Once_match_list; done: BOOLEAN_REF
			match_list_count, tab_count: INTEGER
		do
			match_list := Once_match_list; match_list.wipe_out
			create done

			if attached Word_split as split_list then
				across source_lines as list loop
					line := list.shared_item
					split_list.set_target (line)
					done.set_item (False); match_list_count := match_list.count
					across split_list as split until done.item loop
						word := split.item; word.left_adjust
						match_list.extend (line.twin, word, split.cursor_index, done)
					end
					if match_list_count + 1 /= match_list.count then
						match_list.wipe_out
					end
					if match_list.count = 5 then
						tab_count := match_list.first.leading_occurrences ('%T')
						if tab_count > 0 then
							match_list.unindent (tab_count)
						end
						across match_list as m_list loop
							match_table.extend (source_lines.file_path, m_list.item)
						end
						match_list.wipe_out
					end
				end
			end
		end

feature {NONE} -- Implementation

	extend_match_list (word: ZSTRING; index: INTEGER; done: BOOLEAN_REF)
		do
			done.set_item (True)
		end

	do_with_file (source_path: FILE_PATH)
		local
			source: SOURCE_FILE
		do
			create source.make_open_read (source_path)
			find (source.lines)
			source.close
		end

	search (a_find: like find)
		do
			find := a_find
			read_sources
			across match_table as table loop
				lio.put_labeled_string ("Source", table.key)
				lio.put_new_line
				across table.item as list loop
					lio.put_line (list.item)
				end
				lio.put_new_line
			end
			match_table.wipe_out
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make_assignments (<<
				["Find ${<TYPE> [G]}",							 agent search (agent class_link_reference)],
				["Find `Result := if else end' candidate", agent search (agent find_if_else_end)]
			>>)
		end

feature {NONE} -- Internal attributes

	match_table: EL_GROUPED_LIST_TABLE [ZSTRING, FILE_PATH]

	find: PROCEDURE [EL_PLAIN_TEXT_LINE_SOURCE]

feature {NONE} -- Constants

	Dollor_brace: ZSTRING
		once
			Result := "${"
		end

	Word_split: EL_SPLIT_ZSTRING_ON_CHARACTER
		once
			create Result.make_adjusted (Empty_string, ' ', {EL_SIDE}.Left)
		end

	Once_match_list: IF_ELSE_ASSIGN_MATCH_LIST
		once
			create Result.make_empty
		end

	Occurrence_intervals: EL_OCCURRENCE_INTERVALS
		once
			create Result.make_empty
		end

end