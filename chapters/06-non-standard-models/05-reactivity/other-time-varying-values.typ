#import "/prelude.typ": *

== Other Time-Varying Values

So far we have seen only one basic time-varying value, `seconds`. FrTime provides many others. For instance, `mouse-pos` is the current position of the mouse. If we run the following program:

```
(require frtime/animation)

(display-shapes
 (list
  (make-circle mouse-pos 10 "blue")))
```

we see a blue circle, and it _automatically_ follows the mouse.

The function `display-shapes` in the FrTime animation library takes a list of shapes; above, we have only one. This function builds a list of (four) circles whose positions are determined by the mouse's location, except each one is _delayed_, i.e., represents where the mouse used to be. (One might call this the Rhode Island mouse.) Therefore, as the mouse moves these circles appear to "follow" it around.

```
(display-shapes
 (let ([n 4])
   (build-list
    n
    (lambda (i)
      (make-circle (delay-by mouse-pos (* 200 (- (- n 1) i)))
                   10
                   "green")))))
```
