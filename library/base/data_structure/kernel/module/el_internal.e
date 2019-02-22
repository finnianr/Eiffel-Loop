note
	description: "Internal reflection routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-22 14:30:47 GMT (Friday 22nd February 2019)"
	revision: "2"

class
	EL_INTERNAL

inherit
	INTERNAL

	SED_UTILITIES
		export
			{ANY} abstract_type
		end

feature -- Access

	reflected (a_object: ANY): EL_REFLECTED_REFERENCE_OBJECT
		do
			create Result.make (a_object)
		end

end
