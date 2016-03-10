note
	description: "Standalone application initialization routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MATLAB_APPLICATION

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
			is_library_loaded := c_initialize_application (Default_pointer, 0)
		end
		
feature -- Access

	is_library_loaded: BOOLEAN

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
	
	c_initialize_application (options: POINTER; count: INTEGER): BOOLEAN
			-- bool mclInitializeApplication(const char **options, int count);

		external
			"C (const char **, int): EIF_BOOLEAN | <matlab.h>"
		alias
			"mclInitializeApplication"
		end

	c_terminate_application: BOOLEAN
			-- bool mclTerminateApplication(void);

		external
			"C (): EIF_BOOLEAN | <matlab.h>"
		alias
			"mclTerminateApplication"
		end
	
invariant
	library_loaded: is_library_loaded

end
