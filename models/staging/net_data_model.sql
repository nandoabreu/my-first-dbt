{{ config(materialized='view') }}

SELECT
    device,
    collected_at,
    net_data::jsonb->>'cxn' AS connection_type,
    (net_data::jsonb->>'in')::float AS inbound,
    (net_data::jsonb->>'out')::float AS outbound
FROM {{ source('sensor_data_source', 'sensor_data') }}
WHERE device <> '0' AND net_data IS NOT NULL
