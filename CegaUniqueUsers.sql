
-- EXAMPLE TX

-- https://solscan.io/tx/5o1okgaaFuf5WU3V7V4ZFsRp3ESeTxw6P1UXrBPx7jXaKDCoEsKBnPyJny768FrKwKeS38VQMXUaJSfeQkywaAmB
-- program id https://solscan.io/account/3HUeooitcfKX1TSCx2xEpg2W31n6Qfmizu7nnbaEWYzs

with unique_users as

(SELECT
    -- date_trunc('week', block_time) AS week

    signer,
    COUNT(*) AS transaction_count

   -- , pre_tb.account
   -- , pre_tb.mint
   -- , pre_tb.amount
   -- , CASE
   --      WHEN pre_tb.mint = 'So11111111111111111111111111111111111111112' THEN 'SOL'
   --      WHEN pre_tb.mint = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v' THEN 'USDC'
   --      WHEN pre_tb.mint = 'ratioMVg27rSZbSvBopUvsdrGUzeALUfFma61mpxc8J' THEN 'RATIO'
   --      WHEN pre_tb.mint = '4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R' THEN 'RAY'
   --      WHEN pre_tb.mint = 'SRMuApVNdxXokk5GT7XD5cUUgXMBCoAz2LHeuAoKWRt' THEN 'SRM'
   --   ELSE "" END as token_name


FROM
    solana.transactions
    -- LATERAL VIEW explode(pre_token_balances) ptb AS pre_tb
    
WHERE
    (
    array_contains(instructions.executing_account, '3HUeooitcfKX1TSCx2xEpg2W31n6Qfmizu7nnbaEWYzs') -- lendingDeltaProgramID
    )
    AND block_time BETWEEN (CURRENT_DATE - interval '1 days') AND CURRENT_DATE
    AND success = TRUE
    AND id in 
    ('5o1okgaaFuf5WU3V7V4ZFsRp3ESeTxw6P1UXrBPx7jXaKDCoEsKBnPyJny768FrKwKeS38VQMXUaJSfeQkywaAmB'
    )
    AND 
    (
    ARRAY_CONTAINS(log_messages, 'Program log: Instruction: DepositVault')
    )
    AND signer is not in ('FMs1U19BfkLU3cunEa3yNZU69isCLBq59HK1eiFoLmx6')

GROUP BY    signer

)



