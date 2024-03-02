// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

struct KeySet {
    // Storage of set values
    bytes[] _values;
    // Position of the value in the `values` array, plus 1 because index 0
    // means a value is not in the set.
    mapping(bytes => uint256) _indexes;
}

/**
 * @dev Modified from OpenZeppelin v4.9.3 EnumerableSet
 */
library EnumerableKeySet {
    /**
     * @dev Add a key to the set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(KeySet storage set, bytes memory value) internal returns (bool) {
        if (!contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a key from the set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(KeySet storage set, bytes memory value) internal returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes memory lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(KeySet storage set, bytes memory value) internal view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(KeySet storage set) internal view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(KeySet storage set, uint256 index) internal view returns (bytes memory) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(KeySet storage set) internal view returns (bytes[] memory) {
        return set._values;
    }
}

contract Test47 is Test, SymTest {
    using EnumerableKeySet for KeySet;

    KeySet set;

    /// with --storage-layout=solidity, fails with
    ///     Encountered symbolic storage base slot: sha3_296(519...220)
    ///
    /// with --storage-layout=generic, it's a PASS
    function test_keySet_sanity() external {
        set.add("hello");
        set.add("world");

        assertEq(set.length(), 2);
        assertEq(set.at(0), "hello");
        assertEq(set.at(1), "world");

        assertEq(set.contains("hello"), true);
        assertEq(set.contains("karma"), false);

        set.remove("hello");
        assertEq(set.length(), 1);
        assertEq(set.at(0), "world");
    }

    /// with --storage-layout=solidity, fails with
    ///     Encountered symbolic storage base slot: sha3_280(Concat(halmos_a_bytes_01, 28))
    ///
    /// with --storage-layout=generic, it's a PASS
    function test_keySet_symbolic_values() external {
        bytes memory a = svm.createBytes(3, "a");
        bytes memory b = svm.createBytes(3, "b");
        vm.assume(keccak256(a) != keccak256(b));

        set.add(a);
        set.add(b);

        assertEq(set.length(), 2);
        assertEq(set.at(0), a);
        assertEq(set.at(1), b);

        assertEq(set.contains(a), true);
        assertEq(set.contains("karma"), false);

        set.remove(a);
        assertEq(set.length(), 1);
        assertEq(set.at(0), b);
    }

    function test_keySet_searchForKeyToRemove() external {
        bytes memory a = svm.createBytes(32, "a");
        bytes memory b = svm.createBytes(32, "b");
        vm.assume(keccak256(a) != keccak256(b));

        set.add(a);
        set.add(b);

        bytes memory c = svm.createBytes(32, "c");
        set.remove(c);
        assertEq(set.length(), 2);
    }
}
