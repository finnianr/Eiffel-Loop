note
	description: "Summary description for {MY_PROCEDURE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-14 9:39:00 GMT (Sunday 14th August 2016)"
	revision: "1"

class
	MY_PROCEDURE [BASE_TYPE -> detachable ANY, OPEN_ARGS -> detachable TUPLE create default_create end]

inherit
	PROCEDURE [BASE_TYPE, OPEN_ARGS]
		export
			{ANY} open_operand_type
		end

create
	adapt

end
