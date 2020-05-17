note
	description: "Generic test set for tests conforming to [$source RBOX_MANAGEMENT_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-17 9:54:11 GMT (Sunday 17th May 2020)"
	revision: "5"

deferred class
	RBOX_MANAGEMENT_TASK_TEST_SET [T -> RBOX_MANAGEMENT_TASK create make end]

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		redefine
			on_prepare
		end

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_clean
		redefine
			on_prepare
		end

	SONG_QUERY_CONDITIONS undefine default_create, is_equal end

	RBOX_SHARED_DATABASE_FIELD_ENUM

	EL_MODULE_TUPLE

	EL_MODULE_URL

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("apply", agent test_apply)
		end

feature -- Tests

	test_apply
		do
			do_test ("apply", checksum, agent do_task)
		end

feature {NONE} -- Events

	on_prepare

		do
			Precursor {EL_COPIED_DIRECTORY_DATA_TEST_SET}

			task := new_task (task_config)

			if shared_database.is_created then
				database := shared_database.item
				-- remake the database
				database.make (rhythmdb_path, task.music_dir)
			else
				create database.make (rhythmdb_path, task.music_dir)
			end
			database.update_index_by_audio_id
		end

feature {NONE} -- Implementation

	do_task
		do
			task.apply
			if attached {DATABASE_UPDATE_TASK} task then
				print_rhythmdb_xml
				print_playlist_xml
			end
		end

	new_task (pyxis_code: STRING): like task
		do
			File_system.write_plain_text (Task_file_path, Pyxis_doc + pyxis_code)
			create Result.make (Task_file_path)
			Result.set_absolute_music_dir
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

	rhythmdb_path: EL_FILE_PATH
		do
			Result := task.music_dir.parent + "rhythmdb.xml"
		end

	shared_database: EL_SINGLETON [RBOX_TEST_DATABASE]
		do
			create Result
		end

feature {NONE} -- Deferred implementation

	checksum: NATURAL
		deferred
		end

	task_config: STRING
		deferred
		end

feature {NONE} -- Internal attributes

	database: RBOX_TEST_DATABASE

	task: T

feature {NONE} -- Constants

	Attribute_type: STRING = "type"

	Playlists_dir: EL_DIR_PATH
		once
			Result := work_area_data_dir.joined_dir_path ("Music/Playlists")
		end

	Pyxis_doc: STRING
		once
			Result := "[
				pyxis-doc:
				version = 1.0; encoding = "ISO-8859-1"
			]"
			Result.append ("%N%N")
		end

	Source_dir: EL_DIR_PATH
		once
			Result := "test-data/rhythmdb"
		end

	Tag: TUPLE [location, media_type, mb_trackid, name, type: STRING]
		once
			create Result
			Tuple.fill (Result, "location, media-type, mb-trackid, name, type")
		end

	Tag_names: EL_STRING_8_LIST
		once
			create Result.make_from_tuple (Tag)
		end

	Task_file_path: EL_FILE_PATH
		once
			Result := Work_area_dir + "test-task.pyx"
		end

end
