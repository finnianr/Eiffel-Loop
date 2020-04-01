note
	description: "Numeric xml node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-01 9:26:52 GMT (Wednesday 1st April 2020)"
	revision: "1"

deferred class
	EL_NUMERIC_XML_NODE

feature -- Numeric conversion

	to_integer: INTEGER
			--
		require else
			valid_node: is_integer
		do
			Result := raw_adjusted.to_integer
		end

	to_integer_8: INTEGER_8
			--
		require else
			valid_node: is_integer
		do
			Result := raw_adjusted.to_integer_8
		end

	to_integer_16: INTEGER_16
			--
		require else
			valid_node: is_integer
		do
			Result := raw_adjusted.to_integer_16
		end

	to_natural_8: NATURAL_8
			--
		require else
			valid_node: is_natural
		do
			Result := raw_adjusted.to_natural_8
		end

	to_natural_16: NATURAL_16
			--
		require else
			valid_node: is_natural
		do
			Result := raw_adjusted.to_natural_16
		end

	to_natural: NATURAL
			--
		require else
			valid_node: is_natural
		do
			Result := raw_adjusted.to_natural
		end

	to_natural_64: NATURAL_64
			--
		require else
			valid_node: is_natural_64
		do
			Result := raw_adjusted.to_natural_64
		end

	to_integer_64: INTEGER_64
			--
		require else
			valid_node: is_integer_64
		do
			Result := raw_adjusted.to_integer_64
		end

	to_real: REAL
			--
		require else
			valid_node: is_real
		do
			Result := raw_adjusted.to_real
		end

	to_double: DOUBLE
			--
		require else
			valid_node: is_double
		do
			Result := raw_adjusted.to_double
		end

feature -- Status query

	is_natural: BOOLEAN
			--
		do
			Result := raw_adjusted.is_natural
		end

	is_natural_64: BOOLEAN
			--
		do
			Result := raw_adjusted.is_natural
		end

	is_integer: BOOLEAN
			--
		do
			Result := raw_adjusted.is_integer
		end

	is_integer_64: BOOLEAN
			--
		do
			Result := raw_adjusted.is_integer_64
		end

	is_real: BOOLEAN
			--
		do
			Result := raw_adjusted.is_real
		end

	is_double: BOOLEAN
			--
		do
			Result := raw_adjusted.is_double
		end

feature {NONE} -- Implementation	

	raw_adjusted: STRING_32
		deferred
		end

end
