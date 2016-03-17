note
	description: "Summary description for {TEST_RHYTHMBOX_MUSIC_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 12:29:31 GMT (Wednesday 16th December 2015)"
	revision: "4"

class
	TEST_MUSIC_MANAGER

inherit
	RHYTHMBOX_MUSIC_MANAGER
		redefine
			make, Database, xml_database_file_path,
			export_dj_events, export_music_to_device, export_playlists_to_device,

			new_device, new_substitution_list, new_menu_option_input,

			-- User input
			ask_user_for_file_path, ask_user_for_task, ask_user_for_dir_path
		end

create
	make

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (a_config: like config)
		once
			log.enter ("test_make")
			Precursor (a_config)

			substitute_work_area_variable (xml_database_file_path)
			substitute_work_area_variable (database_dir_path + "playlists.xml")
			Database.update_index_by_audio_id
			log.exit
		end

feature -- Tasks: Import/Export

	export_dj_events
		do
			Precursor
			across Database.new_exported_playlists (config.dj_events.playlist_dir) as playlist loop
				log.put_labeled_string ("Title", playlist.item.title)
				log.put_new_line
				across playlist.item as song loop
					log.put_path_field ("MP3", song.item.mp3_relative_path)
					log.put_new_line
				end
				log.put_new_line
			end
		end

	export_music_to_device
		local
			title: ZSTRING
		do
			Precursor
			-- Do it again
			if config.selected_genres.is_empty then
				log.put_line ("Hiding Classical songs")

				Database.songs.do_query (not song_is_hidden and song_is_genre ("Classical"))
				Database.songs.last_query_items.do_all (agent {RBOX_SONG}.hide)

				log.put_line ("Changing titles on Rock Songs")
				Database.songs.do_query (not song_is_hidden and song_is_genre ("Rock"))
				across Database.songs.last_query_items as song loop
					title := song.item.title
					title.prepend_character ('X')
					song.item.set_title (title)
					song.item.update_checksum
				end
			else
				log.put_line ("Removing genre: Irish Traditional")
				config.selected_genres.prune ("Irish Traditional")
			end
			Precursor
		end

	export_playlists_to_device
		do
			Precursor
			-- and again
			log.put_line ("Removing first playlist")
				-- Expected behaviour is that it shouldn't delete anything
			Database.playlists.start
			Database.playlists.remove
			Precursor
		end

feature {NONE} -- Factory

	new_device: TEST_STORAGE_DEVICE
		do
			create Result.make (config, Database)
		end

	new_substitution_list: LINKED_LIST [like new_substitution]
		local
			substitution: like new_substitution
		do
			create substitution
			substitution.deleted_path := "workarea/rhythmdb/Music/Recent/Francisco Canaro/Francisco Canaro -- Corazon de Oro.01.mp3"
			substitution.replacement_path := "workarea/rhythmdb/Music/Recent/Francisco Canaro/Francisco Canaro -- Corazòn de Oro.02.mp3"
			create Result.make
			Result.extend (substitution)
		end

	new_menu_option_input (prompt: ZSTRING; menu: EL_ZSTRING_LIST): INTEGER
		do
			Result := 1
		end

feature {NONE} -- User input

	ask_user_for_task
		do
			user_quit := True
		end

	ask_user_for_file_path (name: ZSTRING)
		do
			if config.task.same_string ("replace_cortina_set") then
				file_path := "workarea/rhythmdb/Music/Recent/March 23/09_-_Fabrizio_De_Andrè_Disamistade.mp3"
			else
				create file_path
			end
		end

	ask_user_for_dir_path (name: ZSTRING)
		do
		end

feature {NONE} -- Implementation

	substitute_work_area_variable (xml_file_path: EL_FILE_PATH)
			--
		local
			xml_file: PLAIN_TEXT_FILE
			xml_text: STRING
		do
			xml_text := File_system.plain_text (xml_file_path)
			xml_text.replace_substring_all ("$WORKAREA", xml_file_path.parent.to_string.to_utf_8)

			create xml_file.make_open_write (xml_file_path)
			xml_file.put_string (xml_text)
			xml_file.close
		end

	xml_database_file_path: EL_FILE_PATH
		do
			Result := "workarea/rhythmdb/rhythmdb.xml"
		end

feature {NONE} -- Constants

	Database: RBOX_TEST_DATABASE
		once
			create Result.make (xml_database_file_path, config.dj_events.playlist_dir)
		end
end
