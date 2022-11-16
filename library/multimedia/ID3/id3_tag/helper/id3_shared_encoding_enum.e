note
	description: "Id3 shared encoding enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	ID3_SHARED_ENCODING_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Encoding_enum: ID3_ENCODING_ENUM
		once
			create Result.make
		end

end