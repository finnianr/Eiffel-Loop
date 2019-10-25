note
	description: "Id3 test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-25 12:25:25 GMT (Friday   25th   October   2019)"
	revision: "1"

deferred class
	ID3_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Eiffel_loop_dir.joined_dir_tuple (["projects.data/id3$"]), filter)
		end

	filter: STRING
		deferred
		end

end
