note
	description: "Reflected field of type ${TIME}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:23:32 GMT (Monday 28th April 2025)"
	revision: "25"

class
	EL_REFLECTED_TIME

inherit
	EL_REFLECTED_TEMPORAL [TIME]
		rename
			valid_string as valid_format
		redefine
			are_equal, new_factory, reset, set_from_memory, set_from_string, write, valid_format
		end

	EL_TIME_ROUTINES
		export
			{NONE} all
		undefine
			is_equal
		end

create
	make

feature -- Basic operations

	reset (object: ANY)
		do
			if attached value (object) as time then
				time.copy (time.origin)
			end
		end

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (object) as time then
				set_from_compact_decimal (time, read_compressed_time (memory))
			end
		end

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		do
			if attached value (object) as time then
				time.make_from_string_default (Buffer_8.copied_general (string))
			end
		end

	write (object: ANY; writable: EL_WRITABLE)
		do
			if attached value (object) as time then
				write_compressed_time (time, writable)
			end
		end

feature -- Comparison

	are_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		do
			if attached value (a_current) as t1 then
				if attached value (other) as t2 then
					Result := same_time (t1, t2)
				end
			else
--				Both void
				Result := not attached value (other)
			end
		end

feature -- Contract Support

	valid_format (object: ANY; string: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached value (object) as time then
				Result := time.time_valid (Buffer_8.copied_general (string), time.default_format_string)
			end
		end

feature {NONE} -- Implementation

	new_factory: detachable EL_FACTORY [TIME]
		do
			if attached {EL_FACTORY [TIME]} Time_factory.new_item_factory (type_id) as f then
				Result := f
			else
				Result := Precursor
			end
		end

	upgraded (time: TIME): EL_TIME
		-- upgrade `TIME' to `EL_TIME'
		do
			Result := EL_time
			Result.make_by_fine_seconds (time.fine_seconds)
		end

feature {NONE} -- Constants

	EL_time: EL_TIME
		once
			create Result.make (0, 0, 0)
		end

end