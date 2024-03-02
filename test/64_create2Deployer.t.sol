// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";
// import {MockERC721} from "@test/mocks/tokens/standard/MockERC721.sol";
import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

// import {Errors} from "@src/libraries/Errors.sol";
import {console2} from "forge-std/console2.sol";

/**
 * @title Create2Deployer
 * @notice Deployment contract that uses the init code and a salt to perform a deployment.
 *         There is added cross-chain safety as well because a particular salt can only be
 *         used if the sender's address is contained within that salt. This prevents a
 *         contract on one chain from being deployed by a non-admin account on
 *         another chain.
 */
contract Create2Deployer {
    // Determine if an address has already been deployed.
    mapping(address => bool) public deployed;

    // Byte used to prevent collision with CREATE.
    bytes1 constant create2_ff = 0xff;

    /**
     * @notice Deploys a contract using the given salt and init code. Prevents
     *         frontrunning of claiming a specific address by asserting that the first
     *         20 bytes of the salt matches the sender. This check is especially useful
     *         if trying to keep the same deployment addresses across chains.
     *
     * @param salt     A unique value which must contain the address of the sender.
     * @param initCode The init code of the contract to deploy.
     *
     * @return deploymentAddress The addres of the deployed contract.
     */
    function deploy(bytes32 salt, bytes memory initCode) external payable returns (address deploymentAddress) {
        // Ensure the salt is valid for the sender.
        if (address(bytes20(salt)) != msg.sender) {
            revert("Unauthorized sender");
        }

        // Determine the target address for contract deployment.
        address targetDeploymentAddress = getCreate2Address(salt, initCode);

        // Ensure that a contract hasn't been previously deployed to target address.
        if (deployed[targetDeploymentAddress]) {
            revert("Already deployed");
        }

        // Prevent redeploys of contracts at the same address.
        deployed[targetDeploymentAddress] = true;

        // Deploy the contract.
        assembly {
            deploymentAddress :=
                create2(
                    // ETH value to pass to the call.
                    callvalue(),
                    // Init code data.
                    add(initCode, 0x20),
                    // Init code data length.
                    mload(initCode),
                    // Unique salt value.
                    salt
                )
        }

        // Check address against target to ensure that deployment was successful.
        if (deploymentAddress != targetDeploymentAddress) {
            console2.log("Error: Target address and deployment address don't match");
            console2.log("Create2Deployer: Deployment Address:  ", deploymentAddress);
            console2.log("Create2Deployer: Target Address:      ", targetDeploymentAddress);
            revert("Mismatched address");
        }

        console2.log("Success");
    }

    /**
     * @notice Calculate the target address for contract deployment using the
     *         salt and init code.
     *
     * @param salt     A unique value which must contain the address of the sender.
     * @param initCode The init code of the contract to deploy.
     *
     * @return The address that would be generated from the deployment.
     */
    function getCreate2Address(bytes32 salt, bytes memory initCode) public view returns (address) {
        // Create the address hash.
        bytes32 addressHash = keccak256(abi.encodePacked(create2_ff, address(this), salt, keccak256(initCode)));

        // Cast the hash to an address.
        return address(uint160(uint256(addressHash)));
    }

    /**
     * @notice Allows the generation of a salt using the sender address.
     *         This function ties the deployment sendder to the salt of the CREATE2
     *         address so that it cannot be frontrun on a different chain. More details
     *         about this can be found here:
     *         https://github.com/martinetlee/create2-snippets#method-1-mixing-with-salt
     *
     * @param sender The address of the deployer.
     * @param data   The added data to make the salt unique.
     */
    function generateSaltWithSender(address sender, bytes12 data) public pure returns (bytes32 salt) {
        assembly {
            // Use or to combine the bytes20 address and bytes12 data together.
            salt :=
                or(
                    // Shift the address 12 bytes to the left.
                    shl(0x60, sender),
                    // Shift the extra data 20 bytes to the right.
                    shr(0xA0, data)
                )
        }
    }
}

contract MockERC721 {
    constructor() payable {
        console2.log("MockERC721: constructor just got paid", msg.value);
    }
}

contract Create2DeployerTestHalmos is Test, SymTest {
    Create2Deployer public create2Deployer;

    function setUp() public {
        // Deploy the create2 deployer contract
        create2Deployer = new Create2Deployer();
    }

    function echidna_DeployWithValue() public {
        bytes12 data = _toBytes12(svm.createBytes32("z"));

        // generate salt that begins with msg.sender
        bytes32 salt = create2Deployer.generateSaltWithSender(address(this), data);

        // abi encode the contract bytecode and constructor arguments
        bytes memory mock721InitCode = abi.encodePacked(type(MockERC721).creationCode);
        // takes no constructor args

        // expected deployment address
        address expectedmock721Address = create2Deployer.getCreate2Address(salt, mock721InitCode);

        vm.deal(expectedmock721Address, 0 ether);

        // Deploy the contract and send 1 ether to the contract
        vm.deal(address(this), 10 ether);
        address mock721Address = create2Deployer.deploy{value: 1 ether}(salt, mock721InitCode);

        // assert payable deployment was successful
        console2.log("ExpectedMockAddress:  ", expectedmock721Address);
        console2.log("MockAddress:  ", mock721Address);
        assertEq(expectedmock721Address, mock721Address, "1");

        console2.log("Deployed:  ", create2Deployer.deployed(mock721Address));
        assertEq(create2Deployer.deployed(mock721Address), true, "2");

        if (_isContract(mock721Address)) {
            console2.log("Balance:", mock721Address.balance);
            assertEq(mock721Address.balance, 1 ether, "3");
        } else {
            console2.log("Not Contract: ", mock721Address);
        }
    }

    function _isContract(address _a) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(_a)
        }
        return size > 0;
    }

    function _toBytes12(bytes32 data) internal pure returns (bytes12) {
        bytes12 result = bytes12(data);
        require(result != bytes12(0));
        return result;
    }
}
