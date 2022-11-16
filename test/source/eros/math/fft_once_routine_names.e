note
	description: "Fast fourier transform constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "3"

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