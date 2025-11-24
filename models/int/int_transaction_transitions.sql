WITH 

stg_transaction_transitions_cte AS (
    SELECT * FROM {{ref('stg_transaction_transitions')}}
),

enriched_transaction_transitions_cte AS (
    SELECT
    s.*,
    CASE WHEN new_state IN ('pending_approval','bid_accepted') THEN TRUE ELSE FALSE END AS is_open_transaction,
    LAG(new_state, 1, NULL) OVER (PARTITION BY transaction_id ORDER BY transitioned_at) AS old_state,
    LAG(transitioned_at,1,NULL) OVER (PARTITION BY transaction_id ORDER BY transitioned_at) AS old_state_transitioned_at,
    CASE 
    WHEN old_state IN ('pending_approval','bid_accepted') AND new_state IN ('expired','cancelled','closed_paid','approval_declined') THEN 'open_to_closed'
    WHEN old_state IN ('expired','cancelled','closed_paid','approval_declined') AND new_state IN ('pending_approval','bid_accepted') THEN 'closed_to_open'
    WHEN old_state IN ('pending_approval','bid_accepted') AND new_state IN ('pending_approval','bid_accepted') THEN 'stayed_open'
    WHEN old_state IN ('expired','cancelled','closed_paid','approval_declined') AND new_state IN ('expired','cancelled','closed_paid','approval_declined') THEN 'stayed_closed'
    ELSE 'net_new'
    END AS transition_type,
    DATE_DIFF('day',old_state_transitioned_at,transitioned_at) AS time_delta_days,
    DATE_DIFF('hour',old_state_transitioned_at,transitioned_at) AS time_delta_hours
    FROM stg_transaction_transitions_cte s
)

SELECT * FROM enriched_transaction_transitions_cte

