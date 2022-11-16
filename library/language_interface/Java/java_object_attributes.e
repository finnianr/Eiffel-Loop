note
	description: "Java object attributes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	JAVA_OBJECT_ATTRIBUTES

inherit
	JAVA_SHARED_ORB

feature {NONE} -- Attributes

	boolean_attribute (fid: POINTER): BOOLEAN
			-- Access to a boolean attribute
		do
			Result := jorb.get_boolean_field (java_object_id, fid)
		end

	byte_attribute (fid: POINTER): INTEGER_8
			-- Access to a 'byte' attribute, returns a INTEGER_8
		do
			Result := jorb.get_byte_field (java_object_id, fid)
		end

	char_attribute (fid: POINTER): CHARACTER
			-- Access to a 'char' attribute
		do
			Result := jorb.get_char_field (java_object_id, fid)
		end

	double_attribute (fid: POINTER): DOUBLE
			-- Access to a double attribute
		do
			Result := jorb.get_double_field (java_object_id, fid)
		end

	float_attribute (fid: POINTER): REAL
			-- Access to a 'float' attribute, returns a REAL
		do
			Result := jorb.get_float_field (java_object_id, fid)
		end

	integer_attribute (fid: POINTER): INTEGER
			-- Access to an integer attribute
		do
			Result := jorb.get_integer_field (java_object_id, fid)
		end

	long_attribute (fid: POINTER): INTEGER_64
			-- Access to a 'long' attribute, returns a INTEGER_64
		do
			Result := jorb.get_long_field (java_object_id, fid)
		end

	object_attribute (fid: POINTER): POINTER
			-- Access to a java object attribute
		do
			Result := jorb.get_object_field (java_object_id, fid)
		end

	short_attribute (fid: POINTER): INTEGER_16
			-- Access to a 'short' attribute, returns a INTEGER_16
		do
			Result := jorb.get_short_field (java_object_id, fid)
		end

	string_attribute (fid: POINTER): STRING
			-- Access to a String attribute
		do
			Result := jorb.get_string_field (java_object_id, fid)
		end

feature {NONE} -- Implementation

	java_object_id: POINTER
		-- Reference to java object.
		deferred
		end
end