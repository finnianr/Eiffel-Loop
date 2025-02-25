note
	description: "Base class for ${FCGI_SERVLET_SERVICE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-25 9:11:05 GMT (Tuesday 25th February 2025)"
	revision: "6"

deferred class
	FCGI_APPLICATION_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_DATE; EL_MODULE_DIRECTORY

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_EXCEPTION; EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG; EL_MODULE_LOG_MANAGER; EL_MODULE_UNIX_SIGNALS

	EL_STRING_8_CONSTANTS

	EL_SHARED_DOCUMENT_TYPES; 	EL_SHARED_HTTP_STATUS  EL_SHARED_OPERATING_ENVIRON

	EL_ENCODING_TYPE
		export
			{NONE} all
		end

feature {NONE} -- Event handling

	on_missing_servlet (resp: FCGI_SERVLET_RESPONSE)
			-- Send error page indicating missing servlet
		do
			resp.send_error (Http_status.not_found, "Resource not found", Text_type.html, Utf_8)
		end

	on_shutdown
		do
		end

feature {NONE} -- Implementation

	call (object: ANY)
		do
		end

	log_error (label, message: READABLE_STRING_GENERAL)
		do
			log_message ("ERROR", generator)
			log_message (label, message)
		end

	log_message (label, message: READABLE_STRING_GENERAL)
		do
			if not label.is_empty then
				lio.put_labeled_string (label, message)
				lio.put_new_line
			else
				lio.put_line (message)
			end
		end

	log_parameters (query_string: ZSTRING)
		local
			parameter: EL_NAME_VALUE_PAIR [ZSTRING]
		do
			lio.put_string (once "Parameters:")
			lio.tab_right
			lio.put_new_line
			create parameter.make_empty
			across query_string.split ('&') as list loop
				parameter.set_from_string (list.item, '=')
				lio.put_labeled_string (parameter.name, parameter.value)
				if list.is_last then
					lio.tab_left
				end
				lio.put_new_line
			end
		end

feature {NONE} -- String constants

	frozen Default_servlet_key: ZSTRING
		once
			Result := "<DEFAULT>"
		end

	frozen Fcgi_web_server_addrs: STRING = "FCGI_WEB_SERVER_ADDRS"

	Service_info_template: ZSTRING
		once
			Result := "%S (%"%S%")"
		end

	Servlet_app_log_category: STRING = "servlet.app"

	Time_format: STRING = "[0]hh:[0]mi:[0]ss"

	Date_format: STRING
		once
			if attached date as d then
				Result := d.new_format (<< d.Var.long_month_name, d.Var.canonical_numeric_day >>)
			end
		end

feature {NONE} -- Constants

	Max_initialization_retry_count: INTEGER
		-- The maximum number of times application will retry
		once
			Result := 3
		end

end