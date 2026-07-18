#import "/prelude.typ": *

== Client-Side Termination

On the client-side Web, in JavaScript, we see the same phenomenon, but for a completely different reason. Imagine we write a factorial computation in JavaScript:

```
function fact(n) {
  ans = 1;
  while (n != 0) {
    ans = ans * n;
    n = n - 1;
  }
  return ans;
}
```

Notice that the loop checks for `n != 0` and not `n > 0`, so if we put this in a Web page and run it, the program will in principle run forever:

```
<script type="application/javascript">
function fact(n) {
  ans = 1;
  while (n != 0) {
    ans = ans * n;
    n = n - 1;
  }
  return ans;
}
function show() {
  window.alert('here');
  ans = fact(-1);
  window.alert(ans);
  document.getElementById('answer').innerHTML = ans;

}
</script>
</head>

<body>
<button onclick="show()">Click me</button>
<div id="answer"></div>
```

However, this creates a problem: the JavaScript virtual machine runs only one computation at a time, and the same JavaScript virtual machine also manages the page and the browser's components. Therefore, if the program inside a page goes into an infinite loop, the entire page stops being responsive. For this reason, after a little while, the browser will pop up a window offering to kill the computation.

There is a solution to this in JavaScript, but it is hardly elegant. The programmer creates a closure---called a _callback_---that represents the rest of the computation. The programmer then calls

```
setTimeout(C, 0)
```

or, in more modern programs,

```
requestAnimationFrame(C)
```

(though the former version perhaps makes a bit clearer what is happening), where `C` is the callback. This creates an event to run `C` as soon as possible (after `0` units of time). The programmer then---does this sound familiar?---_terminates the program_. This returns control to the JavaScript virtual machine. It runs any other pending events, then arrives at this event, which it runs immediately---i.e., it "calls back" into the computation using `C`. If `C` was constructed correctly, then this properly resumes the computation, as if it had never halted. Phew!
