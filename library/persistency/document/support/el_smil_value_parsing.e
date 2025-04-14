note
	description: "SMIL value parsing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-14 7:41:26 GMT (Monday 14th April 2025)"
	revision: "10"

deferred class
	EL_SMIL_VALUE_PARSING

inherit
	EL_STRING_GENERAL_ROUTINES_I

feature {NONE} -- Implementation

	node_as_real_secs: REAL
			-- convert SMIL time formatted with 's' suffix
		require
			node_valid_as_real_secs: is_node_valid_as_real_secs
		do
			Result := super_8 (node.adjusted_8 (False)).substring_to ('s').to_real
		end

	node_as_integer_suffix: INTEGER
		-- Strip numeric suffix from an id. Eg. seq_1 become 1
		do
			Result := super_8 (node.adjusted_8 (False)).substring_to_reversed ('_').to_integer
		end

	node: EL_DOCUMENT_NODE_STRING
			--
		deferred
		end

feature {NONE} -- Status query

	is_node_valid_as_real_secs: BOOLEAN
			-- Is node value string similar to: 15.5s
		do
			Result := super_8 (node.adjusted_8 (False)).substring_to ('s').is_real
		end

end