note
	description: "[$source GROUPED_ECF_LINES] for recursive **cluster** tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 14:46:03 GMT (Wednesday 6th July 2022)"
	revision: "1"

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