#import "/prelude.typ": *

== Evaluation Strategies

Back when we began to study evaluation #iconlink(<chapters:02-evaluation:01-evaluation-on-paper>), we saw that we had a choice when performing evaluation. During function application, we could substitute the actual parameter as an _expression_ or as a _value_. At that time, we indicated that SMoL is eager. Now we will investigate the other option, laziness.

Consider the #link("https://smol-tutor.xyz/stacker/?syntax=Lispy&randomSeed=defvar&hole=%E2%80%A2&nNext=0&program=%28deffun+%28f+x%29%0A++%28g+%28%2B+x+x%29%29%29%0A%0A%28deffun+%28g+y%29%0A++%28h+%28*+y+2%29%29%29%0A%0A%28deffun+%28h+x%29%0A++%28%2B+x+5%29%29%0A%0A%28f+%28%2B+2+3%29%29%0A")[following program]:

```
(deffun (f x)
  (g (+ x x)))

(deffun (g y)
  (h (* y 2)))

(deffun (h x)
  (+ x 5))

(f (+ 2 3))
```

When run eagerly in the Stacker, we see #link("https://smol-tutor.xyz/stacker/?syntax=Lispy&randomSeed=defvar&hole=%E2%80%A2&nNext=4&program=%28deffun+%28f+x%29%0A++%28g+%28%2B+x+x%29%29%29%0A%0A%28deffun+%28g+y%29%0A++%28h+%28*+y+2%29%29%29%0A%0A%28deffun+%28h+x%29%0A++%28%2B+x+5%29%29%0A%0A%28f+%28%2B+2+3%29%29%0A")[calls like]

#image("/images/image8.png", width: 190pt)

where the environment contents look like

#image("/images/image16.png", width: 195pt)

Both the call and the environment reinforce that parameters are evaluated _before_ the function body begins to execute, so names are bound to _values_.
