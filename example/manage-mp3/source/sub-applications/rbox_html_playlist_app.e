note
	description: "Summary description for {RBOX_HTML_PLAYLIST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-17 22:25:39 GMT (Monday 17th June 2013)"
	revision: "3"

class
	RBOX_HTML_PLAYLIST_APP

inherit
	RBOX_APPLICATION
		redefine
			Option_name, Ask_user_to_quit, normal_initialize
		end

	EL_WEBSITE_ROUTINES

	EL_MODULE_USER_INPUT

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
			--
		local
			l_file_path: STRING
		do
			Precursor
			l_file_path := "music-venue-events.xml"
			set_attribute_from_command_opt (l_file_path, "events", "Path to music venue events in Pyxis format")
			set_music_venue_events_file_path (l_file_path)
			create html_file_and_destination_paths.make
			create_database
		end

feature -- Basic operations

	normal_run
			--
		local
			index_html_path: EL_FILE_PATH
		do
			create music_venue_events.make (music_venue_events_file_path)
			index_html_path := music_venue_events.file_path.parent + "index.html"
			music_venue_events.write_web_page (index_html_path)
			html_file_and_destination_paths.extend ([index_html_path, music_venue_events.ftp_destination_path])
			music_venue_events.event_list.do_all (agent publish_event (?, music_venue_events.playlist_template_path))

			if not is_test_mode then
				log_or_io.put_string ("Upload pages (y/n) ")
				if user_input.entered_letter ('y') then
					set_ftp_site (music_venue_events.ftp_site_node)
					do_ftp_upload (html_file_and_destination_paths)
				end
			end
		end

	transform_song (song: RBOX_SONG)
		do
		end

feature -- Test operations

	test_run
			--
		do
			Test.set_binary_file_extensions (<< "mp3" >>)
			Test.do_file_tree_test ("publish-playlists", agent test_normal_run, 372331818)

			Test.print_checksum_list
		end

	test_normal_run (data_path: EL_DIR_PATH)
			--
		do
			log.enter ("test_normal_run")
			test_database_dir := data_path
			normal_initialize

			set_music_venue_events_file_path (data_path + "music-venue-events.pyx")
			create html_file_and_destination_paths.make
			normal_run
			log.exit
		end

feature -- Element change

	set_music_venue_events_file_path (a_music_venue_events_file_path: EL_ASTRING)
			--
		do
			music_venue_events_file_path := a_music_venue_events_file_path
			if not music_venue_events_file_path.is_absolute then
				music_venue_events_file_path := Directory.Working + music_venue_events_file_path
			end
		end

feature {NONE} -- Implementation

	publish_event (event: MUSIC_EVENT; template_path: EL_FILE_PATH)
			--
		local
			html_path: EL_FILE_PATH
			combined_playlist_web_page: COMBINED_PLAYLIST_WEB_PAGE
		do
			create combined_playlist_web_page.make (event, template_path)
			across event.playlist_names as playlist_name loop
				database.playlists.search_by_name (playlist_name.item)
				if not database.playlists.after then
					combined_playlist_web_page.extend_genre_set_list (database.playlists.item)
				end
			end

			html_path := music_venue_events_file_path.parent + event.html_file_name
			if not html_path.exists then
				combined_playlist_web_page.serialize_to_file (html_path)
				html_file_and_destination_paths.extend ([html_path, music_venue_events.ftp_destination_path])
			end
		end

	is_playlist_selected (playlist: RBOX_PLAYLIST; playlist_names: LIST [STRING]): BOOLEAN
			--
		do
			Result := playlist_names.has (playlist.name)
		end

feature {NONE} -- Implementation: attributes

	music_venue_events: MUSIC_VENUE_EVENTS

	music_venue_events_file_path: EL_FILE_PATH

	html_file_and_destination_paths: LINKED_LIST [like ftp.Type_source_destination]

feature {NONE} -- Constants

	Option_name: STRING = "web_publish"

	Description: STRING = "Create html playlist from Rhythmbox playlists"

	Ask_user_to_quit: BOOLEAN = True

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RBOX_HTML_PLAYLIST_APP}, "*"],
				[{EL_FTP_PROTOCOL}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{EL_VTD_EXCEPTIONS}, "*"],
				[{COMBINED_PLAYLIST_WEB_PAGE}, "*"]
			>>
		end

end
