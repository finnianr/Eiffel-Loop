note
	description: "Summary description for {RBOX_RESTORE_PLAYLISTS_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:39:13 GMT (Thursday 29th June 2017)"
	revision: "3"

class RBOX_RESTORE_PLAYLISTS_APP obsolete "Rewrite using music manager task"

inherit
	RBOX_DATABASE_TRANSFORM_APP
		rename
			transform_database as restore_playlists
		redefine
			Option_name, normal_initialize, Ask_user_to_quit, backup_playlists
		end

create
	make

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			Precursor
		end

feature -- Basic operations

	restore_playlists
			--
		do
			log.enter ("restore_playlists")
			database.restore_playlists
			log.exit
		end

feature -- Testing operations

	test_run
			--
		do
			Test.set_binary_file_extensions (<< "mp3" >>)
			Test.do_file_tree_test ("rhythmdb", agent test_normal_run, 2134672873)

			Test.print_checksum_list
		end

	test_normal_run (data_path: EL_DIR_PATH)
		do
			log.enter ("test_normal_run")
			normal_initialize
			test_database_dir := data_path
			normal_run
			log.exit
		end

feature {NONE} -- Implementation

	backup_playlists
		do
		end

feature {NONE} -- Constants

	Option_name: STRING = "restore_playlists"

	Description: STRING = "Restores playslist from /home/<user>/.local/share/rhythmbox/playlists.backup.xml"

	Warning_prompt: STRING = "[
		This application will rewrite the playlists using audio ids stored in playlists.backup.xml
	]"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{RBOX_RESTORE_PLAYLISTS_APP}, All_routines],
				[{RBOX_SONG}, All_routines],
				[{RBOX_DATABASE}, All_routines],
				[{RBOX_PLAYLIST}, "set_name_from_node", "add_song_from_audio_id"]
			>>
		end

	Ask_user_to_quit: BOOLEAN = True

end
