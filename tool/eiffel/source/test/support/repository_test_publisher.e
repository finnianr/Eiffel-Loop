note
	description: "Repository test publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-31 6:35:23 GMT (Friday 31st May 2024)"
	revision: "10"

class
	REPOSITORY_TEST_PUBLISHER

inherit
	REPOSITORY_PUBLISHER
		redefine
			authenticate_ftp, execute, file_sync_display, make_default, new_medium, Ftp_host
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

	file_sync_display: EL_PROGRESS_DISPLAY
		do
			Result := Default_display
		end

	ftp_output_dir: DIR_PATH
		do
			Result := output_dir.parent #+ "ftp.doc"
		end

end