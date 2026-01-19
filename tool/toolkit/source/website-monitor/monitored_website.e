note
	description: "Monitored website"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 16:42:51 GMT (Sunday 22nd September 2024)"
	revision: "6"

class
	MONITORED_WEBSITE

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_cacert_path: FILE_PATH)
		do
			make_default
			cacert_path := a_cacert_path
			create base_url.make_empty
			create page_list.make (10)
			time_out := Default_time_out
		end

feature -- Access

	base_url: STRING

	cacert_path: FILE_PATH

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

	time_out: INTEGER
		-- time out in seconds

	timed_out_page: detachable MONITORED_PAGE

feature -- Basic operations

	check_pages
		do
			lio.put_labeled_string ("CHECKING SITE", base_url)
			lio.put_new_line_x2
			timed_out_page := Void
			across page_list as list until has_fault loop
				if attached list.item as page then
					page.check_url (Current)
					if page.has_fault then
						timed_out_page := page
					end
				end
			end
			lio.put_new_line
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make_assignments (<<
				["@base_url", agent do base_url := node.to_string_8 end],
				["@time_out", agent do time_out := node end],
				["page",		  agent do set_collection_context (page_list, new_page) end]
			>>)
		end

	new_page: MONITORED_PAGE
		do
			create Result.make (time_out)
		end

feature {NONE} -- Constants

	Default_time_out: INTEGER = 3
		-- time out in seconds

end