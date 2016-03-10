note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-10 15:48:22 GMT (Sunday 10th May 2015)"
	revision: "4"

class
	EVOLICITY_TOKENS

feature {NONE} -- Keyword tokens

	Keyword_if: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Keyword_then: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Keyword_else: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Keyword_foreach: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Keyword_in: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Keyword_across: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Keyword_as: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Keyword_loop: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Keyword_end: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Keyword_evaluate: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Keyword_include: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

feature {NONE} -- Expression tokens

	Left_bracket: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Right_bracket: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Double_dollor_sign: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Dot_operator: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Comma_sign: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Less_than_operator: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Greater_than_operator: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Not_equal_to_operator: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Equal_to_operator: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Boolean_and_operator: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Boolean_or_operator: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Boolean_not_operator: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Integer_64_constant_token: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Double_constant_token: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Quoted_string: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Template_name_identifier: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

feature {NONE} -- Other tokens

	White_text: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Free_text: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

	Unqualified_name: NATURAL_32
		once ("PROCESS")
			Result := unique_id
		end

feature {NONE} -- Implementation

	unique_id: NATURAL_32
		do
			Next_unique_id.increment
			Result := Next_unique_id.value
		end

feature {NONE} -- Constants

	Next_unique_id: EL_MUTEX_NUMERIC [NATURAL_32]

		once ("PROCESS")
			create Result
		end

end -- class EVOLICITY_TOKENS
