note
	description: "Summary description for {EL_HTTP_POST_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-11 12:14:28 GMT (Thursday 11th May 2017)"
	revision: "1"

class
	EL_HTTP_POST_COMMAND

inherit
	EL_HTTP_STRING_COMMAND
		redefine
			prepare
		end

create
	make

feature {NONE} -- Implementation

	prepare (connection: EL_HTTP_CONNECTION)
		do
			connection.enable_post_method
			Precursor (connection)
		end

end
