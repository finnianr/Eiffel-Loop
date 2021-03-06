note
	description: "Shared utf 8 zcodec"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:26:02 GMT (Monday 1st July 2019)"
	revision: "4"

deferred class
	EL_SHARED_UTF_8_ZCODEC

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Utf_8_codec: EL_UTF_8_ZCODEC
		once
			create Result.make
		end
end
