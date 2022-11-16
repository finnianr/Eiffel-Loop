note
	description: "Matlab"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_MATLAB

feature {NONE} -- Implementation

	engine: EL_MATLAB_ENGINE
			-- COM interface engine
		once
			create Result.make
		end
	
	initialize_app: EL_MATLAB_APPLICATION
			-- Standalone application initialization
		once
			create Result.make
		end
	
		
end