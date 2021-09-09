note
	description: "Multimedia constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 16:04:54 GMT (Thursday 9th September 2021)"
	revision: "7"

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