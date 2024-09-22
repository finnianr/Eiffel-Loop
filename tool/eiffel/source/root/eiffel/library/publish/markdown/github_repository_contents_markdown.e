note
	description: "Github repository contents markdown"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 17:06:59 GMT (Sunday 22nd September 2024)"
	revision: "11"

class
	GITHUB_REPOSITORY_CONTENTS_MARKDOWN

inherit
	EVOLICITY_SERIALIZEABLE
		redefine
			is_bom_enabled
		end

create
	make

feature {NONE} -- Initialization

	make (a_repository: like repository; a_output_path: like output_path)
		do
			repository := a_repository
			make_from_file (a_output_path)
		end

feature -- Status query

	is_bom_enabled: BOOLEAN = True

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["repository_name", 	agent: ZSTRING do Result := repository.config.name end],
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