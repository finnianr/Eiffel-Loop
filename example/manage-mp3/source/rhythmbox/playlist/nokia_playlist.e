note
	description: "Nokia playlist"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-03 13:04:01 GMT (Tuesday 3rd September 2019)"
	revision: "5"

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
