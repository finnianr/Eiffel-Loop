note
	description: "Summary description for {EL_SHARED_UTF_8_ZCODEC}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-03 9:42:28 GMT (Saturday 3rd March 2018)"
	revision: "1"

class
	EL_SHARED_UTF_8_ZCODEC

feature {NONE} -- Constants

	Utf_8_codec: EL_UTF_8_ZCODEC
		once
			create Result.make
		end
end
