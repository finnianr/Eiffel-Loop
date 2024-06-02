note
	description: "Repository test source link expander"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-31 6:35:46 GMT (Friday 31st May 2024)"
	revision: "12"

class
	REPOSITORY_TEST_SOURCE_LINK_EXPANDER

inherit
	REPOSITORY_SOURCE_LINK_EXPANDER
		undefine
			authenticate_ftp, make_default, new_medium, ftp_host
		redefine
			ask_user
		end

	REPOSITORY_TEST_PUBLISHER
		rename
			make as make_publisher
		undefine
			execute, file_sync_display
		redefine
			ask_user
		end

create
	make

feature {NONE} -- Implementation

	ask_user
		do
			user_quit := True
		end

end