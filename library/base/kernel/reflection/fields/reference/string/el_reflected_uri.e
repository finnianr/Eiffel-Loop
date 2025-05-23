note
	description: "Reflected uri"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:22:59 GMT (Monday 28th April 2025)"
	revision: "20"

class
	EL_REFLECTED_URI [U -> EL_URI create make end]

inherit
	EL_REFLECTED_STRING [EL_URI]
		redefine
			group_type, value_type
		end

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

	reset (object: ANY)
		do
			if attached value (object) as uri then
				uri.wipe_out
			end
		end

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (object) as uri then
				memory.read_into_string_8 (uri)
			end
		end

	set_from_node (object: ANY; node: EL_STRING_NODE)
		do
			if attached value (object) as uri then
				set (object, replaced (uri, node.as_string_8 (False)))
			else
				set (object, create {like value}.make (node.as_string_8 (False)))
			end
		end

	set_from_readable (object: ANY; readable: EL_READABLE)
		do
			if attached value (object) as uri then
				uri.wipe_out
				uri.append (readable.read_string_8)
			else
				set (object, new_uri (readable.read_string_8))
			end
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			if attached value (object) as uri then
				writeable.write_string_8 (uri)
			end
		end

	write_to_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (object) as uri then
				memory.write_string_8 (uri)
			end
		end

feature {NONE} -- Implementation

	replaced (uri: like value; content: READABLE_STRING_GENERAL): like value
		do
			Result := uri
			uri.wipe_out
			if content.has_substring (uri.Colon_slash_x2) then
				if attached to_ascii_string_8 (content) as ascii_str then
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