indexing
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	HELLO_WORLD_MAIN_WINDOW

inherit
	LB_MAIN_WINDOW [SIMPLE_ANALYZER, HELLO_WORLD_MICROPHONE_FLASH_UI_LISTENER, HELLO_WORLD_CONFIGURATION_EDIT_WINDOW]
	
	HELLO_WORLD_SHARED_CONFIGURATION
	
create
	make
	
feature {NONE} -- Implementation

	Class_icon: WEL_ICON is
			-- Window's icon
		once
			create Result.make_by_id (Id_ico_hello_world)
		end
	
	Window_title: STRING is "Hello World"

	Credits: STRING is "[
		Designed and developed by Finnian Reilly
		Copyright (C) 2006 Eiffel LOOP (All rights reserved)
		
		With the kind help and support of:
		Elmar Jung at the Digital Media Centre
		Dublin Institute of Technology, Ireland
		
		and Eiffel Software, Goleta, California
		
		Created with:
		 ISE Eiffel, ActionScript and Praat script
		
		using:
		  The Laabhair development framework 1.0
		  EiffelStudio 5.6
		  Macromedia Flash Professional 8.0
		  Microsoft Visual C++ 7.1
		  Praat C libraries 4.4.24
	]"

	Id_ico_hello_world: INTEGER is 3

end -- HELLO_WORLD_MAIN_WINDOW

