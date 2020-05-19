note
	description: "Replace songs test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-19 17:41:50 GMT (Tuesday 19th May 2020)"
	revision: "4"

class
	REPLACE_SONGS_TEST_TASK

inherit
	REPLACE_SONGS_TASK
		redefine
			new_substitution_list
		end

create
	make

feature {NONE} -- Factory

	new_substitution_list: LINKED_LIST [like new_substitution]
		local
			substitution: like new_substitution
		do
			create substitution
			substitution.deleted_path := music_dir + "Recent/Francisco Canaro/Francisco Canaro -- Corazon de Oro.01.mp3"
			substitution.replacement_path := music_dir + "Recent/Francisco Canaro/Francisco Canaro -- Corazòn de Oro.02.mp3"
			create Result.make
			Result.extend (substitution)
		end

end
