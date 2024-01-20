note
	description: "[
		${GROUPED_ECF_LINES} for **cluster** tag that maps to a named sub-directory of parent cluster
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	SUB_CLUSTERS_ECF_LINES

inherit
	CLUSTER_TREE_ECF_LINES
		redefine
			adjust_value, Template
		end

create
	make

feature {NONE} -- Implementation

	adjust_value (value: STRING)
		local
			s: EL_STRING_8_ROUTINES
		do
			s.remove_double_quote (value)
		end

feature {NONE} -- Constants

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				$ELEMENT:
					name = $NAME; location = "%$|$VALUE"
			]"
		end

end