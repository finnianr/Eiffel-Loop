note
	description: "Adapt Eiffel identifiers to other word separation conventions and vice-versa"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-11 8:09:07 GMT (Friday 11th May 2018)"
	revision: "3"

deferred class
	EL_WORD_SEPARATION_ADAPTER

inherit
	EL_MODULE_NAMING

feature -- Unimplemented

	export_name (name_in: STRING; keeping_ref: BOOLEAN): STRING
		-- rename in descendant to procedure exporting identifiers to a foreign word separation convention.
		--  `export_default' means that external names already follow the Eiffel convention
		deferred
		end

	import_name (name_in: STRING; keeping_ref: BOOLEAN): STRING
		-- rename in descendant to procedure importing identifiers using a foreign word separation convention.
		--  `import_default' means the external name already follows the Eiffel convention
		deferred
		end

feature {NONE} -- Name exporting

	export_default, to_lower_snake_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
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

	import_default, from_lower_snake_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
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
