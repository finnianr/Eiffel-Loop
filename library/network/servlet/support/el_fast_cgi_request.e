note
	description: "Summary description for {EL_FAST_CGI_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_FAST_CGI_REQUEST

inherit
	GOA_FAST_CGI_REQUEST
		redefine
			make, end_request
		end

	GOA_CGI_VARIABLES
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			end_request_action := agent do_nothing
		end

feature -- Access

	path_info: ASTRING
		do
			create Result.make_from_utf8 (parameters.item (Path_info_var))
			Result.prune_all_leading ('/')
		end

feature -- Element change

	set_end_request_action (a_end_request_action: like end_request_action)
		do
			end_request_action := a_end_request_action
		end

feature {NONE} -- Implementation

	end_request
		do
			Precursor
			if write_ok then
				end_request_action.apply
				end_request_action := agent do_nothing
			end
		end

	end_request_action: PROCEDURE [ANY, TUPLE]
		-- action called on successful write of servlet response

end
