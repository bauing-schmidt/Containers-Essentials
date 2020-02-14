This repository collects implementations of (not so common) data structures and algorithms over them.

Our aim is purely educational although we strive for elegance and correctness.

The following data structures are currently provided:
- Graphs
- [BitArrays](/BitArrays.md)
- Heaps
   - [Leftist](https://github.com/massimo-nocentini/dsst/wiki/Leftist-Heaps)
   - [Binomial](https://github.com/massimo-nocentini/dsst/wiki/Binomial-Heaps)
- [Skew Binary (Canonical) Numbers](https://github.com/massimo-nocentini/dsst/wiki/Skew-Binary-Numbers)
   - [Skew Binary Random Access Lists (SBRALs)](https://github.com/massimo-nocentini/dsst/wiki/Skew-Binary-Random-Access-Lists-(SBRALs))


This is just a simple test to see if math works properly 

$$
\begin{align*}
  & \phi(x,y) = \phi \left(\sum_{i=1}^n x_ie_i, \sum_{j=1}^n y_je_j \right)
  = \sum_{i=1}^n \sum_{j=1}^n x_i y_j \phi(e_i, e_j) = \\
  & (x_1, \ldots, x_n) \left( \begin{array}{ccc}
      \phi(e_1, e_1) & \cdots & \phi(e_1, e_n) \\
      \vdots & \ddots & \vdots \\
      \phi(e_n, e_1) & \cdots & \phi(e_n, e_n)
    \end{array} \right)
  \left( \begin{array}{c}
      y_1 \\
      \vdots \\
      y_n
    \end{array} \right)
\end{align*}
$$
