note
	description: "ECF project information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-19 16:56:05 GMT (Sunday 19th December 2021)"
	revision: "8"

class
	ECF_INFO

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create path
			ignored_clusters := Default_ignored_clusters
		end

feature -- Access

	cluster_count (root: EL_XPATH_ROOT_NODE_CONTEXT): INTEGER
		do
			Result := root.integer_at_xpath (once "count (" + cluster_xpath + once ")")
		end

	cluster_xpath: STRING
		local
			exclusions: ZSTRING
		do
			if ignored_clusters.is_empty then
				Result := Xpath_cluster
			else
				-- create expression: cluster[not (@name='a' or @name='b' or ..)]
				across ignored_clusters as name loop
					if name.cursor_index = 1 then
						exclusions := Name_equals #$ [name.item]
						exclusions.remove_head (Name_equals.index_of ('@', 1) - 1)
					else
						exclusions := exclusions + Name_equals #$ [name.item]
					end
				end
				Result := Xpath_selected_cluster #$ [exclusions]
			end
		end

	description (root: EL_XPATH_ROOT_NODE_CONTEXT): ZSTRING
		do
			Result := root.string_at_xpath (description_xpath).stripped
		end

	description_xpath: STRING
		do
			Result := Xpath_description
		end

	html_index_path: EL_FILE_PATH
		-- relative path to html index for ECF, and qualified with cluster name when specified in config.pyx
		do
			Result := path.with_new_extension (Html)
		end

	ignored_clusters: like Default_ignored_clusters

	path: EL_FILE_PATH

	type_qualifier: STRING
		do
			Result := Empty_string_8
		end

feature -- Conversion

	normalized: ECF_INFO
		do
			if path.base.has ('#') then
				create {ECF_CLUSTER_INFO} Result.make (Current)
			else
				Result := Current
			end
		end

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@ignore",	agent do create ignored_clusters.make_adjusted_split (node.to_string_8, ';', {EL_STRING_ADJUST}.Left) end],
				["text()",	agent do path := node.to_string end]
			>>)
		end

feature {NONE} -- Constants

	Default_ignored_clusters: EL_STRING_8_LIST
		once
			create Result.make_empty
		end

	Html: ZSTRING
		once
			Result := "html"
		end

	Xpath_cluster: STRING = "/system/target/cluster"

	Xpath_selected_cluster: ZSTRING
		once
			Result := "/system/target/cluster[not (%S)]"
		end

	Name_equals: ZSTRING
		once
			Result := " or @name='%S'"
		end

	Xpath_description: STRING = "/system/description"

end