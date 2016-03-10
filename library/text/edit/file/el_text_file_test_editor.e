note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_TEXT_FILE_TEST_EDITOR

inherit
	EL_TEXT_FILE_EDITOR
		redefine
			new_output, close
		end

feature {NONE} -- Implementation

	new_output: IO_MEDIUM
			--
		do
			Result := io.output
		end

	close
			--
		do
		end

end -- class EL_SOURCE_FILE_EDITOR_TESTER

