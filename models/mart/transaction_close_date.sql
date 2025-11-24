WITH 

int_transaction_transitions_cte AS (
    SELECT * FROM {{ref('int_transaction_transitions')}}
),

open_to_closed_transactions_cte AS (
    SELECT
    *
    FROM int_transaction_transitions_cte
    WHERE transition_type = 'open_to_closed'
),

row_number_assignment_cte AS (
    SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transitioned_at DESC) as rn
    FROM open_to_closed_transactions_cte
),

final_cte AS (
    SELECT
    id,
    transaction_id,
    transitioned_at AS closed_at,
    inserted_at,
    updated_at,
    new_state,
    is_open_transaction,
    old_state,
    old_state_transitioned_at,
    transition_type,
    time_delta_days,
    time_delta_hours
    FROM row_number_assignment_cte
    WHERE rn = 1
)

SELECT * FROM final_cte