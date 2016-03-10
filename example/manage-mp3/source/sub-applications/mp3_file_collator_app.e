note
	description: "Summary description for {MP3_FILE_COLLATOR_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-17 19:45:06 GMT (Saturday 17th January 2015)"
	revision: "6"

class
	MP3_FILE_COLLATOR_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [MP3_FILE_COLLATOR]
		redefine
			Option_name
		end

feature -- Testing

	test_run
			--
		do
			Test.do_file_tree_test ("rhythmdb", agent test_normal_run, 3335730455) -- Jan 2015
		end

	test_normal_run (a_dir_path: EL_DIR_PATH)
			--
		local
			manager: TEST_MUSIC_MANAGER
		do
			create manager.make (create {MANAGER_CONFIG}.make)
			create command.make ("workarea/rhythmdb/Music", True)
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [dir_path: EL_DIR_PATH; is_dry_run: BOOLEAN]
		do
			create Result
			Result.dir_path := ""
			Result.is_dry_run := False
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("directory", "MP3 location"),
				optional_argument ("dry_run", "Show output without moving any files")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "mp3_collate"

	Description: STRING = "[
		Collates mp3 files using the path form: <genre>/<artist>/<title>.<id>.mp3

	]"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EL_TEST_ROUTINES}, "*"],
				[{MP3_FILE_COLLATOR_APP}, "*"],
				[{MP3_FILE_COLLATOR}, "*"]
			>>
		end

end
