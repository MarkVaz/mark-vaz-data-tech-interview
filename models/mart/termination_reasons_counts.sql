WITH

int_transaction_cte AS (
    SELECT * FROM {{ref('int_transactions')}}
    WHERE termination_reason IS NOT NULL
),

transaction_reasons_cte AS (
    SELECT
    COUNT(*) as row_count,
    termination_reason,
    transfer_method,
    state,
    DATE_TRUNC('month',inserted_at) as inserted_month
    FROM int_transaction_cte
    GROUP BY 2,3,4,5
)

SELECT * FROM transaction_reasons_cte