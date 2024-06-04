note
	description: "Repository test source link expander"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-04 9:04:39 GMT (Tuesday 4th June 2024)"
	revision: "13"

class
	REPOSITORY_TEST_SOURCE_LINK_EXPANDER

inherit
	REPOSITORY_SOURCE_LINK_EXPANDER
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