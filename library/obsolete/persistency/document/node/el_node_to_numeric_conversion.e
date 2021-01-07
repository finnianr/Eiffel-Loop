note
	description: "Conversion routines of document node to types conforming to `NUMERIC'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-22 17:25:32 GMT (Tuesday 22nd December 2020)"
	revision: "3"

deferred class
	EL_NODE_TO_NUMERIC_CONVERSION

feature -- Numeric conversion

	to_integer: INTEGER
			--
		require else
			valid_node: is_integer
		do
			Result := raw_content.to_integer
		end

	to_integer_8: INTEGER_8
			--
		require else
			valid_node: is_integer
		do
			Result := raw_content.to_integer_8
		end

	to_integer_16: INTEGER_16
			--
		require else
			valid_node: is_integer
		do
			Result := raw_content.to_integer_16
		end

	to_natural_8: NATURAL_8
			--
		require else
			valid_node: is_natural
		do
			Result := raw_content.to_natural_8
		end

	to_natural_16: NATURAL_16
			--
		require else
			valid_node: is_natural
		do
			Result := raw_content.to_natural_16
		end

	to_natural: NATURAL
			--
		require else
			valid_node: is_natural
		do
			Result := raw_content.to_natural
		end

	to_natural_64: NATURAL_64
			--
		require else
			valid_node: is_natural_64
		do
			Result := raw_content.to_natural_64
		end

	to_integer_64: INTEGER_64
			--
		require else
			valid_node: is_integer_64
		do
			Result := raw_content.to_integer_64
		end

	to_real: REAL
			--
		require else
			valid_node: is_real
		do
			Result := raw_content.to_real
		end

	to_double: DOUBLE
			--
		require else
			valid_node: is_double
		do
			Result := raw_content.to_double
		end

feature -- Status query

	is_natural: BOOLEAN
			--
		do
			Result := raw_content.is_natural
		end

	is_natural_64: BOOLEAN
			--
		do
			Result := raw_content.is_natural_64
		end

	is_integer: BOOLEAN
			--
		do
			Result := raw_content.is_integer
		end

	is_integer_64: BOOLEAN
			--
		do
			Result := raw_content.is_integer_64
		end

	is_real: BOOLEAN
			--
		do
			Result := raw_content.is_real
		end

	is_double: BOOLEAN
			--
		do
			Result := raw_content.is_double
		end

feature {NONE} -- Implementation	

	raw_content: STRING_32
		deferred
		end

end