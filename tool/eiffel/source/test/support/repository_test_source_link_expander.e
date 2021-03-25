note
	description: "Repository test source link expander"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-22 18:41:24 GMT (Monday 22nd March 2021)"
	revision: "3"

class
	REPOSITORY_TEST_SOURCE_LINK_EXPANDER

inherit
	REPOSITORY_SOURCE_LINK_EXPANDER
		undefine
			make_default, new_medium
		end

	REPOSITORY_TEST_PUBLISHER
		rename
			make as make_publisher
		undefine
			execute, ok_to_synchronize
		end

create
	make

end
