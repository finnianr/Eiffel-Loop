note
	description: "Monitor multiple websites for operational faults"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-11 12:59:03 GMT (Tuesday 11th April 2023)"
	revision: "1"

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

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_LIO; EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create website_list.make_empty
		end

feature -- Pyxis configured

	website_list: EL_ARRAYED_LIST [MONITORED_WEBSITE]

	checks_per_day: INTEGER

	minute_interval_count: INTEGER
		-- minutes between checks
		do
			Result := 24 * 60 // checks_per_day
		end

feature -- Access

	Description: STRING = "Monitor multiple websites for operational faults"

feature -- Basic operations

	execute
		local
			has_fault: BOOLEAN
		do
			from until has_fault loop
				across website_list as site until has_fault loop
					site.item.check_pages
					has_fault := site.item.has_fault
					if has_fault then
						execution.launch (site.item.terminal_command)
					end
				end
				if has_fault then
					lio.put_line ("FAULT DETECTED")
					User_input.press_enter
				else
					execution.sleep (minute_interval_count * 1000)
				end
			end
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: bix
		do
			create Result.make (<<
				["@checks_per_day", agent do checks_per_day := node end],
				["site",	agent do set_collection_context (website_list, new_site) end]
			>>)
		end

	new_site: MONITORED_WEBSITE
		do
			create Result.make
		end

end