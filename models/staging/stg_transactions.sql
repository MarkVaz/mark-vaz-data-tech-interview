WITH 

transactions_seed_source_cte AS (
    SELECT
        ID AS id,
        BID_ID AS bid_id,
        STATE AS state,
        TRANSFER_METHOD AS transfer_method,
        INSERTED_AT::TIMESTAMP AS inserted_at,
        COMPANY_ID AS company_id,
        NUM_SHARES AS num_shares,
        PRICE_PER_SHARE AS price_per_share,
        GROSS_PROCEEDS AS gross_proceeds,
        _FIVETRAN_DELETED AS _fivetran_deleted,
        _FIVETRAN_SYNCED::TIMESTAMP AS _fivetran_synced
    FROM {{ ref('transactions_seed') }}
)

SELECT * FROM transactions_seed_source_cte