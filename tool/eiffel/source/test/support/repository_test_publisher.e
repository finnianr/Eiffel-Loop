note
	description: "Repository test publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "5"

class
	REPOSITORY_TEST_PUBLISHER

inherit
	REPOSITORY_PUBLISHER
		redefine
			make_default, new_medium, ok_to_synchronize
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create uploaded_path_list.make (10)
		end

feature -- Access

	uploaded_path_list: ARRAYED_LIST [FILE_PATH]

feature -- Status query

	ok_to_synchronize: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	new_medium: TEST_FILE_SYNC_MEDIUM
		do
			create Result.make (uploaded_path_list)
			Result.set_remote_home (ftp_output_dir)
		end

	ftp_output_dir: DIR_PATH
		do
			Result := output_dir.parent #+ "ftp.doc"
		end

end
