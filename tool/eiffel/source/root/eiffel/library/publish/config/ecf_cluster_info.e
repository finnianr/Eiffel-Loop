note
	description: "ECF project name information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 6:10:48 GMT (Thursday 17th August 2023)"
	revision: "17"

class
	ECF_CLUSTER_INFO

inherit
	ECF_INFO
		rename
			make as make_default
		redefine
			cluster_xpath, description, description_xpath, type_qualifier, html_index_path
		end

	EL_CHARACTER_32_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (ecf: ECF_INFO)
			--
		require
			valid_path: ecf.path.base.has ('#')
		do
			make_default
			if attached ecf.path.base.split_list ('#') as parts then
				name := parts.last
				if parts.count > 1 and then name.ends_with_character ('*') then
					has_wildcard := True
					name.remove_tail (1)
				end
				path.set_parent_path (ecf.path.parent)
				path.set_base (parts.first)
			end
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

	description (root: EL_XML_DOC_CONTEXT): ZSTRING
		local
			word_list: EL_ZSTRING_LIST
		do
			Result := Precursor (root)
			if Result.is_empty then
				create word_list.make_split (name, '_')
				Result := word_list.joined_propercase_words
			end
		end

	description_xpath: STRING
		do
			Result := cluster_xpath + once "/description"
		end

	html_index_path: FILE_PATH
		-- relative path to html index for ECF, and qualified with cluster name when specified in config.pyx
		do
			Result := path.with_new_extension (dot.joined (name, Html))
		end

	name: ZSTRING

feature -- Constants

	Type_qualifier: STRING = " cluster"

feature -- Status query

	has_wildcard: BOOLEAN

feature {NONE} -- Constants

	Selected_cluster: ZSTRING
		once
			Result := "%S[@name='%S']"
		end

	Selected_cluster_starts_with: ZSTRING
		once
			Result := "%S[starts-with (@name, '%S')]"
		end

end