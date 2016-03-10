indexing
	description: "[
		RPC proxy to the Flash sound spectrum visualizer object
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	MESSAGE_DISPLAY_PROXY

inherit
	EL_FLASH_OBJECT_PROXY
	
create
	make

feature -- Basic operations

	display (message: STRING; count, intensity_db: INTEGER) is
			-- Send XML message to call Flash procedure with arguments:

			-- 		message_display.display (message, count)

			--		 <flash-procedure-call>
			--				<object-name>message_display</object-name>
			--				<procedure-name>display</procedure-name>
			--				<arguments>
			--					<String>$message</String>
			--					<Number>$count</Number>
			--					<Number>$intensity_db</Number>
			--				</arguments>
			--		 </flash-procedure-call>
				 			
		do
			prepare_call ("display")
			put_string_arg (message)
			put_integer_arg (count)
			put_integer_arg (intensity_db)
			request_call
		end

feature {NONE} -- Implementation
		
	object_name: STRING is "message_display"

end


