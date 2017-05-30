note
	description: "[
		Application to collate a Tango MP3 collection into a directory structure using any
		available ID3 tag information and renaming the file according to the title and a numeric
		id to distinguish duplicates.
		
			<genre>/<artist>/<title>.<id>.mp3
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-29 23:22:07 GMT (Monday 29th May 2017)"
	revision: "3"

class
	TANGO_MP3_FILE_COLLATOR_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [TANGO_MP3_FILE_COLLATOR]
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

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [dir_path: EL_DIR_PATH; is_dry_run: BOOLEAN]
		do
			create Result
			Result.dir_path := ""
			Result.is_dry_run := False
		end

	argument_specs: ARRAY [like specs.item]
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
				[{TANGO_MP3_FILE_COLLATOR_APP}, All_routines],
				[{TANGO_MP3_FILE_COLLATOR}, All_routines]
			>>
		end

end
