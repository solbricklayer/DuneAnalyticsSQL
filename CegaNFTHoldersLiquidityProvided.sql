
-- Get Unique NFT Owners at the Mint

with NFT_owners as

(
SELECT
    account_keys[0] AS buyer_address,
    account_keys[5] AS mint_auth,
    SUM((pre_balances[0] - post_balances[0]) / power(10,9)) as total_sol

FROM
    solana.transactions

WHERE
    account_keys[11] = "rycKpR5EsgmPGoxPyWUXpj6aoomWhSFq9K4tM8ieJLS"  -- update_authority 
    AND block_time BETWEEN (CURRENT_DATE - interval '30 days') AND CURRENT_DATE
    AND success = TRUE
    
group by 1,2

),

-- get liquidity providers in any pool - pre_amount

liquidity_provided_by_wallet_PRE_AMOUNT as

(
SELECT
    id,
    signer,
    pre_tb.account,
    pre_tb.mint,
    pre_tb.amount,
    CASE
        WHEN pre_tb.mint = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v' THEN 'USDC'
    ELSE "" END as token_name

FROM
    solana.transactions
    LATERAL VIEW explode(pre_token_balances) ptb AS pre_tb
    
WHERE
    (
    array_contains(instructions.executing_account, '3HUeooitcfKX1TSCx2xEpg2W31n6Qfmizu7nnbaEWYzs') -- Cega Program Authority
    )
    AND block_time BETWEEN (CURRENT_DATE - interval '30 days') AND CURRENT_DATE
    AND success = TRUE
    AND (ARRAY_CONTAINS(log_messages, 'Program log: Instruction: DepositVault'))
    AND signer not in ('FMs1U19BfkLU3cunEa3yNZU69isCLBq59HK1eiFoLmx6')
    -- filter to exclude LP tokens
    AND pre_tb.mint in ('EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v')
),

-- get liquidity providers in any pool - post_amount

liquidity_provided_by_wallet_POST_AMOUNT as

(
SELECT
    id,
    signer,
    pot_tb.account,
    pot_tb.mint,
    pot_tb.amount,
    CASE
        WHEN pot_tb.mint = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v' THEN 'USDC'
    ELSE "" END as token_name

FROM
    solana.transactions
    LATERAL VIEW explode(post_token_balances) potb AS pot_tb
    
WHERE
    (
    array_contains(instructions.executing_account, '3HUeooitcfKX1TSCx2xEpg2W31n6Qfmizu7nnbaEWYzs') -- Cega Program Authority
    )
    AND block_time BETWEEN (CURRENT_DATE - interval '30 days') AND CURRENT_DATE
    AND success = TRUE
    AND (ARRAY_CONTAINS(log_messages, 'Program log: Instruction: DepositVault'))
    AND signer not in ('FMs1U19BfkLU3cunEa3yNZU69isCLBq59HK1eiFoLmx6')
    -- filter to exclude LP tokens
    AND pot_tb.mint in ('EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v')
),

-- get AMOUNT of liquidity provided by wallet

token_balance_change as
    (
SELECT
    pre.id
    , pre.signer
    , pre.mint
    , pre.token_name
    , abs(pre.amount - post.amount) as net_token_balance
        
    FROM liquidity_provided_by_wallet_PRE_AMOUNT pre
    JOIN liquidity_provided_by_wallet_POST_AMOUNT post

    ON pre.id = post.id
    AND pre.account = post.account
    AND pre.mint = post.mint
    AND pre.signer = post.signer
    ),

-- list of unique NFT minters

unique_nft_buyers as
( 
    select buyer_address as unique_wallets
    from NFT_owners
    group by 1
),

token_amount_USDC as 
(
SELECT
    signer,
    mint,
    token_name,
    sum(net_token_balance)/2 as token_amount_USDC

FROM token_balance_change, unique_nft_buyers

WHERE token_balance_change.signer = unique_nft_buyers.unique_wallets

group by 1,2,3
)

SELECT 
    signer,
    mint,
    token_name,
    token_amount_USDC,
    sum(token_amount_USDC) OVER (order by token_amount_USDC desc) AS RunningToken_amount_USDC
    
from token_amount_USDC
order by token_amount_USDC desc






-- select count(*) 
-- from unique_nft_buyers, liquidity_providers 
-- where unique_nft_buyers.unique_wallets = liquidity_providers.unique_wallets 

-- select count(*) 
-- from NFT_ownersa
-- join liquidity_provider_users 
-- on unique_nft_buyers.unique_wallets = liquidity_providers.unique_wallets 








