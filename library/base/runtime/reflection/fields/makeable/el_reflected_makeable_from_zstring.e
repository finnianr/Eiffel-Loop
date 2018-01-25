note
	description: "Summary description for {EL_REFLECTED_MAKEABLE_FROM_ZSTRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-17 13:53:52 GMT (Wednesday 17th January 2018)"
	revision: "3"

class
	EL_REFLECTED_MAKEABLE_FROM_ZSTRING

inherit
	EL_REFLECTED_MAKEABLE_FROM_STRING
		redefine
			default_value
		end

create
	make

feature {NONE} -- Implementation

	as_string (readable: EL_READABLE): ZSTRING
		do
			Result := readable.read_string
		end

feature {NONE} -- Internal attributes

	default_value: detachable EL_MAKEABLE_FROM_ZSTRING
end
