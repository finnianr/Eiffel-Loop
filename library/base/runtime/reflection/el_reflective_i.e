note
	description: "Basic interface to reflective object useful in paralell inheritance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-31 17:49:13 GMT (Wednesday 31st October 2018)"
	revision: "1"

deferred class
	EL_REFLECTIVE_I

inherit
	EL_REFLECTOR_CONSTANTS

feature {NONE} -- Implementation

	current_reflective: EL_REFLECTIVE
		deferred
		end

	field_table: EL_REFLECTED_FIELD_TABLE
		deferred
		end

end
