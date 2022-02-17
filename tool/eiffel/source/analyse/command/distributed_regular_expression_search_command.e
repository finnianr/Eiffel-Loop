note
	description: "Shell to search for regular expressions in source manifest files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-17 15:48:57 GMT (Thursday 17th February 2022)"
	revision: "5"

class
	DISTRIBUTED_REGULAR_EXPRESSION_SEARCH_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			execute, make_default
		end

	EL_MODULE_FILE_SYSTEM; EL_MODULE_DIRECTORY; EL_MODULE_USER_INPUT

	EL_ENCODING_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make_default
		do
			Precursor
			create grep_options.make_empty
			create results_table.make_size (0)
			create grep_pool.make (0, agent new_grep_command)
			create recycle_list.make (8)
			create distributer.make (0)
		end

feature -- Constants

	Description: STRING = "Searchs for a regular expression in Eiffel sources using grep command"

feature -- Basic operations

	execute
		local
			user_quit: BOOLEAN; count: INTEGER
		do
			from until user_quit loop
				from grep_options.wipe_out until grep_options.count > 0 loop
					grep_options := User_input.line ("Grep arguments")
				end
				grep_options.adjust
				user_quit := grep_options.same_string ("quit")
				if not user_quit then
					lio.put_new_line
					results_table.wipe_out
					Precursor
					lio.put_new_line
					distributer.collect_final (recycle_list)
					collect_and_recyle

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

	collect_and_recyle
		do
			across recycle_list as list loop
				list.item.collect (results_table)
				grep_pool.recycle (list.item)
			end
		end

	do_with_file (source_path: FILE_PATH)
		do
			if attached grep_pool.borrowed_item as grep then
				grep.set_options (grep_options)
				grep.set_source_path (source_path)

				distributer.wait_apply (agent grep.execute)
				distributer.collect (recycle_list)
				collect_and_recyle
			end
		end

	matching_line_count: INTEGER
		do
			across results_table as table loop
				Result := Result + table.item.count
			end
		end

	new_grep_command: GREP_COMMAND
		do
			create Result.make
		end

feature {NONE} -- Internal attributes

	grep_options: ZSTRING

	grep_pool: EL_AGENT_FACTORY_POOL [GREP_COMMAND]

	distributer: EL_PROCEDURE_DISTRIBUTER [GREP_COMMAND]

	results_table: EL_HASH_TABLE [EL_ZSTRING_LIST, FILE_PATH]

	recycle_list: ARRAYED_LIST [GREP_COMMAND]

end