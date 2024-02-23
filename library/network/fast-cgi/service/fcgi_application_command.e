note
	description: "Base class for ${FCGI_SERVLET_SERVICE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-22 17:46:18 GMT (Thursday 22nd February 2024)"
	revision: "1"

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

feature {NONE} -- String constants

	frozen Default_servlet_key: ZSTRING
		once
			Result := "<DEFAULT>"
		end

	frozen Fcgi_web_server_addrs: STRING = "FCGI_WEB_SERVER_ADDRS"

	Service_info_template: ZSTRING
		once
			Result := "[
				"#" with servlet #
			]"
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