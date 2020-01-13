note
	description: "Fast fourier transform constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 8:29:01 GMT (Monday 13th January 2020)"
	revision: "2"

class
	FFT_ONCE_ROUTINE_NAMES

feature {NONE} -- Constants

	Windower_id_set: ARRAY [STRING]
		once
			Result := << R_windower_rectangular, R_windower_default >>
		end

feature {NONE} -- Routine names

	R_windower_default: STRING = "Windower_default"

	R_windower_rectangular: STRING = "Windower_rectangular"

end
