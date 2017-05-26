note
	description: "Summary description for {MY_PROCEDURE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 20:21:04 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	MY_PROCEDURE [BASE_TYPE -> detachable ANY, OPEN_ARGS -> detachable TUPLE create default_create end]

inherit
	PROCEDURE [OPEN_ARGS]
		export
			{ANY} open_operand_type
		end

create
	adapt

end
