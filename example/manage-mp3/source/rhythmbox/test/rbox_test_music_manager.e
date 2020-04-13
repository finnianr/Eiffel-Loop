note
	description: "Test music manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-13 10:19:44 GMT (Monday 13th April 2020)"
	revision: "17"

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

	RBOX_SHARED_DATABASE_FIELD_ENUM

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
			root_node: EL_XPATH_ROOT_NODE_CONTEXT; name: STRING
			character_count: INTEGER_REF
		do
			log.enter ("print_rhythmdb_xml")
			create character_count
			create root_node.make_from_file (Database.xml_database_path)
			across root_node.context_list ("/rhythmdb/entry") as entry loop
				log.put_line (Url.decoded_path (entry.node.string_8_at_xpath (Tag.location)))
				log.put_labeled_string (entry.node.attributes [Attribute_type], entry.node.string_at_xpath (Tag.media_type))
				print_field (Tag.mb_trackid, entry.node, 1)
				log.put_new_line
				across Db_field.type_group_table as group loop
					character_count.set_item (0)
					across group.item as field loop
						name := Db_field.name_exported (field.item, False)
						if not tag_names.has (name) and then entry.node.has (name) then
							print_field (name, entry.node, character_count)
						end
					end
					if character_count > 0 then
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

	print_field (name: STRING; entry_node: EL_XPATH_NODE_CONTEXT; character_count: INTEGER_REF)
		local
			text: ZSTRING
		do
			text := entry_node.string_at_xpath (name)
			if not text.is_empty then
				if character_count.item + name.count + text.count + 4 > 100 then
					character_count.set_item (0)
					log.put_new_line
				end
				if character_count > 0 then
					log.put_string (once "; ")
					character_count.set_item (character_count.item + 2)
				end
				log.put_labeled_string (name, text)
				character_count.set_item (character_count.item + name.count + text.count + 2)
			end
		end

feature {NONE} -- Constants

	Attribute_type: STRING = "type"

	Tag_names: EL_STRING_8_LIST
		once
			create Result.make_from_tuple (Tag)
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
