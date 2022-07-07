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

    -- AND id in 
    -- ('2TnE9maogHQnFEfZFEgh3nJSpvdomNR6ZfuTdPBcuZZEseQTy8S9oLLyTmgWY6uFeYHBg6EV8UiVEVFuYJqwEphw'
    -- )

    -- AND 
    -- (
    -- ARRAY_CONTAINS(log_messages, 'Program log: Instruction: MintNft')
    -- )
    
group by 1,2,3

-- ACCOUNT KEYS

["CTQGTxCFBiM6CgFpZheEj1dVsbAPGBuki6K2jTj4YhWA", -- 0. owner
"B7AaQsB4LjdHSFot2fzyjh93K319LEnmAhAavQaERbE9",
"23W5dZSNiNtKXCGvcjkRAJZ6admMXQ26s3ttBaH6Lb2k",
"1NWouc2qu4d5kxi94mzthKbirxPYc6UhMsmLGonDeFb",
"4LuPUepNCeuvaJKZxtduM4tLAcGGYNnNM19rjn4R4rBT",
"4PgZcycaj4NBtgFRTQcWpTayJrQ9ZMGATVjrDDVAMsm1", -- 5. mint auth
"6pr3bBGn83KT2K6tuFDonW33NhVtZeKq2oHEhMkoRTW8",
"6u19UcPmczXY3bTHuZSirN9StpTmYTxK8NE7CwiBSoUK",
"8tmxcquxWkfh3hgaYDCWwqsP8KhafHkS3Apc4Vctmu63",
"BPmooPdeaDezTQatwCTQwP3RjAJ2Yz2ouBvj6tobKXCW",
"FCyJSompRmbfjvTBaq9facPT4FHNdKrM6hh23Cm87GPR",
"rycKpR5EsgmPGoxPyWUXpj6aoomWhSFq9K4tM8ieJLS", -- update authority
"11111111111111111111111111111111",
"2HvkgLrcUeZAfXHp9XMehtG9U8ZRq6CsrsZ94g14B7bG",
"ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efsTNsLJA8knL",
"CMZYPASGWeTz7RNGHaRJfCq2XQ5pYK6nDvVQxzkH51zb",
"metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s",
"SysvarRent111111111111111111111111111111111",
"SysvarS1otHashes111111111111111111111111111",
"TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"]

-- SINGER

CTQGTxCFBiM6CgFpZheEj1dVsbAPGBuki6K2jTj4YhWA




