# Python Interview Workshop Cheat Sheet

Use this as the quick-reference handout for a lab-first Python workshop.

## Workshop Flow

1.  **Core collections:** Lists, tuples, and dictionaries\
2.  **Strings:** Methods, indexing, and slicing\
3.  **Comprehensions:** Filtering, transforming, and nested loops\
4.  **Sets:** Unique values and set operations\
5.  **Object references:** Assignment, shallow copy, deep copy, and
    memory\
6.  **Reliability:** Built-in and custom exception handling\
7.  **Code organization:** Creating and importing custom modules\
8.  **Interview revision:** Short, common Python patterns

## 1. Collections

### List vs Tuple

  Feature       List                Tuple
  ------------- ------------------- ----------------------
  Syntax        `[]`                `()`
  Mutable       Yes                 No
  Typical use   Data that changes   Fixed data
  Methods       Many                `count()`, `index()`

> **Tuple note:** An empty tuple is valid: `empty_tuple = ()`. For a
> one-item tuple, the comma creates the tuple: `single_value = (10,)`.
> Without the comma, `(10)` is simply the integer `10`.
>
> **Interview note:** Lists are mutable; tuples are immutable. A tuple
> can be a dictionary key only when every item inside it is hashable.

### List Methods

``` python
nums = [3, 1, 2]
```

  -----------------------------------------------------------------------
  Method                              One-line explanation
  ----------------------------------- -----------------------------------
  `name_list.append(x)`               Adds `x` to the end of the list.

  `name_list.extend(items)`           Adds every item from another
                                      iterable to the end.

  `name_list.insert(i, x)`            Inserts `x` before index `i`.

  `name_list.remove(x)`               Removes the first matching value;
                                      raises an error if absent.

  `name_list.pop()`                   Removes and returns the last item.

  `name_list.pop(i)`                  Removes and returns the item at
                                      index `i`.

  `name_list.sort()`                  Sorts the original list in place.

  `name_list.reverse()`               Reverses the original list in
                                      place.

  `name_list.index(x)`                Returns the first index containing
                                      `x`.

  `name_list.count(x)`                Returns how many times `x` occurs.

  `name_list.copy()`                  Makes a shallow copy of the list.

  `name_list.clear()`                 Removes every item from the list.
  -----------------------------------------------------------------------

### `sort()` vs `sorted()`

  -----------------------------------------------------------------------
  Feature                 `name_list.sort()`      `sorted(iterable)`
  ----------------------- ----------------------- -----------------------
  Works on                Lists only              Any iterable, such as a
                                                  list, tuple, string, or
                                                  dictionary

  Original object         Changes the original    Leaves the original
                          list                    object unchanged

  Return value            Returns `None`          Returns a new sorted
                                                  list
  -----------------------------------------------------------------------

``` python
numbers = [3, 1, 2]

# sort(): changes the same list
numbers.sort()
print(numbers)  # [1, 2, 3]

# sorted(): creates a new list
numbers = [3, 1, 2]
new_numbers = sorted(numbers)
print(numbers)      # [3, 1, 2]
print(new_numbers)  # [1, 2, 3]
```

``` python
# Common syntax for both
name_list.sort(reverse=True)
new_list = sorted(iterable, reverse=True)
new_list = sorted(iterable, key=len)
```

> **Interview note:** Use `sort()` when you deliberately want to change
> a list. Use `sorted()` when you need a new sorted list or the source
> is not a list.

### Tuple Methods

  -----------------------------------------------------------------------
  Method                              One-line explanation
  ----------------------------------- -----------------------------------
  `data_tuple.count(x)`               Returns how many times `x` occurs
                                      in the tuple.

  `data_tuple.index(x)`               Returns the first index containing
                                      `x`.
  -----------------------------------------------------------------------

### Dictionary Methods

``` python
user = {"name": "Asha", "age": 25}
```

