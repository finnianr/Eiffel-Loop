note
	description: "[$source GROUPED_ECF_LINES] for recursive **cluster** tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	CLUSTER_TREE_ECF_LINES

inherit
	GROUPED_ECF_LINES
		redefine
			Template
		end

create
	make

feature -- Access

	tag_name: STRING
		do
			Result := Name.cluster
		end

feature {NONE} -- Constants

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				$ELEMENT:
					name = $NAME; location = $VALUE; recursive = true
			]"
		end

end