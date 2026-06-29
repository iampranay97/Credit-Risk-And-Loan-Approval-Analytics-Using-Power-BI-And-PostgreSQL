create table internal_bank_data (
	prospectid int primary key,
	total_tl int,
	tot_closed_tl int,
	tot_active_tl int,
	total_tl_opened_l6m int,
	tot_tl_closed_l6m int,
    pct_tl_open_l6m numeric,
    pct_tl_closed_l6m numeric,
    pct_active_tl numeric,
    pct_closed_tl numeric,
    total_tl_opened_l12m int,
    tot_tl_closed_l12m int,
    pct_tl_open_l12m numeric,
    pct_tl_closed_l12m numeric,
    tot_missed_pmnt int,
    auto_tl int,
    cc_tl int,
    consumer_tl int,
    gold_tl int,
    home_tl int,
    pl_tl int,
    secured_tl int,
    unsecured_tl int,
    other_tl int,
    age_oldest_tl int,
    age_newest_tl int
);

copy internal_bank_data
from 'C:\SQL + PowerBI Project\Internal_Bank_Dataset.csv'
delimiter ','
csv header;

CREATE TABLE external_cibil_data (
    prospectid int primary key,
    time_since_recent_payment numeric,
    time_since_first_deliquency numeric,
    time_since_recent_deliquency numeric,
    num_times_delinquent numeric,
    max_delinquency_level numeric,
    max_recent_level_of_deliq numeric,
    num_deliq_6mts numeric,
    num_deliq_12mts numeric,
    num_deliq_6_12mts numeric,
    max_deliq_6mts numeric,
    max_deliq_12mts numeric,
    num_times_30p_dpd numeric,
    num_times_60p_dpd numeric,
    num_std numeric,
    num_std_6mts numeric,
    num_std_12mts numeric,
    num_sub numeric,
    num_sub_6mts numeric,
    num_sub_12mts numeric,
    num_dbt numeric,
    num_dbt_6mts numeric,
    num_dbt_12mts numeric,
    num_lss numeric,
    num_lss_6mts numeric,
    num_lss_12mts numeric,
    recent_level_of_deliq numeric,
    tot_enq numeric,
    cc_enq numeric,
    cc_enq_l6m numeric,
    cc_enq_l12m numeric,
    pl_enq numeric,
    pl_enq_l6m numeric,
    pl_enq_l12m numeric,
    time_since_recent_enq numeric,
    enq_l12m numeric,
    enq_l6m numeric,
    enq_l3m numeric,
    maritalstatus varchar(50),
    education varchar(100),
    age int,
    gender varchar(20),
    netmonthlyincome numeric,
    time_with_curr_empr numeric,
    pct_of_active_tls_ever numeric,
    pct_opened_tls_l6m_of_l12m numeric,
    pct_currentbal_all_tl numeric,
    cc_utilization numeric,
    cc_flag varchar(20),
    pl_utilization numeric,
    pl_flag varchar(20),
    pct_pl_enq_l6m_of_l12m numeric,
    pct_cc_enq_l6m_of_l12m numeric,
    pct_pl_enq_l6m_of_ever numeric,
    pct_cc_enq_l6m_of_ever numeric,
    max_unsec_exposure_inpct numeric,
    hl_flag varchar(20),
    gl_flag varchar(20),
    last_prod_enq2 varchar(100),
    first_prod_enq2 varchar(100),
    credit_score int,
    approved_flag varchar(20)
);

copy external_cibil_data
from 'C:\SQL + PowerBI Project\External_Cibil_Dataset.csv'
delimiter ','
csv header;

--- Step 1 - Data Loading & Validation ---

select count(*) as internal_bank_records
from internal_bank_data;

select count(*) as total_external_records
from external_cibil_data;

select count(distinct prospectid)
from internal_bank_data;

select count(distinct prospectid)
from external_cibil_data;

select * from internal_bank_data
limit 5;

select * from external_cibil_data
limit 5;

select *
from internal_bank_data i
join external_cibil_data e
on i.prospectid = e.prospectid;

-- Step 1.1 - Data Quanlity Check
-- 1. Missing Values In Credit Score
select count(*)
from external_cibil_data
where credit_score = -99999;

-- 2. Missing Values In Monthly Income
select count(*)
from external_cibil_data
where netmonthlyincome = -99999;

