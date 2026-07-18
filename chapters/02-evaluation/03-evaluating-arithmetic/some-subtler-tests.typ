#import "/prelude.typ": *

== Some Subtler Tests

Try the following test:

```
(test (calc (plus (num 0.1) (num 0.2))) 0.3)
```

It succeeds! Are we happy? Suppose we instead write it as:

```
(test (calc (plus (num 0.1) (num 0.2))) 1/3)
```

As expected, it fails: but the error message reveals that the left-hand side evaluated to 0.30000000000000004. This should be a cue that we have actually gotten #link("https://0.30000000000000004.com/")[floating point] addition. This is because plait treats numbers written with a decimal point, like `0.1`, as _floating point_ bitstrings. However, floating point bitstrings cannot precisely represent the number 0.3. In fact, plait's `test` allows a little bit of numeric slack so that the passing test above works. (This is because in plait, `0.3` really does precisely represent the number 0.3, because it was written literally and not the result of a floating-point computation.)

This reinforces a point we made in passing above and was therefore easy to miss: by adopting plait's primitives, we have also inherited its semantics. This may or may not be what we wanted! Therefore, when writing an evaluator using a host language, we have to make sure that its semantics are the one we want, otherwise we could be in for an unpleasant surprise. If we want different behavior, we have to implement it explicitly.