> **Interview note:** Dictionary keys must be unique and hashable.
> Assigning the same key again replaces its earlier value; values can
> repeat.

  --------------------------------------------------------------------------
  Method                                 One-line explanation
  -------------------------------------- -----------------------------------
  `user_dict.get(key, default)`          Returns a value safely, or
                                         `default` when the key is missing.

  `user_dict.keys()`                     Returns a view of all dictionary
                                         keys.

  `user_dict.values()`                   Returns a view of all dictionary
                                         values.

  `user_dict.items()`                    Returns key-value pairs for
                                         iteration.

  `user_dict.update(data)`               Adds or replaces several key-value
                                         pairs.

  `user_dict.pop(key)`                   Removes a key and returns its
                                         value.

  `user_dict.popitem()`                  Removes and returns the last
                                         inserted key-value pair.

  `user_dict.setdefault(key, default)`   Returns a key's value and creates
                                         it with `default` if missing.

  `user_dict.copy()`                     Makes a shallow copy of the
                                         dictionary.

  `user_dict.clear()`                    Removes every key-value pair.
  --------------------------------------------------------------------------

## 2. Strings, Indexing, and Slicing

### String Methods

``` python
text = "  Python Interview  "
```

> **Interview note:** A string does not need unique characters. Strings
> are immutable, so methods such as `replace()` and `strip()` return a
> new string instead of changing the original one.

  -----------------------------------------------------------------------
  Method / operator                   One-line explanation
  ----------------------------------- -----------------------------------
  `text.lower()`                      Converts every letter to lowercase.

  `text.upper()`                      Converts every letter to uppercase.

  `text.title()`                      Capitalizes the first letter of
                                      each word.

  `text.strip()`                      Removes whitespace from both ends.

  `text.lstrip()`                     Removes whitespace from the left
                                      end.

  `text.rstrip()`                     Removes whitespace from the right
                                      end.

  `text.replace(old, new)`            Replaces every occurrence of `old`
                                      with `new`.

  `text.split(separator)`             Splits a string into a list.

  `separator.join(items)`             Combines strings from an iterable
                                      using a separator.

  `text.startswith(prefix)`           Checks whether the string begins
                                      with `prefix`.

  `text.endswith(suffix)`             Checks whether the string ends with
                                      `suffix`.

  `text.find(value)`                  Returns the first index of a value,
                                      or `-1` when absent.

  `text.index(value)`                 Returns the first index of a value,
                                      or raises an error when absent.

  `text.count(value)`                 Counts occurrences of a value.

  `text.isalpha()`                    Checks whether all characters are
                                      letters.

  `text.isdigit()`                    Checks whether all characters are
                                      digits.

  `text.isalnum()`                    Checks whether all characters are
                                      letters or digits.

  `+`                                 Concatenates strings:
                                      `"Py" + "thon"`.

  `*`                                 Repeats a string: `"ha" * 3`.
  -----------------------------------------------------------------------

### Indexing

``` python
name = "Python"
nums = [10, 20, 30, 40, 50]
```

Indexing accesses one item by its position.

  Syntax       One-line explanation
  ------------ ----------------------
  `name[0]`    Gets the first item.
  `name[-1]`   Gets the last item.

### Slicing

Slicing accesses a range of items using `sequence[start:end:step]`.

> **Interview note:** Slicing returns a new sequence. The end index is
> excluded, and negative indexes count from the right.

  Syntax              One-line explanation
  ------------------- --------------------------------------------------
  `name[start:end]`   Gets items from `start` up to, excluding, `end`.
  `name[::2]`         Gets every second item from left to right.
  `name[::-1]`        Reverses a string, list, or tuple in one line.
  `name[5:1:-1]`      Moves right to left using a negative step.

## 3. List Comprehension

> **Interview note:** A list comprehension creates a list in one line.
> It is best for a simple expression, loop, and optional condition; use
> normal loops when the body needs several statements.

### 3.1 Basic Pattern

``` python
# Syntax: output expression comes first; for clause comes last.
[expression for item in iterable]

squares = [n * n for n in range(1, 6)]
# [1, 4, 9, 16, 25]
```

### 3.2 Filter Pattern --- `if` After `for`

``` python
# Syntax: the condition after for decides which items remain.
[expression for item in iterable if condition]

even_squares = [n * n for n in range(1, 11) if n % 2 == 0]
# [4, 16, 36, 64, 100]
```

Use this pattern when you want to **skip** items that do not match the
condition.

### 3.3 Conditional Pattern --- `if/else` Before `for`

