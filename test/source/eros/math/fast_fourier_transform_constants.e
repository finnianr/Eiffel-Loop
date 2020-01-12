note
	description: "Fast fourier transform constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 16:22:25 GMT (Sunday 12th January 2020)"
	revision: "1"

class
	FAST_FOURIER_TRANSFORM_CONSTANTS

feature -- Constants

	Windowers: ARRAY [WINDOWER_DOUBLE]
		do
			Result := << Windower_rectangular, Windower_default >>
		end

feature {NONE} -- Constants

	Windower_rectangular: RECTANGULAR_WINDOWER_DOUBLE
			--
		once
			create Result.make (1)
		end

	Windower_default: DEFAULT_WINDOWER_DOUBLE
			--
		once
			create Result.make (1)
		end

end
