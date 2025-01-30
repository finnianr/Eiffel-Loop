note
	description: "[
		Implementation of ${EL_WEB_LOG_PARSER_COMMAND} to analyse web logs using 
		configuration conforming to ${EL_TRAFFIC_ANALYSIS_CONFIG}
	]"
	descendants: "[
			EL_TRAFFIC_ANALYSIS_COMMAND*
				${EL_GEOGRAPHIC_ANALYSIS_COMMAND}
				${EL_404_STATUS_ANALYSIS_COMMAND}
					${EL_GEOGRAPHIC_404_ANALYSIS_COMMAND}
					${EL_USER_AGENT_404_ANALYSIS_COMMAND}
					${EL_REQUEST_COUNT_404_ANALYSIS_COMMAND}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-29 11:42:18 GMT (Wednesday 29th January 2025)"
	revision: "3"

deferred class
	EL_TRAFFIC_ANALYSIS_COMMAND

inherit
	EL_WEB_LOG_PARSER_COMMAND

	EL_SHARED_HTTP_STATUS

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_config: like config)
		do
			config := a_config
			make_default
		end

feature {NONE} -- Internal attributes

	config: EL_TRAFFIC_ANALYSIS_CONFIG

feature {NONE} -- Constants

	Found_status_list: ARRAY [NATURAL_16]
		once
			Result := << Http_status.ok, Http_status.moved_permanently, Http_status.not_modified >>
		end

end