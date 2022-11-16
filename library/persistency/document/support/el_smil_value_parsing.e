note
	description: "Smil value parsing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_SMIL_VALUE_PARSING

feature {NONE} -- Implementation

	node_as_real_secs: REAL
			-- convert SMIL time formatted with 's' suffix
		require
			node_valid_as_real_secs: is_node_valid_as_real_secs
		local
			real_secs_string: STRING
		do
			real_secs_string := node.to_string
			if real_secs_string.item (real_secs_string.count).as_lower = 's' then
				real_secs_string.remove_tail (1)
			end
			Result := real_secs_string.to_real
		end

	node_as_integer_suffix: INTEGER
			-- Strip numeric suffix from an id
			-- eg. seq_1 become 1
		local
			Result_string: STRING
		do
			from
				Result_string := node.to_string
			until
				Result_string.is_integer or Result_string.is_empty
			loop
				Result_string.remove_head (1)
			end
			Result := Result_string.to_integer
		end

	node: EL_DOCUMENT_NODE_STRING
			--
		deferred
		end

feature {NONE} -- Status query

	is_node_valid_as_real_secs: BOOLEAN
			-- Is node value string similar to: 15.5s
		local
			real_secs_string: STRING
			last_character: CHARACTER
		do
			real_secs_string := node.to_string
			if not real_secs_string.is_empty then
				last_character := real_secs_string @ real_secs_string.count
				if last_character.as_lower = 's' then
					real_secs_string.remove_tail (1)
				end
				Result := real_secs_string.is_real
			end
		end

end