note
	description: "M3U play list constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	M3U_PLAY_LIST_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Bracket_template: ZSTRING
		once
			Result := " (%S)"
		end

	Tanda_digits: FORMAT_INTEGER
		once
			create Result.make (2)
			Result.zero_fill
		end

	M3U: TUPLE [extm3u, extinf, info_template, play_list_root: ZSTRING]
		once
			create Result
			Result.extm3u := "#EXTM3U"
			Result.extinf := "#EXTINF"
			Result.info_template :=  ": %S, %S -- %S"
			Result.play_list_root := ""
		end

	Music_directory: ZSTRING
		once
			Result := "/Music"
		end

end