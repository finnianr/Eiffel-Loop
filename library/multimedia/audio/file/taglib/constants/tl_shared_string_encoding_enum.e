note
	description: "Shared access to [$source TL_STRING_ENCODING_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-17 17:26:33 GMT (Tuesday 17th March 2020)"
	revision: "1"

deferred class
	TL_SHARED_STRING_ENCODING_ENUM

inherit
	EL_ANY_SHARED

feature -- Status query

	valid_encoding (code: NATURAL_8): BOOLEAN
		do
			Result := String_encoding.is_valid_value (code)
		end

feature {NONE} -- Constants

	String_encoding: TL_STRING_ENCODING_ENUM
		once
			create Result.make
		end
end
