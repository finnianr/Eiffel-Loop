note
	description: "Shared access to ${TL_STRING_ENCODING_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-28 7:48:14 GMT (Saturday 28th September 2024)"
	revision: "5"

deferred class
	TL_SHARED_STRING_ENCODING_ENUM

inherit
	EL_ANY_SHARED

feature -- Status query

	valid_encoding (code: NATURAL_8): BOOLEAN
		do
			Result := String_encoding.valid_value (code)
		end

feature {NONE} -- Constants

	String_encoding: TL_STRING_ENCODING_ENUM
		once
			create Result.make
		end
end