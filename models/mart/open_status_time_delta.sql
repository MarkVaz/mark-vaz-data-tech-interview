WITH

int_transaction_transitions_cte AS (
    SELECT * FROM {{ref('int_transaction_transitions')}}
),

open_transaction_transitions_cte AS (
    SELECT
    *
    FROM int_transaction_transitions_cte
    WHERE transition_type IN ('stayed_open','open_to_closed')
),

sum_open_transaction_cte AS (
    SELECT
    transaction_id,
    DATE_TRUNC('month',transitioned_at) AS month_transitioned_at,
    SUM(time_delta_days) AS total_time_open_days
    FROM open_transaction_transitions_cte
    GROUP BY transaction_id, month_transitioned_at
),

avg_open_transactions_by_month_cte AS (
    SELECT
    month_transitioned_at,
    AVG(total_time_open_days) AS avg_time_open_days
    FROM sum_open_transaction_cte
    GROUP BY month_transitioned_at
)

SELECT * FROM avg_open_transactions_by_month_cte