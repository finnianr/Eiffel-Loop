note
	description: "Summary description for {TEST_MANAGER_CONFIG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-22 7:56:23 GMT (Monday 22nd May 2017)"
	revision: "2"

class
	TEST_MANAGER_CONFIG

inherit
	MANAGER_CONFIG
		redefine
			building_action_table
		end

create
	make_from_file

feature -- Access

	test_checksum: NATURAL

feature -- Factory

	new_music_manager: TEST_MUSIC_MANAGER
		do
			if task ~ Task_import_videos then
				create {TEST_VIDEO_IMPORT_MUSIC_MANAGER} Result.make (Current)
			else
				create Result.make (Current)
			end
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE
		do
			Result := Precursor
			Result ["@test_checksum"] := agent do test_checksum := node.to_natural end
			Result ["@music_dir"] := agent do
				music_dir := Directory.current_working.joined_dir_path (node.to_expanded_dir_path)
			end
		end
end