-- 3. Missing Values In Recent Payment
select count(*)
from external_cibil_data
where time_since_recent_payment = -99999;

-- 4. Missing Values In CC Utilization
select count(*)
from external_cibil_data
where cc_utilization = -99999;

-- 5. Missing Values In PL Utilization
select count(*)
from external_cibil_data
where pl_utilization = -99999;

--- Step 2 - Customer Demographics Analysis ---

-- Step 2.1 - Age Distribution
select min(age) as minimum_age,
	   max(age) as maximum_age,
	   round(avg(age),2) as average_age
from external_cibil_data;

-- Step 2.2 - Gender Distribution
select gender, count(*) as total_customers
from external_cibil_data
group by gender
order by total_customers desc;

-- Step 2.3 - Gender Percentage Share
select gender, count(*) as total_customers,
round(count(*) * 100 /
(select count(*) from external_cibil_data), 2
) as percentage_share
from external_cibil_data
group by gender
order by percentage_share desc;

-- Step 2.4 - Marital Status Distribution
select maritalstatus, count(*) as total_customers
from external_cibil_data
group by maritalstatus
order by total_customers desc;

-- Step 2.5 Education Distribution
select education, count(*) as total_customers
from external_cibil_data
group by education
order by total_customers desc;

-- step 2.6 Income Analysis
select min(netmonthlyincome) as minimum_income,
	   max(netmonthlyincome) as maximum_income,
	   round(avg(netmonthlyincome), 2) as average_income
from external_cibil_data;

select count(*) as zero_income_customers
from external_cibil_data
where netmonthlyincome = 0;

-- Step 2.7 Loan Approval Distribution
select approved_flag, count(*) as total_customers
from external_cibil_data
group by approved_flag
order by total_customers desc;

--- Step 3 - Credit Score Analysis ---

-- Step 3.1 - Credit Score Summary
select min(credit_score) as monthly_credit_score,
       max(credit_score) as maximum_credit_score,
	   round(avg(credit_score), 2) as average_credit_score
from external_cibil_data;

-- Step 3.2 - Average Credit Score By Approval Flag
select approved_flag, 
	   round(avg(credit_score),2) as avg_credit_score
from external_cibil_data
group by approved_flag
order by avg_credit_score desc;

-- Step 3.3 - Approval Category Distribution
select approved_flag, count(*) as total_customers,
	   round(count(*) * 100 /
	   (select count(*) from external_cibil_data), 2
) as percentage_share
from external_cibil_data
group by approved_flag
order by percentage_share desc;

-- Step 3.4 - Credit Score Bands
select
	case
		when credit_score < 600 then 'poor'
		when credit_score between 600 and 699 then 'fair'
		when credit_score between 700 and 749 then 'good'
		else 'excellent'
	end as credit_score_band,
	count(*) as total_customers
	from external_cibil_data
	group by credit_score_band
	order by total_customers desc;

-- Step 3.5 - Credit Score Band Percentage
select
	case
		when credit_score < 600 then 'poor'
		when credit_score between 600 and 699 then 'fair'
		when credit_score between 700 and 749 then 'good'
		else 'excellent'
	end as credit_score_band,
	count(*) as total_customers,
	round(count(*) * 100 /
	(select count(*) from external_cibil_data), 2
	) as percentage_share
	from external_cibil_data
	group by credit_score_band
	order by percentage_share desc;

-- Step 3.6 - Top 10 Highest Credit Scores
select prospectid, credit_score, approved_flag
from external_cibil_data
order by credit_score desc
limit 10;

--- Step 4 - Loan Portfolio Analysis ---

-- Step 4.1 - Loan Portfolio Summary
select sum(total_tl) as total_loan_accounts,
	   sum(tot_active_tl) as total_active_loans,
	   sum(tot_closed_tl) as total_closed_loans,
	   round(avg(total_tl),2) as avg_loans_per_customer
from internal_bank_data;

-- Step 4.2 - Active vs Closed Loan Percentage
select round(sum(tot_active_tl) * 100 /
	         sum(total_tl), 2
		) as active_loan_percentage,

		round(sum(tot_closed_tl) * 100 /
			  sum(total_tl), 2
		) as closed_loan_percentage
from internal_bank_data;

