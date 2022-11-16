note
	description: "Multimedia constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_MULTIMEDIA_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature -- Constants

	Media_extension: TUPLE [mp3, wav: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "mp3, wav")
		end

	Video_extensions: EL_ZSTRING_LIST
		once
			Result := "flv, mp4, mov"
		end

end