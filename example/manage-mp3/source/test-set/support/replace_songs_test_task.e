note
	description: "Replace songs test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-16 10:56:33 GMT (Thursday 16th April 2020)"
	revision: "3"

class
	REPLACE_SONGS_TEST_TASK

inherit
	REPLACE_SONGS_TASK
		undefine
			root_node_name
		redefine
			new_substitution_list
		end

	TEST_MANAGEMENT_TASK

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
