note
	description: "Summary description for {TO_DO_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 16:37:44 GMT (Wednesday 16th December 2015)"
	revision: "6"

class
	TO_DO_LIST

inherit
	PROJECT_NOTES

feature -- Access

	id3_editing
		do
			-- Make sure to use {RBOX_SONG}.write_id3_info for writing changes so that
			-- mtime is updated

			-- Look at EL_ID3_FRAME
		end
end