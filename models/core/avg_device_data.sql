{{ config(materialized='table') }}

SELECT
    CONCAT(device, ' (', connection_type, ')') AS device,
    AVG(inbound) AS avg_inbound,
    AVG(outbound) AS avg_outbound
FROM {{ ref('net_data_model') }}
GROUP BY device, connection_type
