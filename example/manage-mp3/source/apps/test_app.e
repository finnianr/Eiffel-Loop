note
	description: "Test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-31 12:43:23 GMT (Saturday 31st August 2019)"
	revision: "1"

class
	TEST_APP

inherit
	EL_SUB_APPLICATION

create
	make

feature {NONE} -- Initiliazation

	initialize
		do

		end

feature -- Basic operations

	run
		do
			lio.enter ("test_config")
--			test_config ("add_album_art.pyx")
			test_config ("export_music_to_device Genres.pyx")
--			test_config ("export_playlists_to_device.pyx")
--			test_config ("publish_dj_events.pyx")
--			test_config ("replace_cortina_set.pyx")
--			test_config ("update_dj_playlists.pyx")

			lio.exit
		end


feature -- Tests

	test_config (name: STRING)
		local
			task: TEST_TASK_CONFIG
		do
			create task.make (Rhythmdb_tasks_dir + name)
		end

feature {NONE} -- Constants

	Description: STRING = "Perform development tests"

	Rhythmdb_tasks_dir: EL_DIR_PATH
		once
			Result := "test-data/rhythmdb-tasks/new"
		end

end
