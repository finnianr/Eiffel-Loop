note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

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
