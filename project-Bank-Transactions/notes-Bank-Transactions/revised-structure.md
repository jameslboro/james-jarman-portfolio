	Exploratory Analysis of Bank Transactions and Anomaly Detection
		Introduction & Objective
				Objective
				Why This Matters
				About the Dataset
				Key Questions to Explore
				Tools & Technologies
		Import Libraries
		Data Loading & Initial Inspection
			read the CSV
			.info()
			object > datetime conversion
			missing value check
			duplicate check
			duplicate check (key features)
			list unique values
			inspect certain unique values
			object > category conversion
			.describe()
		Cleaning
			location formatting check
			IP address formatting check
			create 'TransactionHour' column
			create 'DaysBetweenTransactions' column
			create 'high_value_threshold' + 'IsHighValueTransaction' column
		Exloratory Data Analysis (EDA)
			
		Question 1. What are the typical transaction patterns across users? (time, channel, type)
		Question 2. Are there differences in behaviour based on customer age or occupation?
		Question 3. How do users interact with different devices, channels, and locations?
		Question4. Are there transactions that appear suspicious based on volume, time, or user behaviour? (Can we derive any simple rule-based indicators that may help detect anomalies?)


Current list of visualisations:
- Overview of Transactions
	- Distribution of Transaction Amounts
	- Daily Transaction Volume with 7-Day Moving Average
	- Weekly Average Transaction Amount
	- Credit vs Debit Volume
	- High Value Transactions Over Time
- Temporal Patterns
	- Transaction Volume by Day of the Week
	- Transaction Volume by Hour of the Day
	- Transaction Volume on Mondays
	- Transaction Volume on Non-Weekend Days
- User Demographics
	- Transaction Volume by Age Group
	- Transaction Volume by Age Group and Channel
	- Average Transaction Amount by Occupation
	- Transaction Volume by Occupation and Channel
- Channel & Location Behaviour
	- Transaction Volume by Channel
	- Average Transaction Amount by Channel
	- Transaction Type by Channel
	- Top 10 Cities by Transaction Count
	- Top 10 Cities by Average Transaction Amount