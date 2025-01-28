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
	date: "2025-01-28 8:26:46 GMT (Tuesday 28th January 2025)"
	revision: "2"

deferred class
	EL_TRAFFIC_ANALYSIS_COMMAND

inherit
	EL_WEB_LOG_PARSER_COMMAND

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_config: like config)
		do
			config := a_config
			make_default
		end

feature {NONE} -- Internal attributes

	config: EL_TRAFFIC_ANALYSIS_CONFIG

end