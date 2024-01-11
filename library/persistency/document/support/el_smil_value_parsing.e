note
	description: "Smil value parsing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-11 14:45:05 GMT (Thursday 11th January 2024)"
	revision: "9"

deferred class
	EL_SMIL_VALUE_PARSING

feature {NONE} -- Implementation

	node_as_real_secs: REAL
			-- convert SMIL time formatted with 's' suffix
		require
			node_valid_as_real_secs: is_node_valid_as_real_secs
		local
			s8: EL_STRING_8_ROUTINES
		do
			Result := s8.substring_to (node.adjusted_8 (False), 's').to_real
		end

	node_as_integer_suffix: INTEGER
			-- Strip numeric suffix from an id
			-- eg. seq_1 become 1
		local
			s8: EL_STRING_8_ROUTINES
		do
			Result := s8.substring_to_reversed (node.adjusted_8 (False), '_').to_integer
		end

	node: EL_DOCUMENT_NODE_STRING
			--
		deferred
		end

feature {NONE} -- Status query

	is_node_valid_as_real_secs: BOOLEAN
			-- Is node value string similar to: 15.5s
		local
			s8: EL_STRING_8_ROUTINES
		do
			Result := s8.substring_to (node.adjusted_8 (False), 's').is_real
		end

end