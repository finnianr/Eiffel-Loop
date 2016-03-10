note
	description: "Summary description for {EL_PAYPAL_NVP_VARIABLE_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_PAYPAL_SUB_PARAMETER_LIST

inherit
	EL_HTTP_NAME_VALUE_PARAMETER_LIST
		rename
			make as make_list,
			extend as extend_list
		end

	EL_PAYPAL_VARIABLE_NAME_SEQUENCE
		undefine
			copy, is_equal
		end

feature {NONE} -- Initialization

	make
		do
			make_list (5)
		end

feature -- Element change

	value_extend (value: ASTRING)
		do
			extend (Var_value, value)
		end

	extend (name, value: ASTRING)
		local
			name_value_assignment: ASTRING
		do
			create name_value_assignment.make (name.count + value.count + 1)
			name_value_assignment.append (name)
			name_value_assignment.append_character ('=')
			name_value_assignment.append (value)
			extend_list (create {like item}.make (new_name, name_value_assignment))
		end

feature {NONE} -- Constants

	Var_value: ASTRING
		once
			Result := "value"
		end
end
