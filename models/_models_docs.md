<!-- model docs -->

{% docs transactions %}
    The `transactions` table contains information about transactions
{% enddocs %}

{% docs transaction_transitions %}
    The `transaction_transitions` table contains information about how transactions move through various states (acts as a log table).
    This data can be used to identify when transactions entered and exited specific states (e.g. when a transaction closed).
{% enddocs %}

{% docs transaction_termination_reasons %}
    The `transaction_termination_reasons` table contains information about why transactions were terminated. This table contains rows for each reason.
{% enddocs %}

{% docs int_transactions %}
    This model builds upon the stg_transactions.sql model adding logic around whether the state is open or closed, and then joining stg_transaction_termination_reasons.sql to provide the termination_reason to the transaction data. Used coalesce when joining the termination_reason to the model, this allows the value of "did_not_disclose" to be used instead of null. 
{% enddocs %}

{% docs int_transaction_transitions %}
    This model builds upon the stg_transaction_transitions.sql model adding business logic around the transition states
    New columns: is_open_transaction, old_state, and transition_type, and old_state_transitioned_at
{% enddocs %}

{% docs termination_reasons_counts %}
    This table is the count aggregation of the termination reasons by the following dimensions: transfer method, state, and the inserted_month
{% enddocs %}

{% docs open_status_time_delta %}
    This table is the average time a transaction is considered open by the month
{% enddocs %}

{% docs transaction_close_date %}
    This table allows the viewer to see the final close date of a transaction. Going from an open state to a closed state. There is a couple of transaction_ids that go back to an open state after being considered closed. Due to this a row_number function is used to get the latest instance of transitioning between an open state to a closed state.
{% enddocs %}

<!-- column docs -->

{% docs transaction_id %}
    The unique identifier of the transaction. (UUID v4 varchar)
{% enddocs %}

{% docs bid_id %}
    The unique identifier of the accepted bid associated with the transaction. (UUID v4 varchar)
{% enddocs %}

{% docs state %}
    The current state of the transaction. Transactions in cancelled, expired, closed_paid, approval_declined states are no longer "active". (varchar)
    Possible values:
    -`bid_accepted`
    -`approval_declined`
    -`pending_approval`
    -`expired`
    -`cancelled`
    -`closed_paid`
{% enddocs %}

{% docs transfer_method %}
    The method of transfer of the transaction. (varchar)
    Possible Values:
    -`direct`
    -`forward_contract`
    -`unknown`
{% enddocs %}

{% docs inserted_at %}
    When the transaction record was created. (timestamp)
{% enddocs %}

{% docs company_id %}
    The unique identifier of the issuing company of the shares. (UUID v4 varchar)
{% enddocs %}

{% docs num_shares %}
    The number of shares associated with each transaction. (int)
{% enddocs %}

{% docs price_per_share %}
    The price per share of the transaction, denomination not specified (int)
{% enddocs %}

{% docs updated_at %}
    The time associated with the line item being updated(timestamp)
{% enddocs %}

{% docs transitioned_at %}
    The time associated with the transition of states(timestamp)
{% enddocs %}

{% docs gross_proceeds %}
    The revenue value of the transaction, number of shares multiplied by the price per share. (int)
{% enddocs %}

{% docs _fivetran_deleted %}
    The value is TRUE when the record has been soft deleted in the production database. The value is false otherwise. (binary T/F)
{% enddocs %}

{% docs _fivetran_synced %}
    When the record was synced to the data warehouse. (timestamp)
{% enddocs %}

{% docs transaction_transition_id %}
    The unique identifier of the transaction transition. (UUID v4 varchar)
{% enddocs %}

{% docs new_state %}
    The new state the transaction moved into. (varchar)
    Possible Values:
    -`bid_accepted`
    -`approval_declined`
    -`pending_approval`
    -`expired`
    -`cancelled`
    -`closed_paid`

{% enddocs %}

{% docs termination_reason %}
    The reason(s) a transaction was terminated. (varchar)
    Possible values:
    - `buyer_backed_out`
    - `other`
    - `combining_transactions`
    - `seller_backed_out`
    - `transferability_issues`
    - `other_*_requires_context` 
{% enddocs %}

{% docs is_open_transaction %}
    A boolean value indicating that the transaction is open or not. State of transaction is either 'bid_accepted' or 'pending_approval' to be considered TRUE
{% enddocs %}

{% docs old_state %}
    This column describes the previous state of a transaction after a transition (order by transitioned_at column)
{% enddocs %}

{% docs transition_type %}
    This column indicates the type of transitioned that occured. Taking into account both the old_state and new_state of the transition
    Context:
    Open states = 'bid_accepted' or 'pending_approval'
    Closed states = 'approval_declined', 'expired', 'cancelled', or 'closed_paid'
    Possible values:
    - `stayed_open` the transaction transitioned between open states
    - `stayed_closed` the transaction transitioned between closed states
    - `open_to_closed` the transaction transitioned between an open state to a closed state
    - `closed_to_open` the transaction transitioned between a closed state to an open state
    - `net_new` the transactions first transition, a net new transaction
{% enddocs %}

{% docs time_delta_days %}
    The time delta between transition states for a transaction_id in days
{% enddocs %}

{% docs time_delta_hours %}
    The time delta between transition states for a transaction_id in hours
{% enddocs %}

{% docs old_state_transitioned_at %}
    The time associated with the transaction_id's old_state
{% enddocs %}

{% docs row_count %}
    Count(*) statement when considering termination_reasons
{% enddocs %}

{% docs inserted_month %}
    The month the transaction was inserted into the table
{% enddocs %}

{% docs closed_at %}
    The timestamp associated with a transaction transitioning from an open state to a closed state
{% enddocs %}

{% docs month_transitioned_at %}
    The month the transaction transition occured
{% enddocs %}

{% docs avg_time_open_days %}
    The average time in days a transaction stayed in an open state
{% enddocs %}






