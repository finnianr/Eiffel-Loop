note
	description: "Shared access to [$source TL_STRING_ENCODING_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

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