-- Step 4.3 - Loan Type Distribution
select 'Auto Loan' as loan_type, sum(auto_tl) as total_accounts
from internal_bank_data
union all
select 'Credit Card Loan', sum(cc_tl) from internal_bank_data
union all
select 'Consumer Loan', sum(consumer_tl) from internal_bank_data
union all
select 'Gold Loan', sum(gold_tl) from internal_bank_data
union all
select 'Home Loan', sum(home_tl) from internal_bank_data
union all
select 'Personal Loan', sum(pl_tl) from internal_bank_data
order by total_accounts desc;

-- Step 4.4 - Secured vs Unsecured Loans
select sum(secured_tl) as total_secured_loans,
	   sum(unsecured_tl) as total_unsecured_loans
from internal_bank_data;

-- Step 4.5 - Average Active Loans Per Customer
select round(avg(tot_active_tl),2) as average_active_loans
from internal_bank_data;

-- Step 4.6 - Customer With more than 10 Loan Accounts
select count(*) as customers_with_10_plus_loans
from internal_bank_data
where total_tl > 10;

-- Step 4.7 - Top 10 Customers With Highest Loan Accounts
select prospectid, total_tl, tot_active_tl, tot_closed_tl
from internal_bank_data
order by total_tl desc
limit 10;

-- Step 4.8 - Average Missed Payments
select min(tot_missed_pmnt) as minimum_missed_payments,
	   max(tot_missed_pmnt) as maximum_missed_payments,
	   round(avg(tot_missed_pmnt),2) as average_missed_paymnets
from internal_bank_data;

--- Step 5 - Loan Approval Analysis ---

--Step 5.1 - Average Credit Score By Approval Flag
select approved_flag, round(avg(credit_score), 2) as average_credit_score
from external_cibil_data
group by approved_flag
order by average_credit_score desc;

-- Step 5.2 - Average Income By Approval Flag
select approved_flag, round(avg(netmonthlyincome), 2) as avg_income
from external_cibil_data
group by approved_flag
order by avg_income desc;

-- Step 5.3 - Age By Approval Flag
select approved_flag, round(avg(age), 2) as avg_age
from external_cibil_data
group by approved_flag
order by avg_age desc;

-- Step 5.4 - Average Missed Payments By Approval Flag
select e.approved_flag, 
       round(avg(i.tot_missed_pmnt), 2) as avg_missed_payments
from internal_bank_data i
join external_cibil_data e
on i.prospectid = e.prospectid
group by e.approved_flag
order by avg_missed_payments desc;

-- Step 5.5 - Average Active Loans By Approval
select e.approved_flag,
	   round(avg(i.tot_active_tl), 2) as avg_active_loans
from internal_bank_data i
join external_cibil_data e
on i.prospectid = e.prospectid
group by e.approved_flag
order by avg_active_loans desc;

-- Step 5.6 - Education vs Approval Flag
select education, approved_flag, count(*) as total_customers
from external_cibil_data
group by education, approved_flag
order by education, total_customers desc;

-- Step 5.7 - Marital Status vs Approval Flag
select maritalstatus, approved_flag, count(*) as total_customers
from external_cibil_data
group by maritalstatus, approved_flag
order by maritalstatus, total_customers desc;

--- Step 6 - Income & Customer Profile Analysis ---

-- Step 6.1 - Income Summary
select min(netmonthlyincome) as minimum_income,
	   max(netmonthlyincome) as maximum_income,
	   round(avg(netmonthlyincome), 2) as avg_income
from external_cibil_data;

-- Step 6.2 - Average Income By Gender
select gender, round(avg(netmonthlyincome), 2) as avg_income
from external_cibil_data
group by gender
order by avg_income desc;

-- Step 6.3 - Average Income By Marital Status
select maritalstatus, round(avg(netmonthlyincome), 2) as avg_income
from external_cibil_data
group by maritalstatus
order by avg_income desc;

-- Step 6.4 - Average Income By Education
select education, round(avg(netmonthlyincome), 2) as avg_income
from external_cibil_data
group by education
order by avg_income desc;

-- Step 6.5 - Top 10 Highest Income Customers
select prospectid, netmonthlyincome, credit_score, approved_flag
from external_cibil_data
order by netmonthlyincome desc
limit 10;

