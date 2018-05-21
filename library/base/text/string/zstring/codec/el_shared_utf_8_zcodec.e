note
	description: "Shared utf 8 zcodec"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "2"

class
	EL_SHARED_UTF_8_ZCODEC

feature {NONE} -- Constants

	Utf_8_codec: EL_UTF_8_ZCODEC
		once
			create Result.make
		end
end
