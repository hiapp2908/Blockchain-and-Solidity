from solcx import compile_standard
import json
import os
from web3 import Web3

with open("SimpleStorage.sol", "r") as file:
    simple_storage = file.read()
    # print(simple_storage)

    # Compiling our solidity file
    compiled_sol = compile_standard(
        {
            "language": "Solidity",
            "sources": {"SimpleStorage.sol": {"content": simple_storage}},
            "settings": {
                "outputSelection": {"*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
                                    }
            }
        },
        solc_version="0.8.10"
    )

    with open("compiled_sol.json", "w") as file_out:
        json.dump(compiled_sol, file_out)

    # Get Bytecode
    bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]["object"]

    # Get ABI
    abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

    # Connecting to the Network(Ganache in this case)
    ## "0x03cd7d61bcaaaf8480d860cdf3c475ebe390c248472f45e7921a93d86b1f8dfc"
    w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:7545"))
    chain_id = 1337
    my_address = "0x1d21bCa5b0846Da37B2ef482A2c1745A3b230082"
    private_key = os.environ.get("PRIVATE_KEY")

    # Creating Contract
    SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

    ## Get latest transaction
    nonce = w3.eth.getTransactionCount(my_address)

    # Building Transaction
    transaction = SimpleStorage.constructor().buildTransaction(
        {
            "chainId": chain_id,
            "from": my_address,
            "nonce": nonce
        }
    )

    # Sign a Transaction
    signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)

    # Send a Transaction
    txn_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
    txn_reciept = w3.eth.wait_for_transaction_receipt(txn_hash)

    # Working With Contract
    # Contract Address
    # Contract ABI

    simple_storage_address = w3.eth.contract(address=txn_reciept.contractAddress, abi=abi)

    ## Call a function doesn't make a state change.
    ## Transact makes a state change and requires gas.

    print(simple_storage_address.functions.retrieve().call())

    store_transaction = simple_storage_address.functions.store(29).buildTransaction({
        "chainId": chain_id, "from": my_address, "nonce": nonce + 1
    })

    signed_store_txn = w3.eth.account.sign_transaction(store_transaction, private_key=private_key)

    store_txn_hash = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
    tx_reciept = w3.eth.wait_for_transaction_receipt(store_txn_hash)

    print(simple_storage_address.functions.retrieve().call())
