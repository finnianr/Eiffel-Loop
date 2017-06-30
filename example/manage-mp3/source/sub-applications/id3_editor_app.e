note
	description: "Summary description for {LIBID3_TEST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:39:23 GMT (Thursday 29th June 2017)"
	revision: "6"

class
	ID3_EDITOR_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [ID3_EDITOR]
		redefine
			Option_name, Ask_user_to_quit
		end

	RHYTHMBOX_CONSTANTS

feature -- Testing

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)
			Test.do_file_tree_test ("build/test", agent test_normal_run, 3648850805)
--			Test.do_file_tree_test ("build", agent test_normal_run, 3648850805)
			-- /media/GT-N5110/Tablet/Samsung/Music
		end

	test_normal_run (a_media_dir: EL_DIR_PATH)
			--
		local
			edits: ID3_EDITS
		do
			create edits
--			create command.make (a_media_dir, agent edits.save_album_picture_id3 (?, ?, "Rafael Canaro"))
--			create command.make (a_media_dir, agent edits.set_version_23)
--			create command.make (a_media_dir, agent edits.normalize_comment)
--			create command.make (a_media_dir, agent edits.print_id3)
--			create command.make (a_media_dir, agent edits.test)

			normal_run

--			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [a_media_dir: EL_DIR_PATH; edition_name: ZSTRING]
		do
			create Result
			Result.a_media_dir := ""
			Result.edition_name := "default"
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("mp3_dir", "Path to root directory of MP3 files",  << directory_must_exist >>),
				required_argument ("task", "Edition task name")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "id3_edit"

	Description: STRING = "Edit ID3 tags from MP3 files"

	Ask_user_to_quit: BOOLEAN = False

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{ID3_EDITOR_APP}, All_routines],
				[{ID3_EDITOR}, All_routines],
--				[{EL_ID3_INFO}, No_routines],
				[{ID3_EDITS}, All_routines]
			>>
		end

end
