note
	description: "[
		Proxy to the Flash object defined by the interface: com.laabhair.Application .
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	LB_FLASH_APPLICATION_PROXY

inherit
	EL_FLASH_OBJECT_PROXY
	
create
	make

feature -- Basic operations

	quit
			-- Send XML message to call Flash procedure with arguments:
			-- Flash sends back a UI "close" event causing this (Eiffel) application to shutdown.
			-- Flash exits when the (Laabhair) server disconnects.

			-- 		application.quit

			--		 <flash-procedure-call>
			--				<object-name>application</object-name>
			--				<procedure-name>quit</procedure-name>
			--				<arguments/>
			--		 </flash-procedure-call>
				 			
		do
			prepare_call ("quit")
			request_call
		end
		
	full_screen (flag: BOOLEAN)
			-- Send XML message to call Flash procedure with arguments:

			-- 		application.quit

			--		 <flash-procedure-call>
			--				<object-name>application</object-name>
			--				<procedure-name>full_screen</procedure-name>
			--				<arguments>
			--					<Boolean>$flag</Boolean>
			--				</arguments>
			--		 </flash-procedure-call>
				 			
		do
			prepare_call ("full_screen")
			is_full_screen := flag
			put_boolean_arg (flag)
			request_call
		end

feature -- Access

	is_full_screen: BOOLEAN

feature {NONE} -- Implementation
		
	object_name: STRING = "application"

end