``` python
# Syntax: every item remains; the output changes by condition.
[value_if_true if condition else value_if_false for item in iterable]

labels = ["even" if n % 2 == 0 else "odd" for n in range(5)]
# ["even", "odd", "even", "odd", "even"]
```

Use this pattern when you want to **keep every item** but return
different output values.

### 3.4 Nested Pattern --- Outer and Inner Loops

``` python
# Syntax: outer for comes first, followed by each inner for.
[expression for outer_item in outer_iterable for inner_item in inner_iterable]

# The beginning expression can use both variables.
[f"{team}: {member}" for team in teams for member in members]

matrix = [[1, 2], [3, 4]]
flat = [number for row in matrix for number in row]
# [1, 2, 3, 4]

teams = ["Red", "Blue"]
members = ["Asha", "Ravi"]
pairings = [f"{team}: {member}" for team in teams for member in members]
# ["Red: Asha", "Red: Ravi", "Blue: Asha", "Blue: Ravi"]
```

``` python
# Equivalent normal nested loops
result = []
for outer_item in outer_iterable:
    for inner_item in inner_iterable:
        result.append(output_expression)
```

Use normal nested loops when the inner block needs multiple statements,
such as creating a variable, printing a value, and appending a result.

## 4. Set Methods

> **Interview note:** A set stores unique, unordered, hashable items. It
> automatically removes duplicates, and it cannot contain a list or
> dictionary.

  -----------------------------------------------------------------------------
  Method                                    One-line explanation
  ----------------------------------------- -----------------------------------
  `skill_set.add(x)`                        Adds one item to the set.

  `skill_set.update(items)`                 Adds every item from another
                                            iterable.

  `skill_set.remove(x)`                     Removes `x`; raises an error if it
                                            is missing.

  `skill_set.discard(x)`                    Removes `x` without raising an
                                            error if it is missing.

  `skill_set.pop()`                         Removes and returns an arbitrary
                                            item.

  `skill_set.union(other)`                  Returns all unique items from both
                                            sets.

  `skill_set.intersection(other)`           Returns items common to both sets.

  `skill_set.difference(other)`             Returns items present only in the
                                            first set.

  `skill_set.symmetric_difference(other)`   Returns items found in exactly one
                                            of the sets.
  -----------------------------------------------------------------------------

## 5. Assignment, References, and Copies

``` python
a = [1, 2, 3]
b = a                 # b points to the same list
c = a.copy()          # c is a new outer list
```

`a = b` copies a reference, so changing a mutable object through either
name changes the same object.

> **Interview note:** Use `is` to compare object identity and `==` to
> compare values.

``` python
import copy

original = [[1, 2], 3, [4, 5]]
assignment = original
shallow_copy = copy.copy(original)
deep_copy = copy.deepcopy(original)
```

  -----------------------------------------------------------------------
  Type                                One-line explanation
  ----------------------------------- -----------------------------------
  Assignment: `b = a`                 No new list memory is created; both
                                      names point to the same outer and
                                      inner objects.

  Shallow copy                        Creates memory for a new outer
                                      list, but its nested lists still
                                      point to the original inner-list
                                      memory.

  Deep copy                           Creates memory for a new outer list
                                      and new memory for every nested
                                      inner list.
  -----------------------------------------------------------------------

### Assignment: Original List First, Then `b = a`

``` mermaid
flowchart LR
    A[Original list: variable a] --> OUTER[Outer-list memory<br/>Memory 1]
    B[Assignment: variable b] --> OUTER
    OUTER --> INNER1[Inner-list memory<br/>Memory 2]
    OUTER --> DIRECT[Direct integer value<br/>3]
    OUTER --> INNER2[Inner-list memory<br/>Memory 3]
    INNER1 --> V1[1]
    INNER1 --> V2[2]
    INNER2 --> V4[4]
    INNER2 --> V5[5]
```

Both names point to the same outer list and the same inner lists.

### Shallow Copy: Original List First, Then `b = a.copy()`

