note
	description: "Eiffel library configuration info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-16 17:04:40 GMT (Sunday 16th December 2018)"
	revision: "3"

class
	ECF_INFO

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			cluster := Empty_string
			description_text := Empty_string
			create path
			Precursor
		end

feature -- Access

	cluster: ZSTRING

	cluster_xpath: STRING
		do
			if is_cluster then
				Result := Selected_cluster #$ [Xpath_cluster, cluster]
			else
				Result := Xpath_cluster
			end
		end

	description: ZSTRING
		local
			word_list: EL_ZSTRING_LIST
		do
			if description_text.is_empty then
				create word_list.make_with_separator (cluster, '_', False)
				Result := word_list.joined_propercase_words
			else
				Result := description_text
			end
		end

	path: EL_FILE_PATH

feature -- Status query

	is_cluster: BOOLEAN
		do
			Result := not cluster.is_empty
		end

feature {NONE} -- Internal attributes

	description_text: ZSTRING

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE
		do
			create Result.make (<<
				["@cluster", 	agent do cluster := node.to_string end],
				["description/text()", 	agent do description_text := node.to_string end],
				["text()", agent do path.set_path (node.to_string) end]
			>>)
		end

feature {NONE} -- Constants

	Selected_cluster: ZSTRING
		once
			Result := "%S[@name='%S']"
		end

	Xpath_cluster: STRING = "/system/target/cluster"

end
