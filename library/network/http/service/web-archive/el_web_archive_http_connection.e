note
	description: "[
		Class to find archive URL in the Wayback Machine accessible via ${EL_MODULE_WEB_ARCHIVE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-16 9:19:15 GMT (Wednesday 16th October 2024)"
	revision: "13"

class
	EL_WEB_ARCHIVE_HTTP_CONNECTION

inherit
	EL_HTTP_CONNECTION
		export
			{NONE} all
			{ANY} set_timeout_seconds, set_timeout_to_connect, set_log_output, set_silent_output
		end

create
	make

feature -- Access

	wayback (a_url: STRING): EL_WAYBACK_CLOSEST
		local
			json_list: JSON_NAME_VALUE_LIST
		do
			Parameter_table [once "url"] := a_url
			open_with_parameters (Wayback_available_url, Parameter_table)
			read_string_get
			if has_error then
				create Result.make_default
			else
				create json_list.make (last_string)
				json_list.find_field (Param_url)
				if json_list.after then
					create Result.make_default
				else
					json_list.remove -- the first url field because the 2nd is the wayback one
					create Result.make (json_list)
				end
			end
			close
		end

feature -- Status query

	is_wayback_available (a_url: like url): BOOLEAN
			-- `True' is wayback is availabe for `a_url'
		do
			Result := wayback (a_url).available
		end

feature -- Constants

	Url_template: ZSTRING
		-- http://web.archive.org/web/20100921130728/http://www.at-dot-com.com/iching/hex52.html
		once
			Result := "http://web.archive.org/web/%S/%S"
		end

feature {NONE} -- Constants

	Parameter_table: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (1)
		end

	Param_url: STRING = "url"

	Wayback_available_url: STRING = "http://archive.org/wayback/available"

end