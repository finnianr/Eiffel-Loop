note
	description: "[
		**Eiffel-View**, an application for publishing an Eiffel repository to a website. See Eiffel Room articles:
		
		**Part I:** [https://room.eiffel.com/blog/finnianr/part_i_eiffelview_10_the_new_eiffel_repository_publishing_tool Eiffel-View 1.0,
		the new Eiffel repository publishing tool]
		
		**PART II:** [https://room.eiffel.com/blog/finnianr/part_ii_eiffelview_11_the_new_eiffel_repository_publishing_tool Eiffel-View 1.1,
		the new Eiffel repository publishing tool]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-05 9:43:18 GMT (Tuesday 5th June 2018)"
	revision: "9"

class
	REPOSITORY_PUBLISHER_APP

inherit
	REPOSITORY_PUBLISHER_SUB_APPLICATION [REPOSITORY_PUBLISHER]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("", "", 0)
		end

feature {NONE} -- Constants

	Option_name: STRING = "publish_repository"

	Description: STRING = "Publishes an Eiffel repository to a website"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{REPOSITORY_PUBLISHER_APP}, All_routines],
				[{REPOSITORY_SOURCE_TREE}, All_routines],
				[{REPOSITORY_SOURCE_TREE_PAGE}, All_routines]
			>>
		end

end
