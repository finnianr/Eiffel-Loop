note
	description: "Repository test publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-07 11:30:27 GMT (Wednesday 7th August 2019)"
	revision: "1"

class
	REPOSITORY_TEST_PUBLISHER

inherit
	REPOSITORY_PUBLISHER
		redefine
			ftp_sync, ok_to_synchronize
		end

create
	make

feature -- Access

	ftp_sync: TEST_BUILDER_CONTEXT_FTP_SYNC

feature -- Status query

	ok_to_synchronize: BOOLEAN
		do
			Result := True
		end
end
