note
	description: "ECF project name information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-13 11:52:08 GMT (Thursday 13th February 2020)"
	revision: "3"

class
	ECF_CLUSTER_INFO

inherit
	ECF_INFO
		rename
			make as make_default
		redefine
			cluster_xpath, description, description_xpath
		end

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (ecf: ECF_INFO)
			--
		require
			valid_format: ecf.is_cluster
		local
			parts: LIST [ZSTRING]
		do
			make_default
			parts := ecf.path.base.split ('#')
			name := parts.last
			if parts.count > 1 and then name.ends_with (character_string ('*')) then
				has_wildcard := True
				name.remove_tail (1)
			end
			path.set_parent_path (ecf.path.parent)
			path.set_base (parts.first)
		end

feature -- Access

	cluster_xpath: STRING
		do
			if has_wildcard then
				Result := Selected_cluster_starts_with #$ [Xpath_cluster, name]
			else
				Result := Selected_cluster #$ [Xpath_cluster, name]
			end
		end

	description: ZSTRING
		local
			word_list: EL_ZSTRING_LIST
		do
			create word_list.make_with_separator (name, '_', False)
			Result := word_list.joined_propercase_words
		end

	description_xpath: STRING
		do
			Result := cluster_xpath + once "/description"
		end

	name: ZSTRING

feature -- Status query

	has_wildcard: BOOLEAN

feature {NONE} -- Constants

	Selected_cluster_starts_with: ZSTRING
		once
			Result := "%S[starts-with (@name, '%S')]"
		end

	Selected_cluster: ZSTRING
		once
			Result := "%S[@name='%S']"
		end

end
