/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : lib.test.mo
* Description       : test
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 19/06/2025		nirvana369 		implement
******************************************************************/

import Bisect "../src/lib";
import {test; suite} "mo:test";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Order "mo:base/Order";
import Array "mo:base/Array";


actor {

    func assertArrayEqual(expected: [Nat], actual: [Nat], msg: Text) {
        if (expected.size() != actual.size()) {
        Debug.print(msg # " ❌ Size mismatch");
        assert false;
        };
        for (i in expected.keys()) {
        if (expected[i] != actual[i]) {
            Debug.print(msg # " ❌ Element mismatch at index " # debug_show(i));
            assert false;
        };
        };
    };

    let sortFunc = func <T>(arr : [T], cmp : (T, T) -> Order.Order) : [T] {
        Array.sort<T>(arr, cmp);
    };

    public func runTests() : async () {

        suite("Bisect", func() {

            test("bisect_left", func() {
                // --- bisect_left ---
                assert Bisect.bisect_left([], 3, null, null, Nat.compare) == 0;
                assert Bisect.bisect_left([1], 0, null, null, Nat.compare) == 0;
                assert Bisect.bisect_left([1], 1, null, null, Nat.compare) == 0;
                assert Bisect.bisect_left([1], 2, null, null, Nat.compare) == 1;
                assert Bisect.bisect_left([1, 2, 4, 4, 5], 4, null, null, Nat.compare) == 2;
                assert Bisect.bisect_left([1, 2, 4, 4, 5], 0, null, null, Nat.compare) == 0;
                assert Bisect.bisect_left([4, 4, 4], 4, null, null, Nat.compare) == 0;
                assert Bisect.bisect_left(sortFunc<Nat>([4, 5, 1, 2, 4], Nat.compare), 4, null, null, Nat.compare) == 2;
            });

            test("bisect_right", func() {
                // --- bisect_right ---
                assert Bisect.bisect_right([], 3, null, null, Nat.compare) == 0;
                assert Bisect.bisect_right([1], 0, null, null, Nat.compare) == 0;
                assert Bisect.bisect_right([1], 1, null, null, Nat.compare) == 1;
                assert Bisect.bisect_right([1], 2, null, null, Nat.compare) == 1;
                assert Bisect.bisect_right([1, 2, 4, 4, 5], 4, null, null, Nat.compare) == 4;
                assert Bisect.bisect_right([1, 2, 4, 4, 5], 6, null, null, Nat.compare) == 5;
                assert Bisect.bisect_right([4, 4, 4], 4, null, null, Nat.compare) == 3;
            });

            test("bisect_left", func() {
                // --- insort_left ---
                assertArrayEqual([3], Bisect.insort_left([], 3, null, null, Nat.compare), "insort_left 1");
                assertArrayEqual([0, 1], Bisect.insort_left([1], 0, null, null, Nat.compare), "insort_left 2");
                assertArrayEqual([1, 1], Bisect.insort_left([1], 1, null, null, Nat.compare), "insort_left 3");
                assertArrayEqual([1, 2], Bisect.insort_left([1], 2, null, null, Nat.compare), "insort_left 4");
                assertArrayEqual([1, 2, 4, 4, 4, 5], Bisect.insort_left([1, 2, 4, 4, 5], 4, null, null, Nat.compare), "insort_left 5");
            });

            test("bisect_left", func() {
                // --- insort_right ---
                assertArrayEqual([3], Bisect.insort_right([], 3, null, null, Nat.compare), "insort_right 1");
                assertArrayEqual([0, 1], Bisect.insort_right([1], 0, null, null, Nat.compare), "insort_right 2");
                assertArrayEqual([1, 1], Bisect.insort_right([1], 1, null, null, Nat.compare), "insort_right 3");
                assertArrayEqual([1, 2], Bisect.insort_right([1], 2, null, null, Nat.compare), "insort_right 4");
                assertArrayEqual([1, 2, 4, 4, 4, 5], Bisect.insort_right([1, 2, 4, 4, 5], 4, null, null, Nat.compare), "insort_right 5");
            });

        });

    };
}