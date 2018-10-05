note
	description: "Github repository contents markdown"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-02 10:54:18 GMT (Tuesday 2nd October 2018)"
	revision: "5"

class
	GITHUB_REPOSITORY_CONTENTS_MARKDOWN

inherit
	EVOLICITY_SERIALIZEABLE

create
	make

feature {NONE} -- Initialization

	make (a_repository: like repository; a_output_path: like output_path)
		do
			repository := a_repository
			make_from_file (a_output_path)
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["repository_name", 	agent: ZSTRING do Result := repository.name end],
				["ecf_list",	 		agent: like repository.ecf_list do Result := repository.ecf_list end]
			>>)
		end

feature {NONE} -- Internal attributes

	repository: REPOSITORY_PUBLISHER

feature {NONE} -- Constants

	Template: STRING = "[
		# $repository_name Contents
		#across $ecf_list as $tree loop
		## $tree.item.name
			#if $tree.item.has_description then
		$tree.item.github_description
			#end
		#end
	]"
end
