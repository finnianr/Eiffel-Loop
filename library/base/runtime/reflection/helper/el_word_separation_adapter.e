note
	description: "Adapt Eiffel identifiers to other word separation conventions and vice-versa"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-24 10:22:51 GMT (Friday 24th January 2020)"
	revision: "4"

deferred class
	EL_WORD_SEPARATION_ADAPTER

inherit
	EL_MODULE_NAMING

feature {NONE} -- Name exporting

	to_lower_snake_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := name_in
			if keeping_ref then
				Result := Result.twin
			end
		end

	to_camel_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			Naming.to_camel_case (name_in, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

	to_english (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			export_to_english (name_in, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

	to_kebab_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			Naming.to_kebab_case (name_in, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

	to_kebab_lower_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			Naming.to_kebab_lower_case (name_in, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

	to_upper_camel_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			Naming.to_upper_camel_case (name_in, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

	to_upper_snake_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			Naming.to_upper_snake_case (name_in, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

feature {NONE} -- Name importing

	from_camel_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			Naming.from_camel_case (name_in, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

	from_kebab_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			Naming.from_kebab_case (name_in, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

	from_upper_camel_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			import_from_upper_camel_case (name_in, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

	from_upper_snake_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			Naming.from_upper_snake_case (name_in, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

	from_lower_snake_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := name_in
			if keeping_ref then
				Result := Result.twin
			end
		end

feature {NONE} -- Implementation

	export_to_english (name_in, english_out: STRING)
		do
			Naming.to_english (name_in, english_out, Naming.no_words)
		end

	import_from_upper_camel_case (name_in, a_name_out: STRING)
		-- redefine in descendant to change `boundary_hints' in 3rd argument to
		-- `from_upper_camel_case'
		do
			Naming.from_upper_camel_case (name_in, a_name_out, Naming.no_words)
		end

	empty_name_out: STRING
		do
			Result := Once_name_out
			Result.wipe_out
		end

feature {NONE} -- Constants

	Once_name_out: STRING
		once
			create Result.make (30)
		end

end
