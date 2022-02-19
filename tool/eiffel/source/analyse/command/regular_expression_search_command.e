note
	description: "Shell to search for regular expressions in source manifest files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 9:11:53 GMT (Saturday 19th February 2022)"
	revision: "6"

class
	REGULAR_EXPRESSION_SEARCH_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		rename
			make as make_command,
			do_with_file as do_nothing_with
		redefine
			execute, make_default
		end

	EL_MODULE_FILE_SYSTEM; EL_MODULE_DIRECTORY; EL_MODULE_USER_INPUT

	EL_ENCODING_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (manifest_path_or_directory, output_path: FILE_PATH)
		do
			make_command (manifest_path_or_directory)
			if not output_path.is_empty then
				create output_file.make_with_path (output_path)
			end
		end

	make_default
		do
			Precursor
			create results_list.make (0)
			create grep_command.make
			create source_dir
			create source_class.make_empty
			output_file := Default_output_file
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
					grep_command.set_options (grep_options)
					results_list.wipe_out

					search_sources

					lio.put_new_line
					count := results_list.count
					if has_error then
						lio.put_new_line
						across grep_command.errors as line loop
							lio.put_line (line.item)
						end

					elseif count = 0 then
						lio.put_line ("No matches found")
					else
						if output_file = Default_output_file then
							results_list.do_all (agent write_result (?, Void))
							lio.put_integer_field ("Matches found", count)
						else
							lio.put_path_field (Count_template #$ [count], output_file.path)
							output_file.open_write
							results_list.do_all (agent write_result (?, output_file))
							output_file.close
						end
							lio.put_new_line
					end
				end
			end
		end

feature {NONE} -- Implementation

	do_nothing_with (source_path: FILE_PATH)
		-- Unused
		do
		end

	iterate_source_trees
		do
			across manifest.source_tree_list as list until has_error loop
				grep_command.set_source_dir (list.item.dir_path)
				grep_command.execute
				if grep_command.has_error then
					has_error := True
				else
					results_list.append (grep_command.lines)
					Track.progress_listener.notify_tick
				end
			end
		end

	search_sources
		do
			has_error := False
			source_dir.wipe_out; source_class.wipe_out

			lio.put_labeled_substitution ("Searching", "%S directories", [manifest.source_tree_list.count])
			lio.put_new_line
			Track.progress (Console_display, manifest.source_tree_list.count, agent iterate_source_trees)

			if output_file /= Default_output_file then
				lio.put_new_line
			end
		end

	write_result (line: ZSTRING; output: detachable EL_PLAIN_TEXT_FILE)
		local
			source_path: FILE_PATH; dir_line: detachable ZSTRING; index_colon: INTEGER
			s: EL_ZSTRING_ROUTINES
		do
			index_colon := line.index_of (':', 1)

			if index_colon > 0 then
				source_path := line.substring (1, index_colon - 1)
				line.remove_head (index_colon)
			end
			line.left_adjust
			line.prepend (s.n_character_string (' ', 3))

			if source_path.parent /~ source_dir then
				source_dir := source_path.parent
				dir_line := Comment_line + source_dir
				if attached output as file then
					file.put_new_line
					file.put_line (dir_line)
				else
					lio.put_new_line
					lio.put_line (dir_line)
				end
			end
			if not source_path.base_matches (source_class, True) then
				source_class := source_path.base_sans_extension.as_upper
				if attached output as file then
					file.put_line (Class_line + source_class)
				else
					lio.put_line (Class_line + source_class)
				end
			end
			if attached output as file then
				file.put_line (line)
			else
				lio.put_line (line)
			end
		end

feature {NONE} -- Internal attributes

	grep_command: EIFFEL_GREP_COMMAND

	output_file: EL_PLAIN_TEXT_FILE

	results_list: EL_ZSTRING_LIST

	source_dir: DIR_PATH

	source_class: ZSTRING

	has_error: BOOLEAN

feature {NONE} -- Constants

	Comment_line: ZSTRING
		once
			Result := "-- "
		end

	Count_template: ZSTRING
		once
			Result := "Writing %S results to"
		end

	Class_line: ZSTRING
		once
			Result := "class "
		end

	Default_output_file: EL_PLAIN_TEXT_FILE
		once
			create Result.make_with_name ("none.txt")
		end

end