``` mermaid
flowchart LR
    subgraph A[A: Original list]
        A_VAR[variable a] --> OUTER_A[Outer-list A memory<br/>Memory 1]
    end
    subgraph B[B: Shallow-copy list]
        B_VAR[variable b] --> OUTER_B[Outer-list B memory<br/>New Memory 4]
    end
    OUTER_A --> INNER1[Shared inner-list memory<br/>Memory 2]
    OUTER_A --> DIRECT[Shared direct integer<br/>3]
    OUTER_A --> INNER2[Shared inner-list memory<br/>Memory 3]
    OUTER_B --> INNER1
    OUTER_B --> DIRECT
    OUTER_B --> INNER2
    INNER1 --> V1[1]
    INNER1 --> V2[2]
    INNER2 --> V4[4]
    INNER2 --> V5[5]
```

The outer list is new, but both outer lists share the same inner lists.

### Deep Copy: Original List First, Then `b = copy.deepcopy(a)`

``` mermaid
flowchart LR
    subgraph A[A: Original list]
        A_VAR[variable a] --> OUTER_A[Outer-list A memory<br/>Memory 1]
        OUTER_A --> INNER_A1[Inner-list memory<br/>Memory 2]
        OUTER_A --> DIRECT[Direct integer value<br/>3]
        OUTER_A --> INNER_A2[Inner-list memory<br/>Memory 3]
        INNER_A1 --> A_V1[1]
        INNER_A1 --> A_V2[2]
        INNER_A2 --> A_V4[4]
        INNER_A2 --> A_V5[5]
    end
    subgraph B[B: Deep-copy list]
        B_VAR[variable b] --> OUTER_B[Outer-list B memory<br/>New Memory 4]
        OUTER_B --> INNER_B1[Inner-list memory<br/>New Memory 5]
        OUTER_B --> DIRECT
        OUTER_B --> INNER_B2[Inner-list memory<br/>New Memory 6]
        INNER_B1 --> B_V1[1]
        INNER_B1 --> B_V2[2]
        INNER_B2 --> B_V4[4]
        INNER_B2 --> B_V5[5]
    end
```

The outer list and every inner list are new and independent.

> **Interview note:** The direct value `3` is an immutable integer. Even
> `copy.deepcopy()` normally reuses immutable values; it creates new
> objects for the mutable nested lists.

### Effect of Changing an Inner List

``` python
original = [[1, 2], 3, [4, 5]]
shallow_copy = copy.copy(original)
deep_copy = copy.deepcopy(original)

original[0].append(99)

print(shallow_copy)  # [[1, 2, 99], 3, [4, 5]]
print(deep_copy)     # [[1, 2], 3, [4, 5]]
```

  -----------------------------------------------------------------------
  Copy type                           When an inner list in `original`
                                      changes
  ----------------------------------- -----------------------------------
  Assignment                          The change appears because both
                                      names use the same outer list.

  Shallow copy                        The change appears because both
                                      outer lists share the same inner
                                      lists.

  Deep co                             The change does not appear because
                                      it has separate inner lists.
  -----------------------------------------------------------------------

## 6. Memory Management

-   Variables store references to objects, not the objects themselves.
-   Mutable objects include lists, dictionaries, and sets; they can
    change in place.
-   Immutable objects include integers, strings, and tuples; a "change"
    creates a new object.
-   Python primarily reclaims memory through reference counting.
-   Its garbage collector handles unreachable circular references.
-   `id(value)` returns an object's identity for reference comparisons.

``` python
a = [1, 2]
b = a
print(id(a) == id(b))  # True
```

### Reference Counting Example

``` python
data = [10, 20]
first_alias = data
second_alias = data

# The same list object is referenced by: data, first_alias, and second_alias.
print(data is first_alias is second_alias)  # True
```

In CPython, every reference increases an object's reference count. When
the count reaches zero, Python can reclaim that object's memory.

``` python
import sys

data = [10, 20]
alias = data
print(sys.getrefcount(data))  # Usually 3: data, alias, and this function call
```

