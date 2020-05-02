note
	description: "Adapt Eiffel identifiers to other word separation conventions and vice-versa"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-28 9:28:25 GMT (Tuesday 28th April 2020)"
	revision: "6"

deferred class
	EL_WORD_SEPARATION_ADAPTER

inherit
	EL_MODULE_NAMING

feature {NONE} -- Name exporting

	to_camel_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := camel_case_string (name_in, To_default, keeping_ref)
		end

	to_camel_case_upper (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := camel_case_string (name_in, To_upper, keeping_ref)
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
			Result := kebab_case_string (name_in, To_default, keeping_ref)
		end

	to_kebab_case_lower (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := kebab_case_string (name_in, To_lower, keeping_ref)
		end

	to_kebab_case_upper (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := kebab_case_string (name_in, To_upper, keeping_ref)
		end

	to_snake_case_lower (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := snake_case_string (name_in, To_lower, keeping_ref)
		end

	to_snake_case_upper (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := snake_case_string (name_in, To_upper, keeping_ref)
		end

	to_title (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			export_to_title (name_in, Result)
			if keeping_ref then
				Result := Result.twin
			end
		end

feature {NONE} -- Name importing

	from_camel_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := camel_case_string (name_in, From_default, keeping_ref)
		end

	from_camel_case_upper (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := camel_case_string (name_in, From_upper, keeping_ref)
		end

	from_kebab_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := kebab_case_string (name_in, From_default, keeping_ref)
		end

	from_snake_case_lower (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := snake_case_string (name_in, From_lower, keeping_ref)
		end

	from_snake_case_upper (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := snake_case_string (name_in, From_upper, keeping_ref)
		end

feature {NONE} -- Implementation

	camel_case_string (name_in: STRING; case: INTEGER; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			inspect case
				when From_default then
					Naming.from_camel_case (name_in, Result)

				when From_lower then
					Result.append (name_in)

				when From_upper then
					import_from_camel_case_upper (name_in, Result)

				when To_default then
					Naming.to_camel_case (name_in, Result)

				when To_lower then
					Naming.to_camel_case_lower (name_in, Result)

				when To_upper then
					Naming.to_camel_case_upper (name_in, Result)
			else
				Naming.to_camel_case (name_in, Result)
			end
			if keeping_ref then
				Result := Result.twin
			end
		end

	empty_name_out: STRING
		do
			Result := Once_name_out
			Result.wipe_out
		end

	export_to_english (name_in, english_out: STRING)
		do
			Naming.to_english (name_in, english_out, Naming.no_words)
		end

	export_to_title (name_in, title_out: STRING)
		do
			Naming.to_title (name_in, title_out)
		end

	import_from_camel_case_upper (name_in, a_name_out: STRING)
		-- redefine in descendant to change `boundary_hints' in 3rd argument to
		-- `from_upper_camel_case'
		do
			Naming.from_camel_case_upper (name_in, a_name_out, Naming.no_words)
		end

	kebab_case_string (name_in: STRING; case: INTEGER; keeping_ref: BOOLEAN): STRING
		do
			Result := empty_name_out
			inspect case
				when From_default then
					Naming.from_kebab_case (name_in, Result)

				when To_default then
					Naming.to_kebab_case (name_in, Result)

				when To_upper then
					Naming.to_kebab_case_upper (name_in, Result)

				when To_lower then
					Naming.to_kebab_case_lower (name_in, Result)
			else
				Naming.from_kebab_case (name_in, Result)
			end
			if keeping_ref then
				Result := Result.twin
			end
		end

	snake_case_string (name_in: STRING; case: INTEGER; keeping_ref: BOOLEAN): STRING
		do
			inspect case
				when From_lower, To_default, To_lower then
					Result := name_in
			else
				Result := empty_name_out
				inspect case
					when From_upper then
						Naming.from_snake_case_upper (name_in, Result)
					when To_upper then
						Naming.to_snake_case_upper (name_in, Result)
					when To_lower then
						Naming.to_snake_case_lower (name_in, Result)
				else
					Result := name_in
				end
			end
			if keeping_ref then
				Result := Result.twin
			end
		end

feature {NONE} -- Constants

	From_default: INTEGER = 3

	From_lower: INTEGER = 4

	From_upper: INTEGER = 5

	Once_name_out: STRING
		once
			create Result.make (30)
		end

	To_default: INTEGER = 0

	To_lower: INTEGER = 1

	To_upper: INTEGER = 2

end
