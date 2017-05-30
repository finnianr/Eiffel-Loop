note
	description: "Summary description for {PATH_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-28 6:44:55 GMT (Sunday 28th May 2017)"
	revision: "2"

class
	EL_PATH_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET

	EL_MODULE_COMMAND
		undefine
			default_create
		end

	EL_MODULE_DIRECTORY
		undefine
			default_create
		end

feature -- Tests

	test_relative_path
		local
			find: like Command.new_find_files
			path_1, path_2: EL_FILE_PATH
			relative_steps: EL_PATH_STEPS
		do
			find := Command.new_find_files (Eiffel_dir, "*.e")
			find.execute
			across find.path_list.twin as p1 loop
				path_1 := p1.item.relative_path (Eiffel_dir)
				log.put_path_field ("class", path_1)
				log.put_new_line
				across find.path_list as p2 loop
					path_2 := p2.item.relative_path (Eiffel_dir)
					relative_steps := path_2.relative_steps (path_1.parent)

					Execution_environment.push_current_working (p1.item.parent)
					assert ("Path exists", relative_steps.as_file_path.exists)
					Execution_environment.pop_current_working
				end
			end
		end

	test_parent_of
		local
			dir_home, dir: EL_DIR_PATH; dir_string, dir_string_home: ZSTRING
			is_parent: BOOLEAN
		do
			create dir_string.make_empty
			dir_string_home := "/home/finnian"
			dir_home := dir_string_home
			across Path_string.split ('/') as step loop
				if step.cursor_index > 1 then
					dir_string.append_character ('/')
				end
				dir_string.append (step.item)
				dir := dir_string
				is_parent := dir_string.starts_with (dir_string_home) and dir_string.count > dir_string_home.count
				assert ("same result", is_parent ~ dir_home.is_parent_of (dir))
			end
		end

feature {NONE} -- Constants

	Path_string: ZSTRING
		once
			Result := "/home/finnian/Documents/Eiffel"
		end

	Eiffel_dir: EL_DIR_PATH
		once
			Result := "Eiffel"
		end

end
