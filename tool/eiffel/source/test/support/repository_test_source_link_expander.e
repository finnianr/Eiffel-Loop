note
	description: "Repository test source link expander"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-17 9:52:46 GMT (Wednesday 17th March 2021)"
	revision: "2"

class
	REPOSITORY_TEST_SOURCE_LINK_EXPANDER

inherit
	REPOSITORY_SOURCE_LINK_EXPANDER
		redefine
			ftp_sync
		end

	REPOSITORY_TEST_PUBLISHER
		rename
			make as make_publisher
		undefine
			execute, ok_to_synchronize
		redefine
			ftp_sync
		end

create
	make

feature -- Access

	ftp_sync: TEST_FTP_SYNC_BUILDER_CONTEXT

end