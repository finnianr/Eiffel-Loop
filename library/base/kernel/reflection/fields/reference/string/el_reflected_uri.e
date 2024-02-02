note
	description: "Reflected uri"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-02 12:20:26 GMT (Friday 2nd February 2024)"
	revision: "17"

class
	EL_REFLECTED_URI [U -> EL_URI create make end]

inherit
	EL_REFLECTED_STRING [EL_URI]
		redefine
			group_type, value_type
		end

	EL_SHARED_STRING_8_CURSOR

create
	make

feature -- Access

	value_type: TYPE [ANY]
		do
			Result := {U}
		end

	group_type: TYPE [ANY]
		do
			Result := {EL_URI}
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as uri then
				uri.wipe_out
			end
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as uri then
				memory.read_into_string_8 (uri)
			end
		end

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		do
			if attached value (a_object) as uri then
				set (a_object, replaced (uri, node.as_string_8 (False)))
			else
				set (a_object, create {like value}.make (node.as_string_8 (False)))
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			if attached value (a_object) as uri then
				uri.wipe_out
				uri.append (readable.read_string_8)
			else
				set (a_object, new_uri (readable.read_string_8))
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			if attached value (a_object) as uri then
				writeable.write_string_8 (uri)
			end
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as uri then
				memory.write_string_8 (uri)
			end
		end

feature {NONE} -- Implementation

	replaced (uri: like value; content: READABLE_STRING_GENERAL): like value
		local
			r: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			Result := uri
			uri.wipe_out
			if content.has_substring (uri.Colon_slash_x2) then
				if attached r.to_ascii_string_8 (content) as ascii_str then
					uri.append (ascii_str)
				else
					uri.append_general (content)
				end
			end
		end

	new_uri (str: READABLE_STRING_8): U
		do
			create Result.make (str)
		end

	strict_type_id: INTEGER
		-- type that matches generator name suffix EL_REFLECTED_*
		do
			Result := ({EL_URI}).type_id
		end

end