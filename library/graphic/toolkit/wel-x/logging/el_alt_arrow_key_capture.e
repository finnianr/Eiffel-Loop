note
	description: "Alt arrow key capture"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	EL_ALT_ARROW_KEY_CAPTURE

inherit
	WEL_VK_CONSTANTS
		export
			{NONE} all
		end
	
	WEL_WINDOWS_ROUTINES
		export
			{NONE} all
		end
		
feature -- Event handlers

	on_sys_key_down (virtual_key, key_data: INTEGER)
			-- Wm_keydown message.
		do
			inspect virtual_key
				when Vk_left then
					if key_down (Vk_menu) then
						on_alt_left_arrow_key_down
					end
	
				when Vk_right then
					if key_down (Vk_menu) then
						on_alt_right_arrow_key_down
						
					end
					
				else
			end
		end

	on_alt_left_arrow_key_down
			--
		deferred
		end
		
	on_alt_right_arrow_key_down
			--
		deferred
		end
end