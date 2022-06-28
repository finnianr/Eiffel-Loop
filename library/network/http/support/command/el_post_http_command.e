note
	description: "Post http command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_POST_HTTP_COMMAND

inherit
	EL_STRING_DOWNLOAD_HTTP_COMMAND
		redefine
			prepare
		end

create
	make

feature {NONE} -- Implementation

	prepare
		do
			connection.enable_post_method
			Precursor
		end

end
