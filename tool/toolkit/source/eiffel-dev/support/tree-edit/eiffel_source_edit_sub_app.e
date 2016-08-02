note
	description: "Summary description for {EIFFEL_SOURCE_EDIT_SUB_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-20 9:41:53 GMT (Wednesday 20th January 2016)"
	revision: "1"

deferred class
	EIFFEL_SOURCE_EDIT_SUB_APP

inherit
	FILE_OPERATING_SUB_APP

feature -- Basic operations

	normal_run
		do
			log_or_io.put_path_field ("Editing", file_path); log_or_io.put_new_line
			create_file_editor.edit
		end

feature -- Testing	

	test_run
			--
		do
			Test.do_file_test ("Eiffel/latin1-sources/os-command/file-system/EL_COPY_FILE_COMMAND.e", agent test_edit, checksum)
		end

	test_edit (a_file_path: EL_FILE_PATH)
		do
			set_defaults
			file_path := a_file_path
			normal_initialize
			normal_run
		end

	checksum: NATURAL
		deferred
		end

feature {NONE} -- Implementation

	create_file_editor: EIFFEL_SOURCE_EDITING_PROCESSOR
		deferred
		end

end