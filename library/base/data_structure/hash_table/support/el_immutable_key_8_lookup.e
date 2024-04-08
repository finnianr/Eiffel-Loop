note
	description: "[
		Abstraction for looking up tables with keys of type ${IMMUTABLE_STRING_8} with
		a key conforming to ${READABLE_STRING_GENERAL}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-08 13:34:22 GMT (Monday 8th April 2024)"
	revision: "6"

deferred class
	EL_IMMUTABLE_KEY_8_LOOKUP

inherit
	EL_SHARED_IMMUTABLE_8_MANAGER

	EL_STRING_GENERAL_ROUTINES

feature -- Status query

	found: BOOLEAN
		deferred
		end

	has_immutable (a_key: IMMUTABLE_STRING_8): BOOLEAN
		-- Is there an item in the table with key `a_key'?
		deferred
		end

	has_8 (a_key: READABLE_STRING_8): BOOLEAN
		-- Is there an item in the table with key `a_key'?
		do
			Result := has_immutable (Immutable_8.as_shared (a_key))
		end

	has_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		-- Is there an item in the table with key `a_key'?
		-- If so, set `found_item' to the found item.
		do
			if a_key.is_string_8 then
				Result := has_8 (readable_string_8 (a_key))

			elseif is_zstring (a_key) and then has_immutable (as_zstring (a_key).to_shared_immutable_8) then
				-- works if all the characters are ASCII and is very fast
				Result := True
			else
				Result := has_8 (Key_buffer.to_same (a_key))
			end
		end

feature -- Set found_item

	has_immutable_key (a_key: IMMUTABLE_STRING_8): BOOLEAN
		-- Is there an item in the table with key `a_key'?
		-- If so, set `found_item' to the found item.
		deferred
		end

	has_key_8 (a_key: READABLE_STRING_8): BOOLEAN
		-- Is there an item in the table with key `a_key'?
		-- If so, set `found_item' to the found item.
		do
			Result := has_immutable_key (Immutable_8.as_shared (a_key))
		end

	has_key_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		-- Is there an item in the table with key `a_key'?
		-- If so, set `found_item' to the found item.
		do
			if a_key.is_string_8 then
				Result := has_key_8 (readable_string_8 (a_key))

			elseif is_zstring (a_key) and then has_immutable_key (as_zstring (a_key).to_shared_immutable_8) then
				-- works if all the characters are ASCII and is very fast
				Result := True
			else
				Result := has_key_8 (Key_buffer.to_same (a_key))
			end
		end

feature {NONE} -- Constants

	Key_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end
end