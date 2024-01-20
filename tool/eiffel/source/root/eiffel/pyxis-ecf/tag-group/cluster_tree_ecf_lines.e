note
	description: "${GROUPED_ECF_LINES} for recursive **cluster** tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "4"

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