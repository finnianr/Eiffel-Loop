note
	description: "Id3 shared encoding enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 14:11:43 GMT (Thursday 10th October 2019)"
	revision: "1"

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
