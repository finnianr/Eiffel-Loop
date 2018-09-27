note
	description: "Matlab"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

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