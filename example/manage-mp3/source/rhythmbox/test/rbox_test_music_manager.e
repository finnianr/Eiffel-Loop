note
	description: "Test music manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-31 14:25:10 GMT (Tuesday 31st March 2020)"
	revision: "16"

class
	RBOX_TEST_MUSIC_MANAGER

inherit
	RBOX_MUSIC_MANAGER
		redefine
			make, Database, xml_data_dir, execute,
			Task_factory, ask_user_for_task
		end

	EL_MODULE_NAMING

	EL_MODULE_TUPLE

	EL_MODULE_URL

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_task_path: EL_FILE_PATH)
		do
			log.enter ("test_make")
			Precursor (a_task_path)
			task.set_absolute_music_dir
			log.exit
		end

feature -- Basic operations

	execute
		do
			Precursor
			if attached {DATABASE_UPDATE_TASK} task then
				print_rhythmdb_xml
				print_playlist_xml
			end
		end

feature {NONE} -- User input

	ask_user_for_task
		do
			user_quit := True
		end

feature {NONE} -- Implementation

	xml_data_dir: EL_DIR_PATH
		do
			Result := task.music_dir.parent
		end

	print_rhythmdb_xml
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
			first: BOOLEAN_REF
		do
			log.enter ("print_rhythmdb_xml")
			create first
			create root_node.make_from_file (Database.xml_database_path)
			across root_node.context_list ("/rhythmdb/entry") as entry loop
				log.put_line (Url.decoded_path (entry.node.string_8_at_xpath (Tag.location)))
				log.put_labeled_string (entry.node.attributes [Attribute_type], entry.node.string_at_xpath (Tag.media_type))
				print_field (Tag.mb_trackid, entry.node, False)
				log.put_new_line
				across Tag_groups as group loop
					first.set_item (True)
					across group.item as field loop
						print_field (field.item, entry.node, first)
					end
					if not first then
						log.put_new_line
					end
				end
				log.put_new_line
			end
			log.exit
		end

	print_playlist_xml
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			log.enter ("print_playlist_xml")
			create root_node.make_from_file (Database.playlists_xml_path)
			across root_node.context_list ("/rhythmdb-playlists/playlist") as playlist loop
				across << Tag.name, Tag.type >> as name loop
					if name.cursor_index > 1 then
						log.put_string ("; ")
					end
					log.put_labeled_string (name.item, playlist.node.attributes [name.item])
				end
				log.put_new_line
				across playlist.node.context_list (Tag.location) as location loop
					log.put_line (Url.decoded_path (location.node.string_8_value))
				end
				log.put_new_line
			end
			log.exit
		end

	print_field (name: STRING; entry_node: EL_XPATH_NODE_CONTEXT; first: BOOLEAN_REF)
		local
			text: ZSTRING
		do
			text := entry_node.string_at_xpath (name)
			if not text.is_empty then
				if first.item then
					first.set_item (False)
				else
					log.put_string (once "; ")
				end
				log.put_labeled_string (name, text)
			end
		end

feature {NONE} -- Constants

	Attribute_type: STRING = "type"

	Tag_groups: ARRAY [EL_STRING_8_LIST]
		once
			Result := <<
				"genre, title",
				"album",
				"artist, album-artist, composer",
				"bitrate, date, duration, file-size, track-number",
				"first-seen, last-seen, last-played"
			>>
		end

	Tag: TUPLE [location, media_type, mb_trackid, name, type: STRING]
		once
			create Result
			Tuple.fill (Result, "location, media-type, mb-trackid, name, type")
		end

	Database: RBOX_TEST_DATABASE
		once
			create Result.make (xml_file_path ("rhythmdb"), task.music_dir)
			Result.update_index_by_audio_id
		end

	Testing_tasks: TUPLE [
		ADD_ALBUM_ART_TEST_TASK,

		EXPORT_MUSIC_TO_DEVICE_TEST_TASK,
		EXPORT_PLAYLISTS_TO_DEVICE_TEST_TASK,

		IMPORT_NEW_MP3_TEST_TASK,
		IMPORT_VIDEOS_TEST_TASK,

		UPDATE_DJ_PLAYLISTS_TEST_TASK,
		REPLACE_SONGS_TEST_TASK,
		REPLACE_CORTINA_SET_TEST_TASK
	]
		once
			create Result
		end

	Task_factory: EL_BUILDER_OBJECT_FACTORY [RBOX_MANAGEMENT_TASK]
		once
			Result := Precursor
			-- ignore suffix: `_TEST_TASK'
			Result.set_type_alias (agent Naming.class_as_lower_snake (?, 0, 2))
			Result.append (Testing_tasks)
		end

end
