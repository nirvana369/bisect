[![mops](https://oknww-riaaa-aaaam-qaf6a-cai.raw.ic0.app/badge/mops/bisect)](https://mops.one/bisect) [![documentation](https://oknww-riaaa-aaaam-qaf6a-cai.raw.ic0.app/badge/documentation/bisect)](https://mops.one/bisect/docs)
# 📌 `bisect` Library in Motoko

The `bisect` library provides utility functions to insert elements into **sorted arrays** while maintaining order. It is particularly useful in binary search and ordered data manipulation.

---

## Documentation
* [Installation](###installation)
* [Usage](#usage)
* [Testing](#testing)
* [License](#license)

---

### Installation

Install with mops

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops add xxhash
```

### Usage 
#
#### 1. `bisect_left`

```motoko
bisect_left<T>(
  arr: [T],
  x: T,
  lo_opt: ?Nat,
  hi_opt: ?Nat,
  fcmp: (T, T) -> Order.Order
) : Nat
```

- **Purpose:** Finds the **leftmost** insertion point for `x` in the sorted array `arr`.
- **Use Case:** Inserts `x` **before** any existing entries of the same value.
- **Returns:** Index where `x` should be inserted.
#### 💻 Example
```motoko
import Bisect "mo:bisect";
import Nat "mo:base/Nat";

let sortFunc = func <T>(arr : [T], cmp : (T, T) -> Order.Order) : [T] {
    Array.sort<T>(arr, cmp);
};

let sorted = [1, 3, 3, 5];
let index = Bisect.bisect_left(sorted, 3, null, null, Nat.compare);
// index = 1

let index2 = Bisect.bisect_left(sortFunc<Nat>([4, 5, 1, 2, 4], Nat.compare), 4, null, null, Nat.compare);
// index2 = 2
```
---

#### 2. `bisect_right`

```motoko
bisect_right<T>(
  arr: [T],
  x: T,
  lo_opt: ?Nat,
  hi_opt: ?Nat,
  fcmp: (T, T) -> Order.Order
) : Nat
```

- **Purpose:** Finds the **rightmost** insertion point for `x`.
- **Use Case:** Inserts `x` **after** existing entries of the same value.
- **Returns:** Index where `x` should be inserted.

#### 💻 Example
```motoko
import Bisect "mo:bisect";
import Nat "mo:base/Nat";

let sorted = [1, 2, 4, 4, 5];
let index = Bisect.bisect_right(sorted, 6, null, null, Nat.compare);
// index = 5
```
---

#### 3. `insort_left`

```motoko
insort_left<T>(
  arr: [T],
  x: T,
  lo_opt: ?Nat,
  hi_opt: ?Nat,
  fcmp: (T, T) -> Order.Order
) : [T]
```

- **Purpose:** Inserts `x` at the position returned by `bisect_left`.
- **Returns:** A new array with `x` inserted, maintaining order.
- 
#### 💻 Example
```motoko
import Bisect "mo:bisect";
import Nat "mo:base/Nat";

let sorted = [1, 3, 3, 5];
let updated = Bisect.insort_left(sorted, 3, null, null, Nat.compare);
// updated = [1, 3, 3, 3, 5]
```
---

#### 4. `insort_right`

```motoko
insort_right<T>(
  arr: [T],
  x: T,
  lo_opt: ?Nat,
  hi_opt: ?Nat,
  fcmp: (T, T) -> Order.Order
) : [T]
```

- **Purpose:** Inserts `x` at the position returned by `bisect_right`.
- **Returns:** A new array with `x` inserted, maintaining order.

#### 💻 Example
```motoko
import Bisect "mo:bisect";
import Nat "mo:base/Nat";

let sorted = [1, 3, 3, 5];
let updated = Bisect.insort_right(sorted, 3, null, null, Nat.compare);
// updated = [1, 3, 3, 3, 5]
```

---

####  🧠 Parameters

| Name      | Type               | Description |
|-----------|--------------------|-------------|
| `arr`     | `[T]`              | Sorted array of elements |
| `x`       | `T`                | Element to insert or search |
| `lo_opt`  | `?Nat`             | (Optional) Start index for the search |
| `hi_opt`  | `?Nat`             | (Optional) End index for the search |
| `fcmp`    | `(T, T) -> Order`  | Comparator function between two elements |

> 🔎 If `lo_opt` and `hi_opt` are `null`, the entire array is searched by default.


---

#### 💡 Use Cases

- Maintain a dynamically sorted list without full re-sorting.
- Efficient implementation of **priority queues**, **interval trees**, etc.
- Optimize binary search and classification tasks.

---

### Testing

You need mops installed. In your project directory run [Mops](https://mops.one/):

```sh
mops test
```

## License
[MIT](https://github.com/nirvana369/bisect/blob/main/LICENSE)