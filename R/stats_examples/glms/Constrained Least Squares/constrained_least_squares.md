> **Constrained Least Squares -- Coefficient Calculation and
> Simulation**
>
> We want to maximize the likelihood equation of β. We know that Y in
> this context is normally distributed with mean Xβ and variance σ^2^.
> This means that the distribution of yi given X is as follows:

$$f_{Y}\left( \mathbf{y}_{i} \middle| X \right) = {(2\pi\sigma^{2})}^{- 1/2}e^{\frac{\mathbf{- (y}_{\mathbf{i}}\mathbf{-}\mathbf{x}_{\mathbf{i}}\mathbf{\beta)}}{2\mathbf{\sigma}^{\mathbf{2}}}^{\mathbf{2}}}$$

> So the likelihood of β is therefore:

$$L\left( \beta,\sigma^{2} \middle| y,X \right) = \left( 2\pi\sigma^{2} \right)^{- \frac{N}{2}}e^{- \frac{\sum_{\mathbf{i}}^{\mathbf{N}}{\mathbf{(y}_{\mathbf{i}}\mathbf{-}\mathbf{x}_{\mathbf{i}}\mathbf{\beta)}}}{2\mathbf{\sigma}^{\mathbf{2}}}^{\mathbf{2}}}$$

> Taking the natural logarithm gives us the log likelihood:

