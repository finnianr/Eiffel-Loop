note
	description: "Shared fractal config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-29 14:10:59 GMT (Wednesday 29th May 2019)"
	revision: "1"

deferred class
	SHARED_FRACTAL_CONFIG

inherit
	EL_ANY_SHARED
	
feature {NONE} -- Implementation

	fractal_config: FRACTAL_CONFIG
		do
			Result := Fractal_config_cell.item
		end

feature {NONE} -- Constants

	Fractal_config_cell: CELL [FRACTAL_CONFIG]
		once
			create Result.put (create {FRACTAL_CONFIG}.make)
		end

end
