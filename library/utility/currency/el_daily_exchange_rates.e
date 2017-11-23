note
	description: "Summary description for {EL_DAILY_EXCHANGE_RATES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_DAILY_EXCHANGE_RATES [RATES -> EL_EXCHANGE_RATE_TABLE create make end]

feature {NONE} -- Initialization

	make
		do
			create date_today.make_now
			update
		end

feature -- Access

	today, yesterday: RATES

feature -- Element change

	check_day
		do
			date_today.make_now
			if date_today > today.date then
				update
			end
		end

feature {NONE} -- Implementation

	update
		local
			date_yesterday: DATE
		do
			date_yesterday := date_today.twin
			date_yesterday.day_back
			create today.make (date_today, Significant_digits)
			create yesterday.make (date_yesterday, Significant_digits)
			if attached {EL_EURO_EXCHANGE_RATE_TABLE} yesterday as euro_table then
				euro_table.clean_up_files
			end
		end

feature {NONE} -- Internal attributes

	date_today: DATE

feature {NONE} -- Constants

	Significant_digits: INTEGER
		once
			Result := 3
		end

end
