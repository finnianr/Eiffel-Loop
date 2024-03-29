note
	description: "Shared utf 8 zcodec"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

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