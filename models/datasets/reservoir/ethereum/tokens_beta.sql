{{ config(
    tags = ['dunesql'],
    schema = 'reservoir',
    alias = alias('tokens_beta'),
    post_hook = '{{ expose_dataset(\'["ethereum"]\',
                \'[""]\') }}'
    )
}}
select
    t.created_at,
    t.collection_id,
    _unsafe_0x_or_base58_to_varbinary(t.contract) as contract,
    _unsafe_0x_or_base58_to_varbinary(t.floor_ask_maker) as floor_ask_maker,
    _unsafe_0x_or_base58_to_varbinary(t.floor_ask_id) as floor_ask_id,
    _unsafe_0x_or_base58_to_varbinary(t.owner) as owner,
    t.description,
    t.floor_ask_source,
    t.floor_ask_valid_from,
    t.floor_ask_valid_to,
    t.floor_ask_value,
    t.floor_ask_value / 1e18 as floor_ask_value_decimal,
    t.id,
    t.last_sale_timestamp,
    t.last_sale_value,
    t.last_sale_value / 1e18 as last_sale_value_decimal,
    t.name,
    t.token_id,
    t.updated_at
from reservoir.tokens_0010 t
    inner join (
        select
            id,
            max(updated_at) as recent_updated_at,
            max(filename) as last_filename
        from
            reservoir.tokens_0010
        group by
            id
    ) tm on t.id = tm.id
    and t.updated_at = tm.recent_updated_at
    and t.filename = tm.last_filename