### Ordered, Mutable, and Immutable Types

  -----------------------------------------------------------------------
  Type              Ordered?          Mutable?          Memory behavior
  ----------------- ----------------- ----------------- -----------------
  List              Yes               Yes               Changes such as
                                                        `append()` modify
                                                        the same list
                                                        object.

  Tuple             Yes               No                A change creates
                                                        a new tuple
                                                        object.

  String            Yes               No                A change such as
                                                        concatenation
                                                        creates a new
                                                        string object.

  Dictionary        Yes, insertion    Yes               Adding or
                    order from Python                   changing a key
                    3.7+                                modifies the same
                                                        dictionary
                                                        object.

  Set               No                Yes               Items have no
                                                        fixed position;
                                                        adding or
                                                        removing modifies
                                                        the same set
                                                        object.
  -----------------------------------------------------------------------

> **Interview note:** "Ordered" means elements retain a predictable
> position for indexing or iteration. Dictionaries preserve insertion
> order, but they are accessed by keys rather than numeric indexes. Sets
> are unordered and cannot be indexed.

## 7. Custom Exception Handling

Python has built-in exceptions such as `ValueError`, `TypeError`, and
`ZeroDivisionError`. Sometimes, an application needs an error type that
describes a specific business rule. We can create this using a
**user-defined exception** (also called a custom exception).

### 7.1 What Is the Base Class of Exceptions?

Python's exception hierarchy starts with `BaseException`.

``` text
BaseException
├── SystemExit
├── KeyboardInterrupt
└── Exception
    ├── ValueError
    ├── TypeError
    ├── ZeroDivisionError
    ├── FileNotFoundError
    └── User-defined exceptions
```

-   **`BaseException`** is the top-level base class for all exceptions
    in Python.
-   **`Exception`** is the base class for most ordinary application
    errors and is the class that custom exceptions should normally
    inherit from.
-   Avoid inheriting directly from `BaseException` for normal
    application errors. Doing so can make them bypass common
    `except Exception:` handlers.

### 7.2 How to Create a User-Defined Exception

A custom exception is created by defining a class that inherits from
`Exception`.

``` python
class InvalidAgeError(Exception):
    pass
```

Explanation:

-   `class` defines a new class.
-   `InvalidAgeError` is the name of our custom exception.
-   `(Exception)` means the custom class inherits from Python's built-in
    `Exception` class.
-   `pass` means the class has no extra implementation yet.

This creates the **exception class**, not an exception object. An object
is created when we call the class, for example:
`InvalidAgeError("Age must be at least 18")`.

### 7.3 Creating an Exception Object with a Constructor

A constructor lets us initialize the exception object with a message or
additional information. In Python, `__init__()` initializes a new
object.

``` python
class InvalidAgeError(Exception):
    def __init__(self, age, minimum_age=18):
        self.age = age
        self.minimum_age = minimum_age

        message = f"Age must be at least {minimum_age}; received {age}."
        super().__init__(message)
```

Line-by-line explanation:

  --------------------------------------------------------------------------------
  Code                                         Meaning
  -------------------------------------------- -----------------------------------
  `class InvalidAgeError(Exception):`          Defines a custom exception class
                                               derived from `Exception`.

  `def __init__(self, age, minimum_age=18):`   Initializes each new exception
                                               object with the supplied age and
                                               minimum age.

  `self.age = age`                             Saves the supplied age on the
                                               object.

  `self.minimum_age = minimum_age`             Saves the minimum permitted age on
                                               the object.

  `message = ...`                              Builds a readable error message.

  `super().__init__(message)`                  Calls the parent `Exception`
                                               constructor so the message is
                                               available through `str(error)`.
  --------------------------------------------------------------------------------

**Remember:** `self` refers to the current object. `super()` gives
access to the parent class, which is `Exception` in this example.

### 7.4 How to Raise and Handle a User-Defined Exception

Example: a registration system requires a person to be at least 18 years
old.

``` python
class InvalidAgeError(Exception):
    def __init__(self, age, minimum_age=18):
        self.age = age
        self.minimum_age = minimum_age
        message = f"Age must be at least {minimum_age}; received {age}."
        super().__init__(message)


def register(age):
    if age < 18:
        raise InvalidAgeError(age)

    return "Registration successful"


try:
    result = register(16)
    print(result)
except InvalidAgeError as error:
    print("Registration failed:", error)
    print("Received age:", error.age)
    print("Minimum age:", error.minimum_age)
else:
    print("Registration completed without an error.")
finally:
    print("Validation completed.")
```

