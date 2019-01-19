note
	description: "Test manager config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-18 12:39:12 GMT (Friday 18th January 2019)"
	revision: "6"

class
	TEST_MANAGER_CONFIG

inherit
	MANAGER_CONFIG
		redefine
			building_action_table
		end

create
	make, make_from_file

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

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			Result := Precursor
			Result ["@test_checksum"] := agent do test_checksum := node.to_natural end
			Result ["@music_dir"] := agent do
				music_dir := Directory.current_working.joined_dir_path (node.to_expanded_dir_path)
			end
		end
end