-- Step 6.6 - Income Category Distribution
select
	case
		when netmonthlyincome < 20000 then 'Low Income'
		when netmonthlyincome between 20000 and 50000 then 'Middle Income'
		else 'High Income'
	end as income_category,
	count(*) as total_customers
from external_cibil_data
group by income_category
order by total_customers desc;

-- Step 6.7 - Income Category Percentage
select
	case
		when netmonthlyincome < 20000 then 'Low Income'
		when netmonthlyincome between 20000 and 50000 then 'Middle Income'
		else 'High Income'
	end as income_category,
	count(*) as total_customers,
	round(count(*) * 100 /
		  (select count(*) from external_cibil_data), 2
	) as percentage_share
	from external_cibil_data
	group by income_category
	order by percentage_share desc;

-- Step 6.8 - Average Credit Score By Income
select
	case
		when netmonthlyincome < 20000 then 'Low Income'
		when netmonthlyincome between 20000 and 50000 then 'Middle Income'
		else 'High Income'
	end as income_category,
	round(avg(credit_score), 2) as avg_credit_score
	from external_cibil_data
	group by income_category
	order by avg_credit_score desc;

--- Step 7 - Delinquency & Credit Risk Analysis ---

-- Step 7.1 - Delinquent Customers
select count(*) as delinquent_customers
from external_cibil_data
where num_times_delinquent > 0;

-- Step 7.2 - Delinquent Customer Percentage
select count(*) as delinquent_customers,
	   round(count(*) * 100 /
	   (select count(*) from external_cibil_data), 2
	   ) as percentage_share
from external_cibil_data
where num_times_delinquent > 0;

-- Step 7.3 - Average Delinquency By Approval Flag
select approved_flag, 
       round(avg(num_times_delinquent), 2) as avg_delinquency
from external_cibil_data
group by approved_flag
order by avg_delinquency desc;

-- Step 7.4 - Averaged Missed Payments By Credit Score Band
select
	case
		when credit_score < 600 then 'Poor'
		when credit_score between 600 and 699 then 'Fair'
		when credit_score between 700 and 749 then 'Good'
		else 'Excellent'
	end as credit_score_band,
	round(avg(i.tot_missed_pmnt), 2) as avg_missed_payments
from external_cibil_data e
join internal_bank_data i
on e.prospectid = i.prospectid
group by credit_score_band
order by avg_missed_payments desc;

-- Step 7.5 - Customers With Missed Payments
select count(*) as customers_with_missed_payments
from internal_bank_data
where tot_missed_pmnt > 0;

-- Step 7.6 - High-Risk Customers
select count(*) as high_risk_customers
from internal_bank_data i
join external_cibil_data e
on i.prospectid = e.prospectid
where e.credit_score < 650
and i.tot_missed_pmnt > 2;

-- Step 7.7 - High-Risk Customer Percentage
select round(count(*) * 100 /
 	   (select count(*) from external_cibil_data), 2
) as high_risk_percentage
from internal_bank_data i
join external_cibil_data e
on i.prospectid = e.prospectid
where e.credit_score < 650
and i.tot_missed_pmnt > 2;

-- Step 7.8 - Approval Category Of High-Risk Customers
select e.approved_flag, count(*) as total_customers
from internal_bank_data i
join external_cibil_data e
on i.prospectid = e.prospectid
where credit_score < 650
and i.tot_missed_pmnt > 2
group by e.approved_flag
order by total_customers desc;

-- Step 7.9 - Top 10 Riskiest Customers
select e.prospectid, e.credit_score, i.tot_missed_pmnt,
	   e.num_times_delinquent, e.approved_flag
from external_cibil_data e
join internal_bank_data i
on e.prospectid = i.prospectid
order by i.tot_missed_pmnt desc, 
         e.num_times_delinquent desc, 
		 e.credit_score asc
limit 10;

--- Step 8 - Customer Segmentation Analysis ---

-- Step 8.1 - Custome Segment By Approval Flag
select approved_flag, count(*) as total_customers,
	   round(count(*) * 100 /
	   (select count(*) from external_cibil_data), 2
	   ) as percentage_share
from external_cibil_data
group by approved_flag
order by total_customers desc;

