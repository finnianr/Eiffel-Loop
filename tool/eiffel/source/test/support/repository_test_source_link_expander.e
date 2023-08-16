note
	description: "Repository test source link expander"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-10 18:36:08 GMT (Thursday 10th August 2023)"
	revision: "9"

class
	REPOSITORY_TEST_SOURCE_LINK_EXPANDER

inherit
	REPOSITORY_SOURCE_LINK_EXPANDER
		undefine
			make_default, new_medium
		redefine
			ask_user
		end

	REPOSITORY_TEST_PUBLISHER
		rename
			make as make_publisher
		undefine
			execute, ok_to_synchronize
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