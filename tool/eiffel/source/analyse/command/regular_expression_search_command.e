note
	description: "Shell to search for regular expressions in source manifest files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 7:33:48 GMT (Monday 7th February 2022)"
	revision: "2"

class
	REGULAR_EXPRESSION_SEARCH_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			execute, make_default
		end

	EL_MODULE_FILE_SYSTEM; EL_MODULE_DIRECTORY; EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make_default
		do
			Precursor
			create results_table.make_size (0)
			create grep_command.make ("grep $OPTIONS $FILE_PATH")
			create var
			grep_command.fill_variables (var)
		end

feature -- Constants

	Description: STRING = "Searchs for a regular expression in Eiffel sources using grep command"

feature -- Basic operations

	execute
		local
			grep_options: ZSTRING; user_quit: BOOLEAN; count: INTEGER
		do
			create grep_options.make_empty
			from until user_quit loop
				from grep_options.wipe_out until grep_options.count > 0 loop
					grep_options := User_input.line ("Grep arguments")
				end
				grep_options.adjust
				user_quit := grep_options.same_string ("quit")
				if not user_quit then
					lio.put_new_line
					grep_command.put_string (var.options, grep_options)
					results_table.wipe_out
					Precursor
					lio.put_new_line
					count := matching_line_count
					if count = 0 then
						lio.put_line ("No matches found")
					else
						across results_table as table loop
							lio.put_path_field ("Source", table.key)
							lio.put_new_line
							across table.item as line loop
								lio.put_line (line.item)
							end
							lio.put_new_line
						end
						lio.put_integer_field ("Matches found", count)
						lio.put_new_line
					end
				end
			end
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		local
			lines: EL_ZSTRING_LIST
		do
			grep_command.put_path (var.file_path, source_path)
			grep_command.execute
			if grep_command.lines.count > 0 then
				lines := grep_command.lines.twin
				lines.left_adjust
				results_table.extend (lines, source_path)
			end
		end

	matching_line_count: INTEGER
		do
			across results_table as table loop
				Result := Result + table.item.count
			end
		end

feature {NONE} -- Internal attributes

	var: TUPLE [options, file_path: STRING]

	results_table: EL_HASH_TABLE [EL_ZSTRING_LIST, FILE_PATH]

	grep_command: EL_CAPTURED_OS_COMMAND

end