$$l\left( \beta,\sigma^{2} \middle| y,X \right) = - \frac{1}{2\sigma^{2}}\sum_{\mathbf{i}}^{\mathbf{N}}{{\mathbf{(y}_{\mathbf{i}}\mathbf{-}\mathbf{x}_{\mathbf{i}}\mathbf{\beta)}}^{\mathbf{2}}\mathbf{-}\frac{N}{2}\text{\ ln}\left( \sigma^{2} \right)\mathbf{+ C}}\mathbf{=} - \frac{1}{2\sigma^{2}}\left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right)^{'}\left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right) - \frac{N}{2}\text{\ ln}\left( \sigma^{2} \right)\mathbf{+ C}$$

> Here, I have truncated the result to only those involving **β** and
> $\sigma^{2}$, as we are only interested in maximizing with respect to
> **β**. Note that I have transitioned $\sigma^{2}$ to a constant, as we
> are assuming the errors are iid with constant variance $\sigma^{2}$.
> Here, we obtain the same result as minimizing the least squares
> estimator, so the MLE and the least squares estimators are the same.
> If we were unconstrained, we would simply take the partial derivative
> here with respect to **β** to estimate **β** using maximum likelihood.
>
> Since $\sigma^{2}$ is unconstrained, we can find the maximum
> likelihood estimator directly and use this to maximize with respect to
> **β.** To do this, we differentiate the above equation with respect to
> σ. Doing so yields the normal estimate for $\sigma^{2}$:

$${\widehat{\sigma}}^{2} = - \frac{1}{N}\sum_{\mathbf{i}}^{\mathbf{N}}{\mathbf{(y}_{\mathbf{i}}\mathbf{-}\mathbf{x}_{\mathbf{i}}\mathbf{\beta}^{\mathbf{c}}\mathbf{)}}^{\mathbf{2}}\mathbf{=}\frac{\mathbf{1}}{\mathbf{N}}\left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right)^{'}\left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right)$$

Where $\mathbf{\beta}^{\mathbf{c}}$ is our new constrained estimates.
Plugging this back into the log likelihood equation yields:

$$l\left( \mathbf{\beta}^{\mathbf{c}} \middle| \mathbf{y},X \right) = - \frac{1}{- \frac{2}{N}\left( y - X\mathbf{\beta}^{\mathbf{c}} \right)^{'}\left( y - X\mathbf{\beta}^{\mathbf{c}} \right)}\left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right)^{'}\left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right) - \frac{N}{2}\text{\ ln}\left( \frac{1}{N}\left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right)^{'}\left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right) \right)\mathbf{+ C}$$

$$l\left( \beta \middle| y,X \right) = - \frac{N}{2} - \frac{N}{2}\text{\ ln}\left( \frac{1}{N}\left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right)^{'}\left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right) \right)\mathbf{+ C}$$

> However, we want to maximize the above equation with the constraint
> that: M**β** = d, where d is a known vector and M is an *r x p* matrix
> of rank *r \< p.* This is an equality constraint. We can use the
> Lagrange multipliers to solve this maximization problem with such a
> constraint.
>
> We can see that, since the natural logarithm is a monotonically
> increasing function, and the division within the above logarithm is a
> constant, and that all other terms do not involve B, maximizing the
> above equation with respect to$\ \mathbf{\beta}^{\mathbf{c}}$ is
> equivalent to minimizing:

$$f = \left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right)^{'}\left( \mathbf{y} - X\mathbf{\beta}^{\mathbf{c}} \right) - \mathbf{\lambda}^{\mathbf{'}}\left( M\mathbf{\beta}^{\mathbf{c}}\ –\ d \right)$$

> Where $\mathbf{\lambda}$ is the Lagrange multiplier (and so f is the
> Lagrange function). The Lagrange multiplier is especially useful in
> this case, as we are trying to minimize the least square error with
> some constraint on the parameters.
>
> Multiplying the error by the transpose gives:

$$\mathbf{f =}\mathbf{y}^{\mathbf{'}}\mathbf{y -}\mathbf{y}^{\mathbf{'}}X\mathbf{\beta}^{\mathbf{c}}\mathbf{-}{\mathbf{\beta}^{\mathbf{c}}}^{\mathbf{'}}X^{'}\mathbf{y} + {\mathbf{\beta}^{\mathbf{c}}}^{\mathbf{'}}X^{'}X\mathbf{\beta}^{\mathbf{c}}\mathbf{-}\mathbf{\lambda}^{\mathbf{'}}\left( M\mathbf{\beta}^{\mathbf{c}}\ –\ d \right) = \mathbf{=}\mathbf{y}^{\mathbf{'}}\mathbf{y -}\mathbf{2}{\mathbf{\beta}^{\mathbf{c}}}^{\mathbf{'}}X^{'}\mathbf{y} + {\mathbf{\beta}^{\mathbf{c}}}^{\mathbf{'}}X^{'}X\mathbf{\beta}^{\mathbf{c}}\mathbf{-}\mathbf{\lambda}^{\mathbf{'}}\left( M\mathbf{\beta}^{\mathbf{c}}\ –\ d \right)$$

> Now we take derivatives with respect to $\mathbf{\beta}^{\mathbf{c}}$
> **and** $\mathbf{\lambda}$ **to obtain **

$$\frac{\text{δf}}{\text{δB}}\mathbf{=} - 2X^{'}\mathbf{y}\mathbf{+}2X^{'}X\mathbf{\beta}^{\mathbf{c}}\mathbf{-}M^{'}\mathbf{\lambda}$$

$$\frac{\text{δf}}{\text{δλ}}\mathbf{=}M\mathbf{\beta}^{\mathbf{c}}\ –\ d$$

We can now set both of these equal to zero and solve this system of
equations to find the appropriate MLE estimate of
$\mathbf{\beta}^{\mathbf{c}}$**.** However, there is a few simplifying
steps which can make the result more useable. The first is to get the
expression in terms of the original least squares estimator. If we
multiply the first equation above by M(${X^{'}X)}^{- 1}$, we obtain:

$$- \ 2M({X^{'}X)}^{- 1}X^{'}\mathbf{y}\mathbf{+}\ 2M{\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{-}\ M({X^{'}X)}^{- 1}M^{'}\mathbf{\lambda} = 0$$

The first term on the right is the familiar $\mathbf{\beta}$ from
unconstrained OLS (I will denote this $\mathbf{\beta}^{\mathbf{u}}$).
Substituting, we get

$$- \ 2M\mathbf{\beta}^{\mathbf{u}}\mathbf{+}\ 2M{\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{-}\ M({X^{'}X)}^{- 1}M^{'}\mathbf{\lambda} = 0$$

$$- \ 2M\mathbf{\beta}^{\mathbf{u}}\mathbf{+}\ 2M{\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{-}\ M({X^{'}X)}^{- 1}M^{'}\mathbf{\lambda} = 0$$

$$M({X^{'}X)}^{- 1}M^{'}\mathbf{\lambda} = \ 2M{\widehat{\mathbf{\beta}}}^{\mathbf{c}} - \ 2M{\widehat{\mathbf{\beta}}}^{\mathbf{u}}$$

Solving for lambda:

$$\mathbf{\lambda} = {(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\left\lbrack 2M{\widehat{\mathbf{\beta}}}^{\mathbf{c}} - \ 2M{\widehat{\mathbf{\beta}}}^{\mathbf{u}} \right\rbrack\mathbf{= 2}{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{\rbrack}$$

Plugging this back into the original equation and solving for
${\widehat{\mathbf{\beta}}}^{\mathbf{c}}$**,**

$$0\mathbf{=} - 2X^{'}\mathbf{y}\mathbf{+}2X^{'}X{\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{-}M^{'}\mathbf{\lambda}$$

$$0\mathbf{=} - 2X^{'}\mathbf{y}\mathbf{+}2X^{'}X{\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{-}{2(M}^{'}{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{\rbrack)}$$

$$X^{'}X{\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{=}X^{'}\mathbf{y}\mathbf{+}M^{'}{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{\rbrack}$$

$${\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{= (}{{X^{'}X)}^{- 1}X}^{'}\mathbf{y}\mathbf{+}{{(X}^{'}X)}^{- 1}M^{'}{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{\rbrack}$$

$${\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{=}\mathbf{\beta}^{\mathbf{u}}\mathbf{+}{{(X}^{'}X)}^{- 1}M^{'}{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{\rbrack}$$

This is the desired result, the maximum likelihood estimator given the
constraint M$\mathbf{\beta =}d$.

Now, we return to the first part of the problem.

$$\beta_{p} = 0$$

Is equivalent to the following constraint. **α**$\mathbf{'\beta = 0}$
where **α** is a vector of zeros in all but the last row, which is a 1.
So,

$\mathbf{\alpha} = \left( 0,\ 0,\ 0,\ 0,\ldots\ 1 \right)^{'}$

Plugging it into the derived result, we get:

$${\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{=}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{+}{{(X}^{'}X)}^{- 1}\mathbf{\alpha}^{'}{(\mathbf{\alpha}^{'}({X^{'}X)}^{- 1}\mathbf{\alpha})}^{- 1}\lbrack - \ \mathbf{\alpha}\mathbf{'}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{\rbrack}$$

$${\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{=}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{+}{{(X}^{'}X)}^{- 1}\mathbf{\alpha}^{'}{(\mathbf{\alpha}^{'}({X^{'}X)}^{- 1}\mathbf{\alpha})}^{- 1}\lbrack - \ {{\widehat{\beta}}^{u}}_{p}\mathbf{\rbrack}$$

Since $\mathbf{\alpha}^{\mathbf{- 1}}\mathbf{= \alpha}$ in this case, we
know that
$\mathbf{\alpha}^{'}{(\mathbf{\alpha}^{'}({X^{'}X)}^{- 1}\mathbf{\alpha})}^{- 1} = \mathbf{\alpha}^{'}\left( \mathbf{\alpha}^{'}\left( X^{'}X \right)\mathbf{\alpha} \right) = {X^{'}X}_{p,p}$
which is a scalar that is the bottom right element of the X'X matrix. So
we can simplify this to:

$${\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{=}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{+}{{(X}^{'}X)}^{- 1}{X^{'}X}_{p,p}\lbrack - \ {{\widehat{\beta}}^{u}}_{p}\mathbf{\rbrack}$$

Since ${X^{'}X}_{p,p}\lbrack 1 - \ {\beta^{u}}_{p}\mathbf{\rbrack}$ is a
constant:

$${\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{=}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{-}{X^{'}X}_{p,p}(\left\lbrack \ {\beta^{u}}_{p} \right\rbrack\mathbf{)}{{(X}^{'}X)}^{- 1}$$

So, if we compute the unconstrained
${\widehat{\mathbf{\beta}}}^{\mathbf{u}}$ and ${{(X}^{'}X)}^{- 1}$, we
can solve directly for the constrained $\mathbf{\text{β.}}$

Now, for the second part of part a), this is equivalent to M being a
vector of 1s, lets call it ϕ. Then

ϕ = (1,1,1,1,...,1)' and d = 1.

Plugging it into the derived result, we get:

$${\widehat{\mathbf{\beta}}}^{\mathbf{c}}\mathbf{=}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{+}{{(X}^{'}X)}^{- 1}\phi^{'}{(\phi^{'}({X^{'}X)}^{- 1}\phi)}^{- 1}\lbrack 1 - \text{\ ϕ}\mathbf{'}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\mathbf{\rbrack}$$

The residual sum of squares is defined as:

$RSS = \ {(\mathbf{y -}\widehat{\mathbf{y}})}^{'}(\mathbf{y -}\widehat{\mathbf{y}})$

In this case,
$\widehat{\mathbf{y}} = X{\widehat{\mathbf{\beta}}}^{\mathbf{c}}$**=**
X**(**$\mathbf{\beta}^{\mathbf{u}}\mathbf{+}{{(X}^{'}X)}^{- 1}M^{'}{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}$\])$\mathbf{=}\mathbf{\ }X\mathbf{\beta}^{\mathbf{u}}\mathbf{+}\text{\ X}{{(X}^{'}X)}^{- 1}M^{'}{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\rbrack$

So it follows that
$\left( \mathbf{y -}\widehat{\mathbf{y}_{\mathbf{c}}} \right) = \mathbf{y} - \ X\mathbf{\beta}^{\mathbf{u}}\mathbf{+}\text{\ X}{{(X}^{'}X)}^{- 1}M^{'}{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\rbrack$=

$$\ \mathbf{\varepsilon +}\text{\ X}{{(X}^{'}X)}^{- 1}M^{'}{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\rbrack$$

where $\mathbf{\varepsilon}$ is the error in the unconstrained case. So

RSSc -- RSS
=$\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\rbrack'{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\rbrack)$

Each of the errors are normally distributed with mean 0 and variance
sigma squared. This implies that:

$(\mathbf{y} - \check{\mathbf{y}})\ \mathbf{I}\frac{1}{\sigma}\sim\text{MVN}(0,I)$,
iid. $\ $

Where the estimator is the estimator from the restrained equation. We
can write the sum of squares of the above as:

$$\text{\ \ \ \ \ \ \ \ \ \ \ }\left( \mathbf{y} - \widehat{\mathbf{y}} \right)^{'}(\mathbf{I}\frac{1}{\sigma^{2}})\left( \mathbf{y} - \widehat{\mathbf{y}} \right) = \left( \mathbf{y} - \check{\mathbf{y}} \right)^{'}(\mathbf{I}\frac{1}{\sigma^{2}})\left( \mathbf{y} - \check{\mathbf{y}} \right) + \ \left( \check{\mathbf{y}}\mathbf{-}\widehat{\mathbf{y}} \right)^{\mathbf{'}}\left( \mathbf{I}\frac{\mathbf{1}}{\mathbf{\sigma}^{\mathbf{2}}} \right)\left( \check{\mathbf{y}}\mathbf{-}\widehat{\mathbf{y}} \right)\mathbf{+ 2(}\check{\mathbf{y}}\mathbf{-}\widehat{\mathbf{y}}\mathbf{)'}\left( \mathbf{I}\frac{\mathbf{1}}{\mathbf{\sigma}^{\mathbf{2}}} \right)\mathbf{(y -}\check{\mathbf{y}}\mathbf{)}$$

Where$\ {\check{y}}_{i}\ $is the estimator of the unconstrained model.
To show this, we remove the identical identity matrices and see that:

$$\left( \mathbf{y} - \widehat{\mathbf{y}} \right)^{'}\left( \mathbf{y} - \widehat{\mathbf{y}} \right) = \left( \mathbf{y} - \check{\mathbf{y}} + \check{\mathbf{y}} - \widehat{\mathbf{y}} \right)^{'}\left( \mathbf{y} - \check{\mathbf{y}} + \check{\mathbf{y}} - \widehat{\mathbf{y}} \right) =$$

$$\left( \mathbf{y} - \check{\mathbf{y}} \right)^{'}\left( \mathbf{y} - \check{\mathbf{y}} \right) + \ \left( \check{\mathbf{y}} - \widehat{\mathbf{y}} \right)^{'}\left( \check{\mathbf{y}} - \widehat{\mathbf{y}} \right) + 2(\mathbf{y} - \check{\mathbf{y}})'\left( \check{\mathbf{y}} - \widehat{\mathbf{y}} \right)$$

Now,

$$\left( \check{\mathbf{y}} - \widehat{\mathbf{y}} \right) = \left( \mathbf{y} - \widehat{\mathbf{y}} - \left( \mathbf{y} - \check{\mathbf{y}} \right) \right) = \left( \ \left( \mathbf{y} - \widehat{\mathbf{y}} \right) - \mathbf{\varepsilon} \right)$$

which we know from the above is
$(X{{(X}^{'}X)}^{- 1}M^{'}{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\lbrack d - \text{\ M}{\widehat{\mathbf{\beta}}}^{\mathbf{u}}\rbrack$)'

Rewriting, we have:

$$\left( \mathbf{y} - \check{\mathbf{y}} \right)'\left( \left( \mathbf{y} - \widehat{\mathbf{y}} \right) - \mathbf{\varepsilon} \right) = \mathbf{\varepsilon}'(X{{(X}^{'}X)}^{- 1}M^{'}{(M({X^{'}X)}^{- 1}M^{'})}^{- 1}\left\lbrack d - \ M{\widehat{\mathbf{\beta}}}^{\mathbf{u}} \right\rbrack)$$

Using the fact that $\mathbf{\varepsilon'X = 0}$**,** we can remove this
to obtain.

$${\left( \mathbf{y} - \widehat{\mathbf{y}} \right)^{'}\left( \mathbf{y} - \widehat{\mathbf{y}} \right) = \left( \mathbf{y} - \check{\mathbf{y}} \right)}^{'}\left( \mathbf{y} - \check{\mathbf{y}} \right) + \ \left( \check{\mathbf{y}} - \widehat{\mathbf{y}} \right)^{'}\left( \check{\mathbf{y}} - \widehat{\mathbf{y}} \right)$$

Thus the original standardized normal variable can be represented as a
sum of Q1, and Q2 where:

Q1 =
$\left( \mathbf{y -}\check{\mathbf{y}} \right)^{\mathbf{'}}\left( \mathbf{y -}\check{\mathbf{y}} \right)$

Q2 =
$\left( \check{\mathbf{y}}\mathbf{-}\widehat{\mathbf{y}} \right)^{\mathbf{'}}\left( \check{\mathbf{y}}\mathbf{-}\widehat{\mathbf{y}} \right)
$

Q1 is the sum of squared errors for the unconstrained model, and
therefore has rank $n - p$. Q2 has rank *p -- r ,* as it is the
differences between the two estimators. Thus rank(Q1) + rank (Q2) =
*n-r,* which is the rank of the errors of the constrained model, since
r\<p. Thus by Cochran's Theorum, the two are independently distributed.

I have also produced simulations to prove that this is the case. I
create three normal random variables, two of which are related to the
others linearly and randomly. I compute the beta unconstrained, and then
use this to compute the beta constrained. I then produce the errors for
the constrained beta, and check the correlations in 100 samples of 1000
each. The mean correlation is very close to zero, which is the expected
result. This is included in the R file.
