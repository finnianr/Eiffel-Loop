note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

deferred class
	EL_TEXT_FILE_TEST_EDITOR

inherit
	EL_TEXT_FILE_EDITOR
		redefine
			new_output, close
		end

feature {NONE} -- Implementation

	new_output: EL_TEXT_IO_MEDIUM
			--
		do
			create Result.make_open_write (source_text.count)
		end

	close
			--
		do
		end

end -- class EL_SOURCE_FILE_EDITOR_TESTER

