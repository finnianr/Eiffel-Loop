note
	description: "Replace cortina set test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "7"

class
	REPLACE_CORTINA_SET_TEST_TASK

inherit
	REPLACE_CORTINA_SET_TASK
		redefine
			user_input_file_path
		end

create
	make

feature {NONE} -- Implementation

	user_input_file_path (name: ZSTRING): FILE_PATH
		do
			Database.songs.find_first_true (agent song_has_title_substring (?, "Disamistade"))
			if Database.songs.found then
				Result := Database.songs.item.mp3_path
			else
				create Result
			end
		end

end
