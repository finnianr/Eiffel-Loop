note
	description: "ECF project name information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-19 16:50:53 GMT (Wednesday 19th December 2018)"
	revision: "1"

class
	ECF_CLUSTER_INFO

inherit
	ECF_INFO
		redefine
			make, cluster_xpath, description, description_xpath
		end

create
	make

feature {NONE} -- Initialization

	make (a_path: EL_FILE_PATH)
			--
		require else
			valid_format: a_path.base.has ('#')
		local
			parts: LIST [ZSTRING]
		do
			parts := a_path.base.split ('#')
			name := parts.last
			a_path.set_base (parts.first)
			Precursor (a_path)
		end

feature -- Access

	name: ZSTRING

	cluster_xpath: STRING
		do
			Result := Selected_cluster #$ [Xpath_cluster, name]
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

feature {NONE} -- Constants

	Selected_cluster: ZSTRING
		once
			Result := "%S[@name='%S']"
		end

end
