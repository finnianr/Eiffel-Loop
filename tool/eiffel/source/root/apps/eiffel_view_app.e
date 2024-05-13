note
	description: "[
		**Eiffel-View** is a sub-application to publish source code and descriptions of Eiffel projects
		to a website as static html and generate a `Contents.md' file in Github markdown. 
		
		See [https://www.eiffel.org/blog/Finnian%20Reilly/2018/10/eiffel-view-repository-publisher-version-1-0-18
		eiffel.org article] and the ${REPOSITORY_PUBLISHER} command.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-08 9:07:13 GMT (Wednesday 8th May 2024)"
	revision: "25"

class
	EIFFEL_VIEW_APP

inherit
	REPOSITORY_PUBLISHER_APPLICATION [EIFFEL_VIEW_COMMAND]
		redefine
			Option_name, visible_types
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "", 0)
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current,
		EIFFEL_CONFIGURATION_FILE,
		EIFFEL_CONFIGURATION_INDEX_PAGE,
		EL_LOGGED_WORK_DISTRIBUTION_THREAD
	]
		do
			create Result.make
		end

	compile: TUPLE [EL_FILE_SYNC_ITEM]
		do
			create Result
		end

	visible_types: TUPLE [EL_FILE_SYNC_MANAGER]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "eiffel_view"

end