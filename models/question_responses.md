# Data Interview Responses - Mark Vaz

This markdown file contains methodology, and responses to the interview questions outlined in the repository

## Foreword

### Schema Structure

I appreciate the opportunity to work on this assignment and showcase my abilities in DBT as well as my thought process when building schemas.

The DBT Project `models` folder was split into three distinct folders for ease of data modeling:
1. `staging`

    The models in this folder reference seed data files, and perform data transformation to ensure data quality and proper formatting of columns and values. The models are all matieralized as views to keep them light weight.

    Example: The columns in the seed files were all uppercase, while DBT and most SQL instances can decipher between uppercase and lowercase, some databases can be case sensitive, so from this point forward all names were changed to snake_case format.
2. `int`

    The models in this folder apply business logic to the data, no aggregations in this layer and the tables stay in a wide format, still matieralized as a view. These models can be used by BI professionals who want to do the majority of their aggregations in the BI tool.

    Example: Creating a new column that indicates whether a transaction_id is considered open at a given point of transition.
3. `mart`

    The models in this folder begins to answer business questions, applying aggregations when needed. These models are matieralized as tables for speed when using visualiztion tools such as Tableau or Omni. These models answer specific business questions while the models in the int folder can be used for broader visualizations.


### Documentation

I am true believer in heavy documentation, when schemas grow definitions can be mixed up and when columns appear in numerous models we need proper documentation across the project.

The `models/_models_doc.md` holds all the dbt documentation blocks for the project. It begins with models doc blocks, and then proceeds to column doc blocks.

The DBT doc syntax is used throughout the YAML files to maintain consistency and keep the project dry.

# Interview Questions

## Question 1:

`Question:` Assuming this data is raw, and we have no pre-existing dbt models built to support this request, what dbt sources, models, and tests would you apply to the model to help the Execution team answer these questions?

`Response:` All three sources were used in this project, the csv files were seeded as models, then referenced in the staging folder to begin creating models. Various tests were applied to the columns within the YAML file:

Example of tests used: `not-null`, `accepted_values`, and `unique`

To save compute power, test were only applied at the earliest instance of column values. No need in the context of this project to do additional tests downstream of already tested columns.

There was also formatting changes done to values within columns. Transforming strings into snake_case to make working with the data easier, and for consistency.

## Question 2:

`Question:` How would you ensure the data quality of your models? Provide code examples.

`Response:` I ensured data quality with two techniques: DBT tests, and then adhering to consitent formatting. 

Code examples: See YAML files for tests, along with Staging models for formatting conventions.

## Question 3:

`Question:` How would you validate that the output of your model is correct?

`Response:` To ensure the output of my models were correct, I viewed my models using an SQL IDE (used datagrip in this instance to view the duckdb database.) Testing with queries that validate the purpose of the DBT model.

Also ran models in DBT: All models Completed Succesfully

## Question 4:

`Question:` How would you help the Execution team visualize this data (what data visualization types or methods would you recommend)?

`Response:` I have split up my recommendations below based off the business questions

### Business Questions:

1. When did a specific transaction “close” (e.g. closed_at timestamp for each transaction)?

Models to utilize: `int_transaction_transitions.sql` or `transaction_close_date.sql`

A `closed_at` timestamp was created in the `transaction_close_date.sql` model this indicates when a transaction moved from an open to closed state.

The `int_transaction_transitions.sql` model has additional busines logic to expand upon this idea, being able to track open to open, and closed to closed transitions as well.

It is important to note there is two `transaction_id`s that transitioned between a closed state to an open state. Due to this occurence the latest timestamp was used as the final closed_at value. If this identified pattern is deemed as an error, future iterations of this model would apply logic to address this. Further information about intended transition patterns is needed to enhanced model.

Could also enhance logic by addressing a closed-won vs closed-loss flow.

Recommended visualizations: We can aggregate by the date associated with each transaction to determine the amount of closed transactions. Line chart would be sufficient

2. What is the average time a transaction is “open”, across months?

Models to utilize: `open_status_time_delta.sql` & `int_transaction_transitions`

The `open_status_time_delta.sql` provides the direct business question aggregation showing the average time for the 4 available months that a transaction is open. Provided in days.

If the aggregation is needed on a different "group by" the end user can use `int_transaction_transitions`

Recommended visualizations: A bar chart can be used to visually show the difference between the months in question.

3. What are the most common termination reasons for transactions?

Models to utilize: `termination_reasons_counts.sql` or `int_transactions.sql`

The `termination_reasons_counts.sql` contains counts of the most common termination reasons. It is aggregated by several dimensions. If these dimensions are not sufficient we can use `int_transactions.sql`.

Recommended visualizations: A bar chart would be sufficient for this use case, with filters that can adjust other dimensions.

4. Visualize the highest gross proceeds per transfer method

Models to utilize: `int_transactions.sql`

This model can be used to aggregate the gross proceeds per transfer method. I chose to keep this at the int level since the only aggregation that was needed was by transfer method, which can be done in a BI tool quite easily. Using a more flexible model would allow better aggregation of the data. 

Recommended Visualization: Time series line chart split by transfer method (three lines - colour seperation). Can then have additional filters of other values in model such as termination_reason





