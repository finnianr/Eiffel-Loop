note
	description: "[
		Routines allowing threads other than the main Windows thread to make (asynchronous)
		calls to WEL routines. This is done by 'posting' rather than 'sending' messages to the
		Windows message queue. (The message is processed later by the Windows thread)
		This is needed because if an external thread makes a synchronous (immediate) call
		to a Windows routine, the application will freeze. :-(
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_WEL_EXTERNAL_THREAD_ROUTINES

inherit
	WEL_WM_CONSTANTS

	WEL_NM_CONSTANTS

feature {NONE} -- Basic operations

	post_button_click (command_id: INTEGER)
			-- Puts a button click message on windows message queue
			-- (Called from a thread external to the main Windows thread)
			
		do
			cwin_post_message (
				item, wm_command,
				cwin_make_long (command_id, Nm_click),  -- {WEL_NM_CONSTANTS}.Nm_click
				cwin_make_long (1, 0)
			)
		end

feature {NONE} -- Implememtation

	cwin_post_message (hwnd: POINTER; msg: INTEGER; wparam, lparam: POINTER)
			--
		deferred
		end

	cwin_make_long (low, high: INTEGER): POINTER
			--
		deferred
		end
	
	item: POINTER
			--
		deferred
		end
	
end

