class QueriesController < ApplicationController
	# Get State Abbreviations Hash
	include Variables
	@@State_list = States
	# Get Company Names
	@@names ||= ApplicationRecord.execQuery("select distinct name from camoen.complaint order by name");
	

	def index
		render :layout => "landing_page"
	end

	def dashboard
	end
	
	def query_directory
		@State_list = @@State_list
		#@@names = ApplicationRecord.execQuery("select distinct name from camoen.complaint order by name");
		@names = @@names
		# @names = ApplicationRecord.execQuery("select distinct name from camoen.complaint order by name");
		# Replace above line with below for faster load times during development (if needed)
		# @names = ApplicationRecord.execQuery("select distinct name from camoen.complaint where rownum <= 5 order by name");
	end
	

	def complaint_rankings
		@results = ApplicationRecord.execQuery("select distinct name, type, submitted_via from camoen.complaint where rownum <= 50");
		# @results = c.execute("select * from camoen.complaint where rownum <= 10")
		# while r = @results.fetch()
		# 	puts r.join(',')
		# end
		# @results.close

		
		# results.each do |result|
		#   	puts result[0]
		# end

		# for result in @results
		# 	result.name #|  posting.time | posting.salary 
		# end

		# def index
		#   	@telephone_records = TelephoneRecord.all
		# end
		
	end

	# Forms for Custom User Query
	def create
	 	#@tags = params[:flag]
	end

	def custom_search
		# Custom Search Logic using parameters
		query = "select"
		num = 0
		
		# If company name(s) are selected
		companies = ""
		if (!params[:cname].blank?)
			num = 1
			params[:cname].each do |i|
				if num == 1
					companies += "where (name = '"
				else
					companies += "or name = '"
				end
				companies += @@names[Integer(i[0])]["name"]
				companies += "' "
				num = num + 1
			end
			companies += ") "
			#puts companies
		end

		# If product type is selected
		product = ""
		prodnum = 0
		if (!params[:type].blank?)
		 	if num < 1
		 		product += "where "
		 		num = num + 1
		 	end
			if params[:type].key?("1")
		 		if num > 1
					product += "and "
		 		end
		 		product += "("
				product += "type in (select type from camoen.bank_account) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("2")
		 		if num > 1
		 			if prodnum > 0
		 				product += "or "
		 			else
						product += "and ("
					end
		 		end
				product += "type in (select type from camoen.payday_loan) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("3")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and ("
					end
		 		end
				product += "type in (select type from camoen.credit_card) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("4")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and ("
					end
		 		end
				product += "type in (select type from camoen.credit_reporting) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("5")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and ("
					end
		 		end
				product += "type = 'Debt collection' "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("6")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and ("
					end
		 		end
				product += "type in (select type from camoen.money_transfer) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("7")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and ("
					end
		 		end
				product += "type = 'Mortgage' "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("8")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and ("
					end
		 		end
				product += "type in (select type from camoen.prepaid_card) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("9")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and ("
					end
		 		end
				product += "type = 'Student Loan' "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("10")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and ("
					end
		 		end
				product += "type in (select type from camoen.virtual_currency) "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	if params[:type].key?("11")
		 		if num > 1
					if prodnum > 0
		 				product += "or "
		 			else
						product += "and ("
					end
		 		end
				product += "type = 'Other financial service' "
		 		num = num + 1
		 		prodnum = prodnum + 1
		 	end
		 	product += ") "
			#puts product
		end

		# If demographic is selected
		demo = ""
		demnum = 0
		if (!params[:demo].blank?)
		 	if num < 1
		 		demo += "where "
		 		num = num + 1
		 	end
		 	if params[:demo].key?("1")
		 		if num > 1
					demo += "and "
		 		end
		 		demo += "("
		 		if params[:demo]["1"] == "1"
					demo += "tag like '%Older%' "
			 	else
					demo += "tag not like '%Older%' "
			 	end
			 	num = num + 1
			 	demnum = demnum + 1
		 	end
			if params[:demo].key?("2")
		 		if num > 1
		 			if demnum > 0
		 				demo += "or "
		 			else
						demo += "and ("
					end
		 		end
		 		if params[:demo]["2"] == "1"
					demo += "tag like '%Service%' "
			 	else
					demo += "tag not like '%Service%' "
			 	end
			 	num = num + 1
			 	demnum = demnum + 1
		 	end
		 	if params[:demo].key?("3")
		 		if num > 1
		 			if demnum > 0
		 				demo += "or "
		 			else
						demo += "and ("
					end
		 		end
				demo += "tag is null "
		 		num = num + 1
		 	end
		 	demo += ") "
		 	#puts demo
		end
		# If "Not Older American" and "Not Service Member" are selected
		# but "All Other Demographics" is not selected
		if (!params[:demo].blank?)
			if (params[:demo]["1"] == "2" && params[:demo]["2"] == "2" && !params[:demo].key?("3"))
				num -= 3
				demo = ""
				if num < 1
			 		demo += "where "
			 		num = num + 1
			 	else
			 		demo += "and "
			 	end
				demo += "tag is null "
			end
			# If only "Not Older American" is selected
			# but "All Other Demographics" is not selected
			if (params[:demo]["1"] == "2" && !params[:demo].key?("2") && !params[:demo].key?("3"))
				num -= 2
				demo = ""
				if num < 1
			 		demo += "where "
			 		num = num + 1
			 	else
			 		demo += "and "
			 	end
				demo += "(tag is null or tag not like '%Older%') "
			end
			# If only "Not Service Member" is selected
			# but "All Other Demographics" is not selected
			if (!params[:demo].key?("1") && params[:demo]["2"] == "2" && !params[:demo].key?("3"))
				num -= 2
				demo = ""
				if num < 1
			 		demo += "where "
			 		num = num + 1
			 	else
			 		demo += "and "
			 	end
				demo += "(tag is null or tag not like '%Service%') "
			end
		end

		 # If Submission Method is selected
		submission = ""
		subnum = 0
		if (!params[:sub].blank?)
		 	if num < 1
		 		submission += "where "
		 		num = num + 1
		 	end
			if params[:sub].key?("1")
		 		if num > 1
					submission += "and "
		 		end
				submission += "(submitted_via = 'Email' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	if params[:sub].key?("2")
		 		if num > 1
		 			if subnum > 0
		 				submission += "or "
		 			else
						submission += "and ("
					end
		 		end
				submission += "submitted_via = 'Fax' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	if params[:sub].key?("3")
		 		if num > 1
		 			if subnum > 0
		 				submission += "or "
		 			else
						submission += "and ("
					end
		 		end
				submission += "submitted_via = 'Phone' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	if params[:sub].key?("4")
		 		if num > 1
		 			if subnum > 0
		 				submission += "or "
		 			else
						submission += "and ("
					end
		 		end
				submission += "submitted_via = 'Postal mail' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	if params[:sub].key?("5")
		 		if num > 1
		 			if subnum > 0
		 				submission += "or "
		 			else
						submission += "and ("
					end
		 		end
				submission += "submitted_via = 'Referral' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	if params[:sub].key?("6")
		 		if num > 1
		 			if subnum > 0
		 				submission += "or "
		 			else
						submission += "and ("
					end
		 		end
				submission += "submitted_via = 'Web' "
		 		num = num + 1
		 		subnum = subnum + 1
		 	end
		 	submission += ") "
		 	#puts submission
		end

		# If state(s) are selected
		states = ""
		statenum = 0
		if (!params[:state].blank?)
			if num < 1
		 		submission += "where ("
		 		num = num + 1
		 	end
			params[:state].each do |i|
				if num > 1
					if statenum > 0
						states += "or "
					else
						states += "and ("
					end
				end
				states += "state = '"
				puts i[0]
				puts @@State_list[i[0]]
				states += @@State_list[i[0]]
				states += "' "
				num = num + 1
				statenum = statenum + 1
			end
			states += ") "
			#puts states
		end

		# If date(s) are selected
		dates = ""
		# If both dates are selected
		if (!params[:start_date].blank? && !params[:end_date].blank?)
			if num < 1
		 		dates += "where "
		 	else
		 		dates += "and "
		 	end
		 	num = num + 1
		 	dates += "(date_received between to_date('"
		 	dates += params[:start_date]
		 	dates += "', 'MM/DD/YYYY') and to_date('"
		 	dates += params[:end_date]
		 	dates += "', 'MM/DD/YYYY'))"
		# If only a start date is selected
		elsif (!params[:start_date].blank? && params[:end_date].blank?)
			if num < 1
		 		dates += "where "
		 	else
		 		dates += "and "
		 	end
	 		num = num + 1
		 	dates += "(date_received > to_date('"
		 	dates += params[:start_date]
		 	dates += "', 'MM/DD/YYYY'))"
		# If only an end date is selected
		elsif (params[:start_date].blank? && !params[:end_date].blank?)
			if num < 1
		 		dates += "where "
		 	else
		 		dates += "and "
		 	end
	 		num = num + 1
		 	dates += "(date_received < to_date('"
		 	dates += params[:end_date]
		 	dates += "', 'MM/DD/YYYY'))"
		end


		where = companies + product + demo + submission + states + dates
		query = "select count(*) from camoen.complaint "
		query += where
		puts query
		testing = ApplicationRecord.execQuery(query);
		puts testing

		# If company selected, but not product
		if (!params[:cname].blank? && params[:type].blank?)
			puts "Company selected but not product"

		end

	end

	def product_rankings
	end

	def timeliness_rankings
	end

	def dispute_rankings
	end


end
