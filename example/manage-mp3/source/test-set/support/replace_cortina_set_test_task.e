note
	description: "Replace cortina set test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "8"

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