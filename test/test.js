const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SoladayRNG", function () {

    it("Should Deploy", async function () {

        let accounts = await ethers.getSigners()

        const testFactory = await hre.ethers.getContractFactory("SoladayRNG");
        const testContract = await testFactory.deploy();
        await testContract.deployed();
    
        console.log("  Deployed:", testContract.address);

        

        // send LINK to 
        accounts[0].Transfer

        describe("mint", function () {

            it("Should mint a token", async function () {
                expect(
                    await testContract.mint(accounts[0].address)
                )
                .to.emit(todayContract, 'Transfer')
                .withArgs(
                    address(0), 
                    accounts[0].address,
                    0
                    )
            });
        });
    });
});