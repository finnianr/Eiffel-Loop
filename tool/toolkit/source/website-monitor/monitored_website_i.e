note
	description: "Monitored website"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-21 8:49:34 GMT (Thursday 21st March 2024)"
	revision: "3"

deferred class
	MONITORED_WEBSITE_I

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

	EL_MODULE_LIO

feature {NONE} -- Initialization

	make
		do
			Precursor
			create base_url.make_empty
			create page_list.make (10)
			create terminal_command.make_empty
			time_out := Default_time_out
		end

feature -- Access

	base_url: STRING

	domain: ZSTRING
		local
			uri: EL_DIR_URI_PATH
		do
			uri := base_url
			Result := uri.authority
		end

	has_fault: BOOLEAN
		do
			Result := attached timed_out_page
		end

	page_list: EL_ARRAYED_LIST [MONITORED_PAGE]

	terminal_command: ZSTRING

	time_out: INTEGER
		-- time out in seconds

	timed_out_page: detachable MONITORED_PAGE

feature -- Basic operations

	check_pages
		do
			lio.put_labeled_string ("CHECKING SITE", base_url)
			lio.put_new_line_x2
			timed_out_page := Void
			across page_list as page until has_fault loop
				page.item.check_url (base_url)
				timed_out_page := page.item
			end
			lio.put_new_line
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@base_url",		 agent do base_url := node.to_string_8 end],
				["@desktop_entry", agent set_terminal_command],
				["@time_out",		 agent do time_out := node end],
				["page",				 agent do set_collection_context (page_list, new_page) end]
			>>)
		end

	new_page: MONITORED_PAGE
		do
			create Result.make (time_out)
		end

	set_terminal_command
		deferred
		end

feature {NONE} -- Constants

	Default_time_out: INTEGER = 3
		-- time out in seconds

end