**Output:**

``` text
Registration failed: Age must be at least 18; received 16.
Received age: 16
Minimum age: 18
Validation completed.
```

Why does this happen?

1.  `register(16)` calls the function with an age of 16.
2.  The condition `age < 18` is true.
3.  `raise InvalidAgeError(age)` creates an `InvalidAgeError` object and
    raises it. Normal execution of `register()` stops at this line.
4.  Python looks for a matching `except` block.
    `except InvalidAgeError as error` catches this specific exception
    and stores the exception object in `error`.
5.  `error` can be used to read the message and custom attributes such
    as `error.age`.
6.  Because an exception was raised, the `else` block does not run. The
    `finally` block runs whether an exception occurs or not.

If we call `register(21)`, the function returns
`"Registration successful"`. The `else` block then runs, followed by
`finally`.

### 7.5 A Simpler Example Without a Custom Constructor

A constructor is optional when the exception does not need custom
attributes.

``` python
class InvalidPinError(Exception):
    pass


def validate_pin(pin):
    if len(pin) != 4:
        raise InvalidPinError("PIN must contain exactly 4 characters.")

    return "PIN accepted"


try:
    print(validate_pin("123"))
except InvalidPinError as error:
    print(error)
```

Output:

``` text
PIN must contain exactly 4 characters.
```

Here, the inherited `Exception` constructor accepts the message, so we
do not need to write our own `__init__()`.

### 7.6 Quick Reference

  -----------------------------------------------------------------------
  Syntax                              Explanation
  ----------------------------------- -----------------------------------
  `class MyError(Exception):`         Defines a user-defined exception
                                      class.

  `MyError("message")`                Creates an exception object with a
                                      message.

  `def __init__(self, ...):`          Initializes the object with custom
                                      data.

  `super().__init__(message)`         Passes the message to the parent
                                      `Exception` class.

  `raise MyError("message")`          Raises the exception object.

  `except MyError as error:`          Catches that exception type and
                                      gives access to its object.

  `str(error)` or `print(error)`      Gets/displays its message.

  `error.age`                         Reads a custom attribute, if the
                                      class defines it.
  -----------------------------------------------------------------------

### 7.7 `try`, `except`, `else`, `finally`, and `raise`

  -----------------------------------------------------------------------
  Keyword                             Explanation
  ----------------------------------- -----------------------------------
  `try`                               Contains code that might raise an
                                      exception.

  `except`                            Handles an exception matching the
                                      specified type.

  `else`                              Runs only if the `try` block
                                      finishes without an exception.

  `finally`                           Runs whether an exception occurs or
                                      not; often used for cleanup.

  `raise`                             Raises an exception explicitly.
  -----------------------------------------------------------------------

### Note: When Do `else` and `finally` Run?

Remember these three cases:

| What happens in `try` | Does `except` run? | Does `else` run? | Does `finally` run? |
|---|---|---|---|
| No exception occurs | No | Yes | Yes |
| An exception occurs and a matching `except` handles it | Yes | No | Yes |
| An exception occurs but no matching `except` handles it | No matching handler | No | Yes, before the exception continues propagating |

**Easy rule to remember:**
- `else` runs only when the `try` block completes without an exception.
- `except` runs when an exception occurs and matches that handler.
- `finally` runs whether an exception occurs or not, including when an exception is handled by `except`.

### Important Exception Notes

-   Catch specific exceptions before broad ones: write
    `except ValueError:` before `except Exception:`.
-   Avoid a bare `except:` because it can hide unexpected problems.
-   Use `else` for code that should run only when the `try` block
    succeeds.
-   Use `finally` for cleanup, such as closing a file or database
    connection.
-   Use `raise` again inside an `except` block to re-raise the current
    error.
-   Use `raise NewError("message") from error` to preserve the original
    error as the cause.
-   Built-in exceptions include `ValueError`, `TypeError`, `KeyError`,
    `IndexError`, `FileNotFoundError`, and `ZeroDivisionError`.

## 8. Creating Custom Modules and Packages

A **module** is a single Python file (`.py`). A **package** organizes related modules into folders. Packages help keep larger projects structured and reusable.

