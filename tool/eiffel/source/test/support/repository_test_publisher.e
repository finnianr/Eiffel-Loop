note
	description: "Repository test publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-17 9:52:46 GMT (Wednesday 17th March 2021)"
	revision: "2"

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

	ftp_sync: TEST_FTP_SYNC_BUILDER_CONTEXT

feature -- Status query

	ok_to_synchronize: BOOLEAN
		do
			Result := True
		end
end