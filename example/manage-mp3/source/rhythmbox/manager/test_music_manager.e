note
	description: "Summary description for {TEST_RHYTHMBOX_MUSIC_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_MUSIC_MANAGER

inherit
	RHYTHMBOX_MUSIC_MANAGER
		redefine
			make, xml_database_file_path,
			export_dj_events, export_music_to_device, export_playlists_to_device,

			new_device, new_substitution_list,

			-- User input
			ask_user_for_file_path, ask_user_for_task, ask_user_for_dir_path
		end

create
	make

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (a_config: like config)
		local
			song: RBOX_SONG; l_duration: INTEGER; modification_time: DATE_TIME
		once
			log.enter ("test_make")
			Precursor (a_config)
			create test_wav_generator.make ("")
			create random.make
			create modification_time.make (2011, 11, 11, 11, 11, 11)

			substitute_work_area_variable (xml_database_file_path)
			substitute_work_area_variable (database_dir_path + "playlists.xml")

			if not (database_dir_path + "Music").exists then
				across Database.songs as l_song loop
					song := l_song.item
					if not song.is_hidden then
						l_duration := song.duration
						if l_duration > 10 then
							l_duration := l_duration // 10
						end
						File_system.make_directory (song.mp3_path.parent)
						File_system.copy (cached_song_file_path (song, l_duration), song.mp3_path)
					end
				end
			end
			Database.update_index_by_track_id
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
			title: ASTRING
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

	new_device: TEST_USB_DEVICE
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

feature {NONE} -- User input

	ask_user_for_task
		do
			user_quit := True
		end

	ask_user_for_file_path (name: ASTRING)
		do
			if config.task.same_string ("replace_cortina_set") then
				file_path := "workarea/rhythmdb/Music/Recent/March 23/09_-_Fabrizio_De_Andrè_-_Disamistade.mp3"
			else
				create file_path
			end
		end

	ask_user_for_dir_path (name: ASTRING)
		do
		end

feature {NONE} -- Implementation

	cached_song_file_path (song: RBOX_SONG; a_duration: INTEGER): EL_FILE_PATH
			-- Path to auto generated mp3 file under build directory
		require
			valid_duration: a_duration > 0
		local
			mp3_writer: EL_WAV_TO_MP3_COMMAND; relative_path, wav_path: EL_FILE_PATH; id3_info: EL_ID3_INFO
		do
			relative_path := song.mp3_path.relative_path (Database.mp3_root_location)

			log.put_path_field ("Reading", relative_path)
			log.put_new_line

			Result := Directory.path ("build") + relative_path
			if not Result.exists then
				File_system.make_directory (Result.parent)
				wav_path := Result.with_new_extension ("wav")

				-- Create a unique random wav file
				test_wav_generator.set_output_file_path (wav_path)
				test_wav_generator.set_frequency_lower (100 + (200 * random.real_item).rounded)
				random.forth
				test_wav_generator.set_frequency_upper (600  + (600 * random.real_item).rounded)
				random.forth
				test_wav_generator.set_cycles_per_sec ((1.0 + random.real_item.to_double).truncated_to_real)
				random.forth

				if a_duration > 0 then
					test_wav_generator.set_duration (a_duration * 1000)
				end
				test_wav_generator.execute

				create mp3_writer.make (wav_path, Result)
				mp3_writer.set_bit_rate_per_channel (48)
				mp3_writer.set_num_channels (1)
				mp3_writer.execute
				File_system.remove_file (wav_path)

				create id3_info.make (wav_path.with_new_extension ("mp3"))
				song.write_id3_info (id3_info)

			end
		ensure
			file_exists: Result.exists
		end

	substitute_work_area_variable (xml_file_path: EL_FILE_PATH)
			--
		local
			xml_file: PLAIN_TEXT_FILE
			xml_text: STRING
		do
			xml_text := File_system.plain_text (xml_file_path)
			xml_text.replace_substring_all ("$WORKAREA", xml_file_path.parent.to_string)

			create xml_file.make_open_write (xml_file_path)
			xml_file.put_string (xml_text)
			xml_file.close
		end

	xml_database_file_path: EL_FILE_PATH
		do
			Result := "workarea/rhythmdb/rhythmdb.xml"
		end

	random: RANDOM

	test_wav_generator: EL_WAV_GENERATION_COMMAND

end
