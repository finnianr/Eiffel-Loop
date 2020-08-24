note
	description: "Test builder context ftp sync"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-07 11:27:00 GMT (Wednesday 7th August 2019)"
	revision: "1"

class
	TEST_BUILDER_CONTEXT_FTP_SYNC

inherit
	EL_BUILDER_CONTEXT_FTP_SYNC
		redefine
			ftp
		end

create
	make

feature -- Access

	ftp: FAUX_FTP_PROTOCOL
	
end
