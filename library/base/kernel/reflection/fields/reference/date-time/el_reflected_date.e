note
	description: "Reflected field conforming to ${DATE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:23:20 GMT (Monday 28th April 2025)"
	revision: "24"

class
	EL_REFLECTED_DATE

inherit
	EL_REFLECTED_TEMPORAL [DATE]
		redefine
			reset, new_factory, set_from_memory, set_from_string, write
		end

create
	make

feature -- Basic operations

	reset (object: ANY)
		do
			if attached value (object) as date then
				date.copy (date.origin)
			end
		end

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (object) as date then
				date.make_by_ordered_compact_date (memory.read_integer_32)
			end
		end

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		do
			if attached value (object) as date then
				date.make_from_string_default (Buffer_8.copied_general (string))
			end
		end

	write (object: ANY; writable: EL_WRITABLE)
		do
			if attached value (object) as date then
				writable.write_integer_32 (date.ordered_compact_date)
			end
		end

feature -- Contract Support

	valid_format (object: ANY; string: STRING): BOOLEAN
		do
			if attached value (object) as date then
				Result := date.date_valid (string, date.default_format_string)
			end
		end

feature {NONE} -- Implementation

	new_factory: detachable EL_FACTORY [DATE]
		do
			if attached {EL_FACTORY [DATE]} Date_factory.new_item_factory (type_id) as f then
				Result := f
			else
				Result := Precursor
			end
		end

	upgraded (date: DATE): EL_DATE
		-- upgrade `DATE' to `EL_DATE'
		do
			Result := EL_date
			Result.make_by_ordered_compact_date (date.ordered_compact_date)
		end

feature {NONE} -- Constants

	EL_date: EL_DATE
		once
			create Result.make (1, 1, 1)
		end

end