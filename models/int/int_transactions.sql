WITH

stg_transactions_cte AS (
    SELECT * FROM {{ref('stg_transactions')}}
),

stg_transaction_termination_reasons_cte AS (
    SELECT * FROM {{ref('stg_transaction_termination_reasons')}}
),

open_transactions_cte AS (
    SELECT
    s.*,
    CASE WHEN s.state IN ('pending_approval','bid_accepted') THEN TRUE ELSE FALSE END AS is_open_transaction,
    COALESCE(t.termination_reason,'did_not_disclose') AS termination_reason
    FROM stg_transactions_cte s
    LEFT JOIN stg_transaction_termination_reasons_cte t ON s.id = t.transaction_id
)

SELECT * FROM open_transactions_cte




