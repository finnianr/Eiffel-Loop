note
	description: "Repository test publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-24 8:26:26 GMT (Thursday 24th August 2023)"
	revision: "9"

class
	REPOSITORY_TEST_PUBLISHER

inherit
	REPOSITORY_PUBLISHER
		redefine
			authenticate_ftp, execute, make_default, new_medium, Ftp_host
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

	Ftp_host: STRING = "ftp.eiffel-loop.com"

	uploaded_path_list: ARRAYED_LIST [FILE_PATH]

feature -- Basic operations

	execute
		do
			uploaded_path_list.wipe_out
			Precursor
		end

feature {NONE} -- Implementation

	authenticate_ftp
		do
			do_nothing
		end

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