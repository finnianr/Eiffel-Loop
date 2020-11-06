note
	description: "[
		**Eiffel-View** is a sub-application to publish source code and descriptions of Eiffel projects
		to a website as static html and generate a `Contents.md' file in Github markdown. 
		
		See [https://www.eiffel.org/blog/Finnian%20Reilly/2018/10/eiffel-view-repository-publisher-version-1-0-18
		eiffel.org article] and the [$source REPOSITORY_PUBLISHER] command.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-06 16:52:20 GMT (Friday 6th November 2020)"
	revision: "16"

class
	EIFFEL_VIEW_APP

inherit
	REPOSITORY_PUBLISHER_SUB_APPLICATION [REPOSITORY_PUBLISHER]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "", 0)
		end

	log_filter_list: EL_LOG_FILTER_LIST [
		like Current,
		EIFFEL_CONFIGURATION_FILE,
		EIFFEL_CONFIGURATION_INDEX_PAGE,
		EL_LOGGED_WORK_DISTRIBUTION_THREAD
	]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING = "eiffel_view"

	Description: STRING = "Publishes source code and descriptions of Eiffel projects to a website as static html"

end