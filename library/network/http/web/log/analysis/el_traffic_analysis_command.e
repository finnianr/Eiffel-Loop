note
	description: "[
		Implementation of ${EL_WEB_LOG_PARSER_COMMAND} to analyse web logs using 
		configuration conforming to ${EL_TRAFFIC_ANALYSIS_CONFIG}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-26 18:07:10 GMT (Sunday 26th January 2025)"
	revision: "1"

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