note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-28 16:14:33 GMT (Monday 28th December 2015)"
	revision: "5"

deferred class
	EL_TEXT_FILE_TEST_EDITOR

inherit
	EL_TEXT_EDITOR
		redefine
			new_output
		end

feature {NONE} -- Implementation

	new_output: EL_ZSTRING_IO_MEDIUM
			--
		do
			create Result.make (source_text.count)
		end

end
