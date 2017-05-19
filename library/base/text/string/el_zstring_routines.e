note
	description: "Summary description for {EL_STRING_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-17 18:01:38 GMT (Wednesday 17th May 2017)"
	revision: "1"

class
	EL_ZSTRING_ROUTINES

feature -- Conversion

	as_zstring (str: READABLE_STRING_GENERAL): ZSTRING
		do
			if attached {ZSTRING} str as zstr then
				Result := zstr
			else
				create Result.make_from_unicode (str)
			end
		end
end
