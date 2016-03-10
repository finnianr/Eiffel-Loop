note
	description: "Connection with COM AUTOMATION instance of MATLAB"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MATLAB_ENGINE

inherit
	EL_MEMORY
		redefine
			dispose
		end
	
	EL_LOGGING
	
create
	make
		
feature {NONE} -- Initialization

	make
		-- 
		
		do
			item := c_engine_open (Default_pointer)
		end
		
feature  {EL_MATLAB} -- Access

	item: POINTER

feature {NONE} -- Disposal

	dispose
			--
		local
			is_closed: BOOLEAN
		do
--			is_closed := c_engine_close (item) = 0
--			check
--				engine_closed: is_closed
--			end
		end

feature {NONE} -- C externals
	
	c_engine_open (start_cmd: POINTER): POINTER
			-- Engine *engOpen(const char *startcmd);

		external
			"C (const char *): EIF_POINTER | <engine.h>"
		alias
			"engOpen"
		end

	c_engine_close (engine: POINTER): INTEGER
			-- Quit MATLAB engine session
			-- int engClose(Engine *ep);

		external
			"C (Engine *): EIF_INTEGER | <engine.h>"
		alias
			"engClose"
		end
	
invariant
	valid_instance: not item.is_equal (Default_pointer)
	
end
