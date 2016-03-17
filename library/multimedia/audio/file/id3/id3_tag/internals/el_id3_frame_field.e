note
	description: "Summary description for {EL_ID3_FRAME_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 9:24:10 GMT (Wednesday 16th December 2015)"
	revision: "5"

deferred class
	EL_ID3_FRAME_FIELD

inherit
	EL_CPP_OBJECT

	EL_ID3_FIELD_TYPES

feature -- Access

	binary_data: MANAGED_POINTER
			--
		require
			valid_type: type = Type_binary_data
		deferred
		end

	string: ZSTRING
			--
		require
			valid_type: is_string
		deferred
		end

	integer: INTEGER
			--
		require
			valid_type: is_integer
		deferred
		end

	type: INTEGER
			--
		deferred
		ensure
			valid_type: valid_types.has (Result)
		end

	type_name: STRING
		do
			Result := Type_names [type]
		end

feature -- Status query

	is_string: BOOLEAN
		do
			Result := across << Type_description, Type_string_data, Type_language >> as l_type some l_type.item = type end
		end

	is_integer: BOOLEAN
		do
			Result := across << Type_encoding, Type_integer >> as l_type some l_type.item = type end
		end

	is_encoding: BOOLEAN
		do
		end

feature -- Element change

	set_encoding (a_new_encoding: INTEGER)
			--
		deferred
		end

	set_string (str: like string)
			--
		require
			valid_type: is_string
		deferred
		ensure
			is_set: string ~ str
		end

	set_binary_data (data: MANAGED_POINTER)
			--
		require
			valid_type: type = Type_binary_data
		deferred
		ensure
			is_set: data.count > 0 implies data ~ binary_data -- Setting to length 0 does not work on libid3
		end

end
