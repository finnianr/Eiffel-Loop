note
	description: "Summary description for {DOCKING_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-02-12 16:35:17 GMT (Tuesday 12th February 2013)"
	revision: "2"

class
	DOCKING_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end
create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			create vision_app
			create first_window.make
		end

feature -- Basic operations

	run
			--
		do
			log.enter ("run")
			first_window.show
			vision_app.launch
			log.exit
		end


feature {NONE} -- Implementation

	vision_app: EV_APPLICATION

	first_window: detachable MAIN_WINDOW

feature {NONE} -- Constants

	Option_name: STRING = "docking"

	Description: STRING = "Test out docking library"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{DOCKING_APP}, "*"]
			>>
		end

end
