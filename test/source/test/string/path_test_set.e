note
	description: "Summary description for {PATH_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-04 14:14:21 GMT (Monday 4th July 2016)"
	revision: "7"

class
	PATH_TEST_SET

inherit
	EQA_TEST_SET

feature -- Tests

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
end