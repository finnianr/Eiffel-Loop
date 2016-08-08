note
	description: "Editor that reads from a file and sends edited output back to the same file"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_TEXT_FILE_EDITOR

inherit
	EL_TEXT_EDITOR

feature -- Access

	file_path: EL_FILE_PATH
		deferred
		end

feature -- Element change

	set_file_path (a_file_path: like file_path)
			--
		deferred
		end

feature {NONE} -- Implementation

	new_output: EL_PLAIN_TEXT_FILE
			--
		do
			create Result.make_open_write (file_path)
		end

feature {NONE} -- Constants

	Default_file_path: EL_FILE_PATH
		once
			create Result
		end
end
