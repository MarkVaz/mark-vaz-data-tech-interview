WITH 

transaction_termination_reasons_source_cte AS(
    SELECT
        TRANSACTION_ID AS transaction_id,
        TERMINATION_REASON AS termination_reason
    FROM {{ ref('transaction_termination_reasons_seed') }}
),

formatted_transaction_termination_reasons_cte AS (
    SELECT
        transaction_id,
        CASE WHEN termination_reason = 'Buyer Backed Out' THEN 'buyer_backed_out'
             WHEN termination_reason = 'Seller Backed Out' THEN 'seller_backed_out'
             WHEN termination_reason = 'Combining Transactions' THEN 'combining_transactions'
             WHEN termination_reason = 'Transferability Issues' THEN 'transferability_issues'
             WHEN termination_reason = 'Other * Requires Context' THEN 'other_*_requires_context'
             ELSE NULL
        END AS termination_reason
    FROM transaction_termination_reasons_source_cte
)

SELECT * FROM formatted_transaction_termination_reasons_cte