-- Step 8.2 - Income Segment vs Approval Category
select
	case
		when netmonthlyincome < 20000 then 'Low Income'
		when netmonthlyincome between 20000 and 50000 then 'Middle Income'
		else 'High Income'
	end as income_segment, approved_flag, count(*) as total_customers
from external_cibil_data
group by income_segment, approved_flag
order by income_segment, approved_flag;

-- Step 8.3 - Credit Score Band vs Approval Category
select
	case
		when credit_score < 600 then 'Poor'
		when credit_score between 600 and 699 then 'Fair'
		when credit_score between 700 and 749 then 'Good'
		else 'Excellent'
	end as credit_score_band, approved_flag, count(*) as total_customers
from external_cibil_data
group by credit_score_band, approved_flag
order by credit_score_band, approved_flag;

-- Step 8.4 - Age Group Distribution
select
	case
		when age between 21 and 30 then '21-30'
		when age between 31 and 40 then '31-40'
		when age between 41 and 50 then '41-50'
		else '50+'
	end as age_group, count(*) as total_customers
from external_cibil_data
group by age_group
order by total_customers desc;

-- Step 8.5 - Age Group vs Approval Flag
select
	case
		when age between 21 and 30 then '21-30'
		when age between 31 and 40 then '31-40'
		when age between 41 and 50 then '41-50'
		else '50+'
	end as age_group, count(*) as total_customers
from external_cibil_data
group by age_group, approved_flag
order by age_group, approved_flag;

-- Step 8.6 - Top Customer Profile
select gender, maritalstatus, education, count(*) as total_customers
from external_cibil_data
group by gender, maritalstatus, education
order by total_customers desc
limit 10;

-- Step 8.7 - Best Customer Segment
select count(*) as best_customers
from external_cibil_data
where credit_score >= 750
and netmonthlyincome > 50000;

-- Step 8.8 - Best Customer Percentage
select round(count(*) * 100 /
	   (select count(*) from external_cibil_data), 2
) as best_customer_percentage
from external_cibil_data
where credit_score >= 750
and netmonthlyincome >50000;

--- Step 9 - Executive Summary & Business KPI Dashboard Queries ---

-- Step 9.1 - Total Customers
select count(*) as total_customers from external_cibil_data;

-- Step 9.2 - Total Loan Accounts
select sum(total_tl) as total_loan_accounts
from internal_bank_data;

-- Step 9.3 - Total Active Loans
select sum(tot_active_tl) as total_active_loans
from internal_bank_data;

-- Step 9.4 - Total Closed Loans
select sum(tot_closed_tl) as total_closed_loans
from internal_bank_data;

-- Step 9.5 - Average Credit Score
select round(avg(credit_score), 2) as avg_credit_score
from external_cibil_data;

-- Step 9.6 - Average Monthly Income
select round(avg(netmonthlyincome), 2) as avg_monthly_income
from external_cibil_data;

-- Step 9.7 - Delinquent Customers
select count(*) as delinquent_customers
from external_cibil_data
where num_times_delinquent > 0;

-- Step 9.8 - High-Risk Customers
select count(*) as high_risk_customers
from internal_bank_data i
join external_cibil_data e
on i.prospectid = e.prospectid
where credit_score < 650
and i.tot_missed_pmnt > 2;

-- Step 9.9 - Best Customers
select count(*) as best_customers
from external_cibil_data
where credit_score >= 750
and netmonthlyincome > 50000;

-- Step 9.10 - Approval Portfolio Mix
select approved_flag, count(*) as total_customers,
	   round(count(*) * 100 /
	   (select count(*) from external_cibil_data), 2
	   ) as percentage_share
from external_cibil_data
group by approved_flag
order by total_customers desc;

-- Step 9.11 - Portfolio Health Score
select round((count(case when credit_score >= 700 then 1 end) * 100 /
	   count(*)), 2
) as healthy_customer_percentage
from external_cibil_data;

-- Step 9.12 - Executive KPI Table
select
(select count(*) from external_cibil_data) as total_customers,
(select sum(total_tl) from internal_bank_data) as total_loan_acounts,
(select round(avg(credit_score), 2) 
from external_cibil_data) as avg_credit_score,
(select round(avg(netmonthlyincome), 2) 
from external_cibil_data) as avg_income,
(select count(*) from external_cibil_data
where num_times_delinquent > 0) as delinquent_customers;


------------------------------------------- End -------------------------------------------
