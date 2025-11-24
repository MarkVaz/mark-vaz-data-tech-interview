WITH

transaction_transitions_seed_source_cte AS (
    SELECT
        ID AS id,
        INSERTED_AT::TIMESTAMP AS inserted_at,
        UPDATED_AT::TIMESTAMP AS updated_at,
        TRANSACTION_ID AS transaction_id,
        NEW_STATE AS new_state,
        TRANSITIONED_AT::TIMESTAMP AS transitioned_at,
        _FIVETRAN_DELETED AS _fivetran_deleted,
        _FIVETRAN_SYNCED::TIMESTAMP AS _fivetran_synced
    FROM {{ ref('transaction_transitions_seed') }}
)

SELECT * FROM transaction_transitions_seed_source_cte