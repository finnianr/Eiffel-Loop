note
	description	: "Simple program demonstrating the use of cursors."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date: 2009-07-06 07:15:42 -0700 (Mon, 06 Jul 2009) $"
	revision	: "$Revision: 79580 $"

class
	APPLICATION

inherit
	EV_APPLICATION

create
	make_and_launch

feature -- Initialization

	make_and_launch
			-- Create and launch.
		do
			default_create
			prepare
			launch
		end

	prepare
			-- Initialize world.
		do
			create main_window.make
			main_window.close_request_actions.extend (agent on_exit)
			main_window.show
		end

feature {NONE} -- Graphical interface

	main_window: TITLED_TAB_BOOK_WINDOW

feature {NONE} -- Implementation

	on_exit
			-- Quit the program
		do
			destroy
		end

end
