note
	description: "XML element attribute node string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 5:51:23 GMT (Saturday 24th June 2023)"
	revision: "9"

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
	make

feature {NONE} -- Initialization

	make (a_document_dir: DIR_PATH)
			--
		do
			Precursor (a_document_dir)
			create cached_xpath_name.make_filled ('@', 1)
			type := Node_type_attribute
		end

feature -- Access

	xpath_name (keep_ref: BOOLEAN): ZSTRING
		--
		local
			name_count: INTEGER
		do
			name_count := cached_xpath_name.count - 1
			if name_count = 0 then
				cached_xpath_name.append (raw_name)

			elseif name_count /= raw_name.count
				or else not cached_xpath_name.same_characters (raw_name, 1, raw_name.count, 2)
			then
				cached_xpath_name.replace_substring (raw_name, 2, cached_xpath_name.count)
			end

			Result := Buffer
			Result.wipe_out
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

feature {NONE} -- Internal attributes

	cached_xpath_name: EL_UTF_8_STRING

end