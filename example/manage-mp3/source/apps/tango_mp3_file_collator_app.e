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
	date: "2019-09-18 14:58:07 GMT (Wednesday   18th   September   2019)"
	revision: "11"

class
	TANGO_MP3_FILE_COLLATOR_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [TANGO_MP3_FILE_COLLATOR]
		redefine
			Option_name
		end

	RHYTHMBOX_CONSTANTS

feature -- Testing

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)
			Test.do_file_tree_test ("rhythmdb", agent test_normal_run, 2437132812) -- Sept 2019
		end

	test_normal_run (a_dir_path: EL_DIR_PATH)
			--
		local
			db: RBOX_TEST_DATABASE; music_dir: EL_DIR_PATH
		do
			music_dir := a_dir_path.joined_dir_path ("Music")
			create db.make (a_dir_path + "rhythmdb.xml", music_dir)
			create command.make (music_dir, True)
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("directory", "MP3 location", << directory_must_exist >>),
				optional_argument ("dry_run", "Show output without moving any files")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", False)
		end

feature {NONE} -- Constants

	Option_name: STRING = "mp3_collate"

	Description: STRING = "[
		Collates mp3 files using the path form: <genre>/<artist>/<title>.<id>.mp3
	]"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{TANGO_MP3_FILE_COLLATOR_APP}, All_routines],
				[{TANGO_MP3_FILE_COLLATOR}, All_routines]
			>>
		end

end
