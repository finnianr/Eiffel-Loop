note
	description: "Summary description for {EL_MAKEABLE_FROM_ZSTRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-22 13:38:52 GMT (Friday 22nd December 2017)"
	revision: "4"

deferred class
	EL_MAKEABLE_FROM_STRING

feature -- Initialization

	make (string: like new_string)
		deferred
		end

	make_default
		deferred
		end

	make_from_general (general: READABLE_STRING_GENERAL)
		do
			make (new_string (general))
		end

feature -- Conversion

	to_string: like new_string
		deferred
		end

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): STRING_GENERAL
		deferred
		end
end
