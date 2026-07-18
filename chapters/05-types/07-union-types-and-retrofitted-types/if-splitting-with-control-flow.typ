#import "/prelude.typ": *

== If-Splitting with Control Flow

This pattern, of dispatching based on type-tests and values, is quite common in dynamic (or "scripting") languages. These languages do not have a static type system, but they do have safe run-times, which attach type tags to values and provide predicates that can check them. Programmers then adopt programming patterns that take advantage of this.

#aside[
  The term _dynamic_ language seems to have no clear fixed definition. It means, at least, that the language doesn't have static types. Sometimes it's implicit that the language is nevertheless safe. But some people use it to mean that the language has features that let you do things like inspect or even modify the program as it's running (features like `eval`). In this book I use it in the second sense: not-statically typed, but still safe.
]

#aside[
  What, then, is a "scripting" language? I use the term to mean a dynamic language that is also very liberal with its types: e.g., many operations are either overloaded and/or very forgiving of what a statically-typed language would consider an error. Scripting languages tend to be dynamic in all three senses: they do not have a static type-system, they are safe, and they tend to have rich features for introspection and even modification. They are designed to maximize expressiveness and thus minimize just about any useful static analysis.
]

For instance, here's an example from JavaScript, of a serialization function. A serializer takes a value of (almost) _any_ type and converts it into a string to be stored or transmitted. (This version is adapted from version 1.6.1 of Prototype.js.)

```
function serialize(val) {
  switch (typeof val) {
    case "undefined":
    case "function": 
      return false;
    case "boolean":
      return val ? "true" :
                   "false";
    case "number":
      return "" + val;
    case "string":
      return val;
  }
  if (val === null)
    { return "null"; } 

  var fields = [ ];
  for (var p in val) {
    var v = serialize(val[p]);
    if (typeof v === "string") {
      fields.push(p + ": " + v);
    }
  }
  return "{ " + 
         fields.join(", ") + 
         " }";
}
```

Now suppose we're trying to retrofit a type system onto JavaScript. We would need to type-check such programs. But before we even ask _how_ to do it, we should know what answer to expect: i.e., is this program even type-safe?

The answer is quite subtle. It uses JavaScript's `typeof` operator to check the tags. For two kinds of values, it returns `false` (that is, the type of this function is not `Any -> String`, it's actually `Any -> (String U Boolean)`, where the `false` value is used to signal that the value can't be serialized---observe that an actual `false` value is serialized to `"false"`). For Booleans, numbers, and strings, it translates them appropriately into strings. In all these cases, execution returns. (Note, however, that the code also exploits JavaScript's "fall-through" behavior in `switch`, so that `"undefined"` and `"function"` are treated the same without having to repeat code. The type-checker needs to understand this part of JavaScript semantics.)

If none of these cases apply, then execution falls through; we need to know enough JavaScript to know that this corresponds to the one other return from `typeof`, namely objects. Now the code splits between objects that are and aren't `null`. In the non-`null` case, it iterates through each field, serializing it in turn. Therefore, this program is actually type-safe…but for very complicated reasons!
