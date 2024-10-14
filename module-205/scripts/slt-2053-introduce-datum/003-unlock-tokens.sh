#!/bin/bash

. ../env.sh
. ../utils.sh

validator_addr=addr_test1wr7ts2t5e2gc9xalqllh22uleyl8v7n6w8qenee2zwffv4g7jhtlh
reference_utxo=01eb2661a34457852902edd0e0f7613f0d411994168fb015f249707117428a5f#0
sender_tx_in=$(get_address_biggest_lovelace ${sender})

validator_tx_in=$(get_address_biggest_lovelace ${validator_addr})

cardano-cli conway transaction build \
	--testnet-magic 1 \
	--tx-in $sender_tx_in \
	--tx-in-collateral $sender_tx_in \
	--tx-in 6778c23567e09c0fc2aeb8809384ab12be3f1e4100351c692394fc695b1df214#0 \
	--spending-tx-in-reference $reference_utxo \
	--spending-plutus-script-v3 \
	--spending-reference-tx-in-inline-datum-present \
	--spending-reference-tx-in-redeemer-file redeemer.json \
	--invalid-before 73221083 \
	--invalid-hereafter 73229540 \
	--change-address $sender \
	--out-file unlock-tokens.draft

cardano-cli conway transaction sign \
	--signing-key-file $sender_key \
	--testnet-magic 1 \
	--tx-body-file unlock-tokens.draft \
	--out-file unlock-tokens.signed

cardano-cli conway transaction submit \
	--tx-file unlock-tokens.signed \
	--testnet-magic 1
