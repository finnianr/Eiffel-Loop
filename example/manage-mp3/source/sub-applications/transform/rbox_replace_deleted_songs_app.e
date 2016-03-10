note
	description: "Summary description for {RBOX_FIND_PLAYLIST_ALTERNATIVES_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-17 22:27:56 GMT (Monday 17th June 2013)"
	revision: "2"

class
	RBOX_REPLACE_DELETED_SONGS_APP

inherit
	RBOX_DATABASE_TRANSFORM_APP
		rename
			transform_database as delete_and_replace
		redefine
			Option_name, normal_initialize, Ask_user_to_quit, normal_run
		end

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	normal_initialize
			--
		local
			done: BOOLEAN
		do
			Precursor
			create substitution_list.make
			if not Is_test_mode then
				from until done loop
					substitution_list.extend ([User_input.file_path ("DELETE"), User_input.file_path ("SUBSTITUTE")])
					log_or_io.put_new_line
					log_or_io.put_labeled_string ("And another? (y/n)", "")
					done := not User_input.entered_letter ('y')
				end
			end
		end

feature -- Basic operations

	normal_run
		do
			if not substitution_list.is_empty then
				Precursor
			end
		end

	delete_and_replace
			--
		do
			across substitution_list as sub loop
				log_or_io.put_string_field ("DELETE", database.title_and_album (sub.item.deleted_path))
				log_or_io.put_new_line
				log_or_io.put_string_field ("SUBSTITUTE", database.title_and_album (sub.item.substitute_path))
				log_or_io.put_new_line
				log_or_io.put_new_line
			end
			log_or_io.put_string ("Carry out substitutions? (y/n) ")
			if Is_test_mode or else User_input.entered_letter ('y') then
				across substitution_list as l_substitution loop
					database.delete_and_replace (l_substitution.item.deleted_path, l_substitution.item.substitute_path)
				end
				if not substitution_list.is_empty then
					database.store
				end
			end
		end

feature -- Testing operations

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)

			Test.do_file_tree_test ("rhythmdb", agent test_normal_run, 4148782731)

			Test.print_checksum_list
		end

	test_normal_run (data_path: EL_DIR_PATH)
			--
		do
			log.enter ("test_normal_run")
			normal_initialize
			test_database_dir := data_path
			substitution_list.extend (
				substitution (
					"workarea/rhythmdb/Music/Recent/Feb 17/Enrique Rodriguez & His Orchestra - Con tu Mirar.mp3",
					"workarea/rhythmdb/Music/Vals/Rafael Rossi/Rosas de Otoño.01.mp3"
				)
			)
			normal_run
			log.exit
		end

feature {NONE} -- Implementation

	substitution_list: LINKED_LIST [like substitution]

	substitution (deleted_path, substitute_path: EL_ASTRING): TUPLE [deleted_path, substitute_path: EL_FILE_PATH]
		do
			create Result
			Result.deleted_path := deleted_path
			Result.substitute_path := substitute_path
		end

feature {NONE} -- Constants

	Warning_prompt: STRING = "[
		This application will edit the RhythmBox configuration database and playlists
	]"

	Option_name: STRING = "delete_and_replace"

	Description: STRING = "Delete songs and replace with selected alternatives in playlists"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RBOX_REPLACE_DELETED_SONGS_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{RBOX_SONG}, "*"]
			>>
		end

	Ask_user_to_quit: BOOLEAN = True

end
