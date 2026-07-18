#import "/prelude.typ": *

== Class Extensions: Mixins and Traits

When we write `class` in Java, what are we really defining between the opening and closing braces? It is not the entire class: that depends on the parent that it extends, and so on recursively. Rather, what we define inside the braces is a class _extension_. It only becomes a full-blown class because we also identify the parent class in the same place.

Naturally, we should ask: Why? Why not separate the act of _defining_ an extension from _applying_ the extension to a base class? That is, suppose instead of

```
class C extends B { ... }
```

we instead write:

```
classext E { ... }
```

and separately

```
class C = E(B)
```

where `B` is some already-defined class?

Thus far, it looks like we've just gone to great lengths to obtain what we had before. However, the function-application-like syntax is meant to be suggestive: we can "apply" this extension to several different base classes. Thus:

```
class C1 = E(B1);
class C2 = E(B2);
```

and so on. What we have done by separating the definition of `E` from that of the class it extends is to liberate class extensions from the tyranny of the fixed base class. We have a name for these extensions: they're called _mixins_.

Mixins make class definition more compositional. They provide many of the benefits of multiple-inheritance (reusing multiple fragments of functionality) but within the aegis of a single-inheritance language (i.e., no complicated rules about lookup order). Observe that when desugaring, it's actually quite easy to add mixins to the language. A mixin is just a "function over classes". Because we have already determined how to desugar classes, and our target language for desugaring also has functions, and classes desugar to expressions that can be nested inside functions, it becomes almost trivial to implement a simple model of mixins.

#aside[
  This is a case where the greater generality of the target language of desugaring can lead us to a _better_ construct, if we reflect it back into the source language.
]

In a typed language, a good design for mixins can actually improve object-oriented programming practice. Suppose we're defining a mixin-based version of Java. If a mixin is effectively a class-to-class function, what is the "type" of this "function"? Clearly, mixins ought to use _interfaces_ to describe what they expect and what they provide. Java already enables (but does not require) the latter, namely classes can say what interfaces they provide. However, it does not enable the former, namely specifying its parent as an _interface_: a class (extension) in Java extends its parent class---with all the parent's members visible to the extension---rather than an interface that _stands for_ the parent (or any _other_ class that matches that same interface). That means it obtains all of the parent's behavior, not a specification thereof. In turn, if the parent changes, the class might break. Mixins help break this asymmetry between extension and provision.

In a mixin language, we can instead write

```
mixin M extends I1 implements I2 { ... }
```

where `I1` and `I2 `are interfaces. Then `M` can only be applied to a class that satisfies the interface `I1`, and in turn the language can ensure that only members specified in` I1` are visible in `M`. This becomes directly analogous to how a client of `M` can only see what is provided by `I2`, and follows one of the important principles of good software design:

#callout("Quote:")["Program to an interface, not an implementation." ---#link("https://en.wikipedia.org/wiki/Design_Patterns")[Design Patterns]]

In short, a mixin is a class that has been turned into a function over parent classes:

```
M :: I1 -> I2
```

A good design for mixins can go even further. A class can only be used once in an inheritance chain, by definition (if a class eventually referred back to itself, there would be a cycle in the inheritance chain, causing potential infinite loops). In contrast, when we compose functions, we have no qualms about using the same function twice (e.g.: `(map ... (filter ... (map ...))))`. Is there value to using a mixin twice?

#aside[
  There certainly is! See sections 3 and 4 of #link("http://www.cs.brown.edu/~sk/Publications/Papers/Published/fkf-classes-mixins/")[Classes and Mixins].
]

Mixins solve an important problem that arises in the design of libraries. Suppose we have a dozen different features which can be combined in different ways. How many classes should we provide? Furthermore, not all of these can be combined with each other. It is obviously impractical to generate the entire combinatorial explosion of classes. It would be better if the developer could pick and choose the features they care about, with some mechanism to prevent unreasonable combinations. This is precisely the problem that mixins solve: they provide the class extensions, which the developers can combine, in an interface-preserving way, to create just the classes they need.

#aside[
  Mixins are used extensively in the Racket GUI library. For instance, `color:text-mixin` consumes basic text editor interfaces and implements the colored text editor interface. The latter is itself a basic text editor interface, so additional basic text mixins can be applied to the result.
]

#callout("Exercise:")[How does the analogous library in your favorite object-oriented language solve this same problem?]

Mixins do have one limitation: they enforce a linearity of composition. This strictness is sometimes misplaced, because it puts a burden on programmers that may not be necessary. A generalization of mixins called _traits_ says that instead of extending a single mixin, we can extend a set of them. Of course, the moment we extend more than one, we must again contend with potential name-clashes. Thus traits must be equipped with mechanisms for resolving name clashes, often in the form of some name-combination algebra. Traits thus offer a nice complement to mixins, enabling programmers to choose the mechanism that best fits their needs. As a result, Racket provides both mixins and traits.
