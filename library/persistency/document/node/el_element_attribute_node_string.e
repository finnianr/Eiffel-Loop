note
	description: "XML element attribute node string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 15:39:20 GMT (Friday 8th January 2021)"
	revision: "2"

class
	EL_ELEMENT_ATTRIBUTE_NODE_STRING

inherit
	EL_DOCUMENT_NODE_STRING
		export
			{NONE} set_type
		redefine
			make, xpath_name
		end

create
	make_empty

feature {NONE} -- Initialization

	make (n: INTEGER)
			--
		do
			Precursor (n)
			create cached_xpath_name.make_filled ('@', 1)
			type := Node_type_attribute
		end

feature -- Access

	xpath_name (keep_ref: BOOLEAN): ZSTRING
		--
		do
			if cached_xpath_name.count = 1 then
				cached_xpath_name.append (raw_name)

			elseif not cached_xpath_name.same_characters (raw_name, 1, raw_name.count, 2) then
				cached_xpath_name.replace_substring (raw_name, 2, cached_xpath_name.count)
			end

			Result := buffer.empty
			if encoded_as_utf (8) then
				Result.append_utf_8 (cached_xpath_name)
			else
				Result.append_string_general (cached_xpath_name)
			end
			if keep_ref then
				Result := Result.twin
			end
		ensure then
			valid: Result.count = name.count + 1 and then Result.ends_with (name)
		end

feature {NONE} -- Implementation

	cached_xpath_name: EL_UTF_8_STRING

end