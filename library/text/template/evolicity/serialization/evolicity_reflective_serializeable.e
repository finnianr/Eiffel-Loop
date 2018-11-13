note
	description: "Reflective Evolicity serializeable context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-13 9:28:29 GMT (Tuesday 13th November 2018)"
	revision: "1"

deferred class
	EVOLICITY_REFLECTIVE_SERIALIZEABLE

inherit
	EVOLICITY_SERIALIZEABLE
		undefine
			context_item
		end

	EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT
		undefine
			make_default, new_getter_functions
		end
end
