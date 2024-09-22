note
	description: "Monitor multiple websites for operational faults"
	notes: "This is a Unix only application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 16:42:51 GMT (Sunday 22nd September 2024)"
	revision: "9"

class
	WEBSITE_MONITOR

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make,
			default_root_node_name as root_node_name
		export
			{EL_COMMAND_CLIENT} make
		redefine
			make_default
		end

	EL_APPLICATION_COMMAND
		undefine
			is_equal
		end

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_LIO; EL_MODULE_DATE_TIME; EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create website_list.make_empty
			create cacert_path
		end

feature -- Pyxis configured

	cacert_path: FILE_PATH

	checks_per_day: INTEGER

	minute_interval_count: INTEGER
		-- minutes between checks
		do
			Result := (24 * 60) // checks_per_day
		end

	website_list: EL_ARRAYED_LIST [MONITORED_WEBSITE]

feature -- Access

	Description: STRING = "Monitor multiple websites for operational faults"

feature -- Basic operations

	execute
		local
			site_ok: BOOLEAN; next_time: EL_TIME
		do
			from until False loop
				across website_list as list loop
					if attached list.item as website then
						from site_ok := False until site_ok loop
							website.check_pages
							if website.has_fault then
								lio.put_labeled_string ("FAULT DETECTED", website.domain)
								lio.put_new_line
								if attached Notification_command as cmd then
									cmd.put_string (cmd.var.error, website.domain)
									cmd.put_string (cmd.var.urgency, cmd.Urgency.critical)
									if attached website.timed_out_page as page then
										cmd.put_string (cmd.var.message, page.url)
									end
									cmd.execute
								end
								User_input.press_enter
							else
								site_ok := True
							end
						end
					end
				end
				create next_time.make_now
				next_time.minute_add (minute_interval_count)
				lio.put_labeled_string ("Next check at", next_time.formatted_out ("[0]hh:[0]mi"))
				lio.put_new_line
				execution.sleep (minute_interval_count * 60_000)
			end
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: bix
		do
			create Result.make_assignments (<<
				["@checks_per_day", agent do checks_per_day := node end],
				["@cacert_path",	  agent do cacert_path := node.to_expanded_file_path end],
				["site",				  agent do set_collection_context (website_list, new_site) end]
			>>)
		end

	new_site: MONITORED_WEBSITE
		do
			create Result.make (cacert_path)
		end

feature {NONE} -- Constants

	Notification_command: EL_NOTIFY_SEND_ERROR_COMMAND_I
		once
			create {EL_NOTIFY_SEND_ERROR_COMMAND} Result.make
		end

end