note
	description: "[
		${GROUPED_ECF_LINES} for **cluster** tag that maps to a named sub-directory of parent cluster
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-31 9:11:38 GMT (Monday 31st March 2025)"
	revision: "4"

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
		do
			super_8 (value).remove_double
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