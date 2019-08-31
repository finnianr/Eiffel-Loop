note
	description: "Test task config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-31 12:35:57 GMT (Saturday 31st August 2019)"
	revision: "1"

class
	TEST_TASK_CONFIG

inherit
	TASK_CONFIG
		redefine
			Root_node_name, on_context_exit
		end

	EL_MODULE_DIRECTORY

create
	make, make_default

feature -- Access

	test_checksum: NATURAL

feature -- Factory

	new_music_manager: TEST_MUSIC_MANAGER
		do
			if task ~ Task_import_videos then
				create {TEST_VIDEO_IMPORT_MUSIC_MANAGER} Result.make (Current)
			else
				create Result.make (Current)
			end
		end

feature {NONE} -- Implementation

	on_context_exit
		do
			music_dir := Directory.current_working.joined_dir_path (music_dir)
		end

feature {NONE} -- Constants

	Root_node_name: STRING = "task_config"

end
