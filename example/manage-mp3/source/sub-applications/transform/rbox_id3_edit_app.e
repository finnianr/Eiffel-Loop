note
	description: "[
		ID3 tags title, artist, genre and album will be overwritten with information entered
		in Rhythmbox library database using UTF-8 encoding.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-17 22:26:38 GMT (Monday 17th June 2013)"
	revision: "3"

class
	RBOX_ID3_EDIT_APP

inherit
	RBOX_DATABASE_TRANSFORM_APP
		redefine
			Option_name, normal_initialize
		end

create
	make

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			Precursor
			create action_name.make_empty
		end

feature -- Basic operations

	transform_database
		local
			done: BOOLEAN
			menu: like database.actions.current_keys
			l_actions: like database.actions
			option: INTEGER
		do
			l_actions := database.actions; menu := l_actions.current_keys
			from until done loop
				if Is_test_mode then
					l_actions.item (action_name).apply
					done := True
				else
					log_or_io.put_line ("* MENU *")
					log_or_io.put_labeled_string ("0", "Quit")
					log_or_io.put_new_line
					across menu as menu_option loop
						log_or_io.put_labeled_string (menu_option.cursor_index.out, menu_option.item)
						log_or_io.put_new_line
					end
					log_or_io.put_new_line

					option := User_input.integer ("Enter option number")
					if option = 0 then
						 done := True

					elseif menu.valid_index (option) then
						action_name := menu [option]
						l_actions.item (action_name).apply
					else
						log_or_io.put_integer_field ("Invalid option", option)
					end
				end
				log_or_io.put_new_line
			end
		end

feature -- Move to RBOX_DATABASE (To do)

	write_id3_tags (song: RBOX_SONG)
			--
		local
			id3_info: EL_ID3_INFO
		do
			create id3_info.make (song.mp3_path)
			song.write_id3_info (id3_info)
		end

feature -- Testing operations

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)
--			Test.do_file_tree_test ("rhythmdb", agent test_normal_run (?, "delete_comments"), 483348154)

			Test.do_file_tree_test ("rhythmdb", agent test_normal_run (?, "update_comments_with_album_artists"), 483348154)

			Test.print_checksum_list
		end

	test_normal_run (data_path: EL_DIR_PATH; a_action_name: EL_ASTRING)
		do
			log.enter ("test_normal_run")
			normal_initialize
			test_database_dir := data_path
			action_name := a_action_name
			normal_run
			log.exit
		end

feature {NONE} -- Implementation

	action_name: EL_ASTRING

feature {NONE} -- Constants

	Warning_prompt: STRING = "[
		This application will edit the RhythmBox configuration database and playlists,
		update all mp3 tags to match Rhythmbox edits.
		If word option: -autoedit is specified on command line, it will delete certain tags
		and add a unique id tag. These changes are not reversible.
	]"

	Option_name: STRING = "edit_id3"

	Description: STRING = "Edit tag information in Rhythmbox database into mp3 ID3 tags"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RBOX_ID3_EDIT_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{RBOX_SONG}, "*"],
				[{RBOX_DATABASE}, "*"],
				[{EL_LIBID3_FRAME}, "-*"],
				[{EL_ID3_INFO}, "-set_frames"]
			>>
		end

end
