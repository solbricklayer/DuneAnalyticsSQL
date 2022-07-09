with NFT_owners as

(
SELECT
    date_trunc('day', block_time) AS day,
    account_keys[0] AS buyer_address,
    account_keys[5] AS mint_auth,
    SUM((pre_balances[0] - post_balances[0]) / power(10,9)) as total_sol

FROM
    solana.transactions

WHERE
    account_keys[11] = "rycKpR5EsgmPGoxPyWUXpj6aoomWhSFq9K4tM8ieJLS"  -- update_ath

    AND block_time BETWEEN (CURRENT_DATE - interval '30 days') AND CURRENT_DATE

    AND success = TRUE
    
group by 1,2,3

),

liquidity_provider_users as
(
SELECT
    signer,
    COUNT(*) AS transaction_count

FROM solana.transactions
    
WHERE
    (
    array_contains(instructions.executing_account, '3HUeooitcfKX1TSCx2xEpg2W31n6Qfmizu7nnbaEWYzs') -- Cega Program Authority
    )
    AND block_time BETWEEN (CURRENT_DATE - interval '30 days') AND CURRENT_DATE
    AND success = TRUE
    AND 
    (
    ARRAY_CONTAINS(log_messages, 'Program log: Instruction: DepositVault')
    )
    AND signer not in ('FMs1U19BfkLU3cunEa3yNZU69isCLBq59HK1eiFoLmx6')

GROUP BY signer
),

unique_nft_buyers as
( 
	select buyer_address as unique_wallets
	from NFT_owners
	group by 1
),

liquidity_providers as
( 
	select signer as unique_wallets
	from liquidity_provider_users
	group by 1
)

select count(*) 
from unique_nft_buyers, liquidity_providers 
where unique_nft_buyers.unique_wallets = liquidity_providers.unique_wallets 

-- select count(*) 
-- from NFT_owners
-- join liquidity_provider_users 
-- on unique_nft_buyers.unique_wallets = liquidity_providers.unique_wallets 






