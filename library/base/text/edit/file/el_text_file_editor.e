note
	description: "Editor that reads from a file and sends edited output back to the same file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-05 8:40:41 GMT (Friday 5th August 2016)"
	revision: "1"

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
