import pytest
from brownie import accounts, MQPToken, reverts

@pytest.fixture
def dep():
    return MQPToken.deploy({'from': accounts[1]})

def test_account_balance():
    balance = accounts[0].balance()
    accounts[0].transfer(accounts[1], "10 ether", gas_price=0)

    assert balance - "10 ether" == accounts[0].balance()

def test_contract_name(dep):
    assert dep.name() == "MQP coin"

def test_contract_symbol(dep):
    assert dep.symbol() == "MQP"

def test_contract_decimals(dep):
    assert dep.decimals() == 8

def test_contract_totalSupply(dep):
    assert dep.totalSupply() == 1000000

def test_contract_balanceOf(dep):
    assert dep.balanceOf(accounts[1]) == 1000000

def test_contract_transfer(dep):
    dep.transfer(accounts[2], 100)
    assert dep.balanceOf(accounts[2]) == 100

def test_contract_transfer(dep):
    with reverts():
        dep.transfer(accounts[2], 0)

def test_contract_approve(dep):
    assert dep.approve(accounts[2], 100)

def test_contract_allowance(dep):
    dep.approve(accounts[2], 100)
    assert dep.allowance(accounts[1], accounts[2]) == 100

def test_contract_transferFrom(dep):
    dep.approve(accounts[1], 1000000)
    dep.transferFrom(accounts[1], accounts[2], 100)
    assert dep.balanceOf(accounts[2]) == 100

def test_contract_transferFrom(dep):
    with reverts():
        dep.transferFrom(accounts[1], accounts[2], 100)

def test_contract_mint(dep):
    assert dep.balanceOf(accounts[1]) == 1000100