### 8.1 Creating a Simple Module

Create these two files in the same folder.

#### `calculator.py`

```python
def add(a, b):
    return a + b


def subtract(a, b):
    return a - b
```

#### `main.py`

```python
import calculator

print(calculator.add(10, 5))
print(calculator.subtract(10, 5))
```

Run `main.py` from the folder containing both files:

```bash
python main.py
```

Output:

```text
15
5
```

### 8.2 Creating a Package Using Different Folders

Suppose we want to organize addition and subtraction into a package. Create this structure:

```text
python_project/
├── main.py
└── math_operations/
    ├── __init__.py
    ├── addition.py
    └── subtraction.py
```

- `python_project/` is the project root.
- `math_operations/` is the package folder.
- `addition.py` and `subtraction.py` are modules inside the package.
- `__init__.py` can initialize the package and expose selected functions.
- `main.py` imports and uses the package.

#### File 1: `math_operations/addition.py`

```python
def add(a, b):
    return a + b
```

#### File 2: `math_operations/subtraction.py`

```python
def subtract(a, b):
    return a - b
```

#### File 3: `math_operations/__init__.py`

```python
from .addition import add
from .subtraction import subtract
```

The `.` in these imports means “from the current package.” These lines make `add` and `subtract` available directly from `math_operations`.

The `__init__.py` file can also be empty. Modern Python supports namespace packages without this file, but including it is a common way to define a regular package.

#### File 4: `main.py`

```python
from math_operations import add, subtract

print(add(10, 5))
print(subtract(10, 5))
```

Run the command from the `python_project/` folder:

```bash
python main.py
```

Output:

```text
15
5
```

### 8.3 What Is the Use of `__init__.py`?

The `__init__.py` file has two common uses:

1. **Package initialization:** Python executes the package's `__init__.py` when the package is imported. It can contain setup code or be left empty.
2. **Simplifying imports:** It can import selected functions or classes so users can import them directly from the package.

Without re-exporting the functions in `__init__.py`, import them directly from their modules:

```python
from math_operations.addition import add
from math_operations.subtraction import subtract
```

With the imports defined in `__init__.py`, the import can be shorter:

```python
from math_operations import add, subtract
```

`__init__.py` does **not** automatically import every Python file in the folder. You choose which names to expose.

### 8.4 Understanding `from .addition import add`

| Part | Meaning |
|---|---|
| `from` | Specifies the source to import from. |
| `.` | The current package; this is a relative import. |
| `addition` | The `addition.py` module. |
| `import add` | Imports the `add()` function. |

### 8.5 Creating Subpackages

A package can contain other packages, called **subpackages**. For example:

```text
banking_app/
├── main.py
├── accounts/
│   ├── __init__.py
│   ├── savings.py
│   └── current.py
└── payments/
    ├── __init__.py
    ├── upi.py
    └── card.py
```

Here, `accounts` and `payments` organize different parts of the banking application.

#### `payments/upi.py`

```python
def make_payment(amount):
    return f"UPI payment of ₹{amount}"
```

#### `main.py`

```python
from payments.upi import make_payment

print(make_payment(500))
```

Output:

```text
UPI payment of ₹500
```

Run `main.py` from the `banking_app/` project root.

### 8.6 Module vs Package

| Term | Meaning | Example |
|---|---|---|
| Module | A single Python file | `addition.py` |
| Package | A folder organizing modules | `math_operations/` |
| Subpackage | A package inside another package | `banking_app/payments/` |
| `__init__.py` | Optional package initialization and import organization file for modern Python; used to define a regular package | `math_operations/__init__.py` |
| Relative import | An import relative to the current package | `from .addition import add` |
| Absolute import | An import using the package's full name from the import root | `from math_operations.addition import add` |

> **Interview note:** Run a project from its intended root folder so Python can locate the package. `__init__.py` can be empty, or it can expose selected functions and classes for simpler imports.

## 9. Rapid Interview Snippets

``` python
# Reverse a string or list
value[::-1]

# Swap two variables
a, b = b, a

# Palindrome test
text == text[::-1]

# Frequency counter
frequency = {}
for char in text:
    frequency[char] = frequency.get(char, 0) + 1
```
