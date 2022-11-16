note
	description: "Shared fractal config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "3"

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