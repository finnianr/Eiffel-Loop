note
	description: "Test [$source EL_FTP_SYNC_BUILDER_CONTEXT] using faux ftp  [$source FAUX_FTP_PROTOCOL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-17 9:54:10 GMT (Wednesday 17th March 2021)"
	revision: "2"

class
	TEST_FTP_SYNC_BUILDER_CONTEXT

inherit
	EL_FTP_SYNC_BUILDER_CONTEXT
		redefine
			ftp
		end

create
	make

feature -- Access

	ftp: FAUX_FTP_PROTOCOL

end