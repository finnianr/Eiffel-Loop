note
	description: "List of sub-applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-27 18:02:07 GMT (Sunday 27th May 2018)"
	revision: "1"

class
	EL_SUB_APPLICATION_LIST

inherit
	EL_ARRAYED_LIST [EL_SUB_APPLICATION]
		rename
			make as make_list
		end

	EL_MODULE_ARGS
		undefine
			copy, is_equal
		end

	EL_MODULE_EIFFEL
		undefine
			copy, is_equal
		end

	EL_MODULE_LIO
		rename
			Lio as Later_lio,
			new_lio as new_temporary_lio
		undefine
			copy, is_equal
		end

	EL_MODULE_STRING_8
		undefine
			copy, is_equal
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (types: ARRAY [TYPE [EL_SUB_APPLICATION]]; a_select_first: BOOLEAN)
		do
			make_list (types.count)
			select_first := a_select_first
			across types as type loop
				if attached {EL_SUB_APPLICATION} Eiffel.new_instance_of (type.item.type_id) as app then
					extend (app)
				end
			end
			extend (create {EL_VERSION_APP})
			compare_objects
		end

feature -- Access

	installable_list: EL_ARRAYED_LIST [EL_INSTALLABLE_SUB_APPLICATION]
		do
			create Result.make (count)
			across Current as app loop
				if attached {EL_INSTALLABLE_SUB_APPLICATION} app.item as installable then
					Result.extend (installable)
				end
			end
		end

	main: EL_INSTALLABLE_SUB_APPLICATION
		-- main installable application
		require
			has_main_application: has_main
		local
			found_app: BOOLEAN
		do
			across installable_list as app until found_app loop
				if app.item.is_main then
					Result := app.item
					found_app := True
				end
			end
		end

feature -- Basic operations

	io_put_menu
			--
		local
			line_count: INTEGER; lio: EL_LOGGABLE
		do
			lio := new_temporary_lio -- until the logging is initialized in `EL_SUB_APPLICATION'

			lio.put_new_line
			across Current as app loop
				lio.put_integer (app.cursor_index)
				lio.put_string (". Command option: -")
				lio.put_line (app.item.option_name.as_string_8)

				lio.put_new_line
				lio.put_string (String_8.spaces (Tab_width, 1))
				lio.put_line ("DESCRIPTION: ")
				line_count := 0
				across app.item.description.split ('%N') as line loop
					line_count := line_count + 1
					lio.put_string (String_8.spaces (Tab_width, 2))
					lio.put_line (line.item)
				end
				lio.put_new_line
			end
		end

	launch_selected
			-- launch application selected from command-line option or user selection
		local
			lio: EL_LOGGABLE
		do
			lio := new_temporary_lio -- until the logging is initialized in `EL_SUB_APPLICATION'
			find_first (Args.option_name (1), agent {EL_SUB_APPLICATION}.new_option_name)
			if after then
				if select_first then
					start
				else
					if not Args.has_silent then
						io_put_menu
					end
					go_i_th (user_selection)
				end
			end
			if not off then

				item.make -- Initialize and run application

				lio.put_new_line
				lio.put_new_line

				wipe_out
				-- Causes a crash on some multi-threaded applications
				{MEMORY}.full_collect
			end
		end

feature -- Status query

	has_main: BOOLEAN
		-- `True' if has a main installable sub-application
		do
			Result := across Current as app some
				attached {EL_INSTALLABLE_SUB_APPLICATION} app.item as installable and then installable.is_main
			end
		end

	select_first: BOOLEAN
		-- if `True' first application selected by default

feature {NONE} -- Implementation

	user_selection: INTEGER
			-- Number selected by user from menu
		do
			if not Args.has_silent then
				io.put_string ("Select program by number: ")
				io.read_line
				if io.last_string.is_integer then
					Result := io.last_string.to_integer
				end
			end
		end

feature {NONE} -- Constants

	Tab_width: INTEGER = 3

end
