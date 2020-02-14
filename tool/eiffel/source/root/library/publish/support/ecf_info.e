note
	description: "ECF project information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-13 13:26:05 GMT (Thursday 13th February 2020)"
	revision: "6"

class
	ECF_INFO

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

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

	description: ZSTRING
		do
			create Result.make_empty
		end

	description_xpath: STRING
		do
			Result := Xpath_description
		end

	ignored_clusters: like Default_ignored_clusters

	path: EL_FILE_PATH

feature -- Status query

	is_cluster: BOOLEAN
		do
			Result := path.base.has ('#')
		end

feature -- Conversion

	normalized: ECF_INFO
		do
			if is_cluster then
				create {ECF_CLUSTER_INFO} Result.make (Current)
			else
				Result := Current
			end
		end

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@ignore",	agent do create ignored_clusters.make_with_separator (node.to_string_8, ';', True) end],
				["text()",	agent do path := node.to_string end]
			>>)
		end

feature {NONE} -- Constants

	Default_ignored_clusters: EL_STRING_8_LIST
		once
			create Result.make_empty
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
