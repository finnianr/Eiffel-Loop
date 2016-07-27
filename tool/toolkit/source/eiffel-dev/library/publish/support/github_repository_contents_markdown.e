note
	description: "Summary description for {GITHUB_REPOSITORY_CONTENTS_MARKDOWN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
				["tree_list",	 		agent: like repository.tree_list do Result := repository.tree_list end]
			>>)
		end

feature {NONE} -- Internal attributes

	repository: EIFFEL_REPOSITORY_PUBLISHER

feature {NONE} -- Constants

	Template: STRING = "[
		# $repository_name Contents
		#across $tree_list as $tree loop
		## $tree.item.name
			#if $tree.item.has_description then
		$tree.item.github_description
			#end
		#end
	]"
end
