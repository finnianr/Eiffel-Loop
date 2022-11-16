note
	description: "Nokia playlist"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	NOKIA_PLAYLIST

inherit
	M3U_PLAYLIST
		redefine
			Template, Is_nokia_phone
		end

create
	make

feature {NONE} -- Evolicity fields

	Is_nokia_phone: BOOLEAN = True

	Template: STRING
			-- Windows compatible paths are required for Nokia phones
		once
			create Result.make_from_string (Precursor)
			-- Remove #EXTM3U
			Result.remove_head (Result.index_of ('%N', 1))
		end
end