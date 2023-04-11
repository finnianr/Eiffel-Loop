note
	description: "Monitored website"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-11 12:40:45 GMT (Tuesday 11th April 2023)"
	revision: "1"

class
	MONITORED_WEBSITE

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create base_url.make_empty
			create page_list.make (10)
			create terminal_command.make_empty
		end

feature -- Access

	base_url: STRING

	has_fault: BOOLEAN

	page_list: EL_ARRAYED_LIST [MONITORED_PAGE]

	terminal_command: ZSTRING

feature -- Basic operations

	check_pages
		do
			has_fault := False
			lio.put_labeled_string ("CHECKING SITE", base_url)
			lio.put_new_line_x2
			across page_list as page until has_fault loop
				page.item.check_url (base_url)
				has_fault := page.item.has_fault
			end
			lio.put_new_line
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@base_url",		 agent do base_url := node.to_string_8 end],
				["@desktop_entry", agent set_terminal_command],
				["page",				 agent do set_collection_context (page_list, new_page) end]
			>>)
		end

	new_page: MONITORED_PAGE
		do
			create Result.make
		end

	set_terminal_command
		local
			desktop_ssh_path: FILE_PATH; desktop: EL_XDG_DESKTOP
		do
			desktop_ssh_path := node.to_expanded_file_path
			if desktop_ssh_path.exists then
				create desktop.make (desktop_ssh_path)
				terminal_command := desktop.exec
			end
		end

end