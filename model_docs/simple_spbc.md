

# Simple sticky-price business cycle model



---

## Structure of the model

#### Households
* demand consumption goods, $C_t$, from distributors
* supply labor, $N_t$, to labor unions
* supply production capital, $k$, to producers
* trade in production capital
* trade in IOUs, $B_t$
* production capital fixed at an aggregate level (no investment)

#### Labor unions
* introduced to make wage setting problems easier to handle algebraically
* bundle labor and supply labor to 
* face wage, $W_t$, adjustment costs
#### Supply side (production and distribution)
* production division assembles final goods, $Y_t$, combining labor, $N_t$ and capital, $K_t$
* distribution division sells final goods to households
* downward-sloping demand curve (monopolistic competition)
* price, $P_t$, adjustment costs

#### Source of growth
* Low-frequency process in the production function
* Captures productivity, capital, demography

#### Monetary policy and money markets
* Inflation targeting rule for the short interest rate
* Long rates introduced through an arbitrage condition

---
## Households

#### Lifetime utility function

Choose consumption,  $C_t$, hours worked $N_t$, capital, $K_t$, IOUs (net asset/liab position), $B_t$

$$
\mathrm E_t \sum_{t=0}^\infty \beta^t \left[
\left(1-\chi\right)\,\log \left(C_t - \chi\,H_t\right)
- \frac{1}{1+\psi} \, N_t{}^{1+\psi}
+ \beta_0 \, B_t
\right]
$$

* where $\beta$ is a discount factor
* $H_t \equiv \, \alpha \, \overline{C}_{t-1} \, \exp \varepsilon_{C,t}$  is a reference level for consumption
* $\beta_0$ is a utility parameter for net asset/liab positions

#### Dynamic budget constraint

$$
B_t = R_{H,t-1}\, B_{t-1}
+ W_t^\mathrm{flex} \, N_t + R_{K,t} \, K_{t-1} + \Pi_{Y,t}
- P_t\, C_t - P_{K,t} \left( K_{t} - K_{t-1} \right) + \Omega_{W,t} + \Omega_{P,t}
$$
where
* $R_{H,t} \equiv R_t \, \exp \varepsilon_{B,t}$ is an effective household rate
* $W_t^\mathrm{flex}$ is a flexible wage rate received from labor unions
* $R_{K,t}$ is a rental price of capital
* $\Pi_{Y,t}\equiv \Pi_{Y1,t} + \Pi_{Y2,t}$ are the profits received from the producers and distributors
* $\Omega_{W,t}$ and $\Omega_{P,t}$ are the adjustment costs (private, not social costs) paid to households

#### First-order conditions

Intertemporal choice
$$
\Lambda_t \left(1 + \beta_0\right) = \beta \, \mathrm E_t \left[ \Lambda_{t+1} R_{H,t} \right]
$$

Consumption demand
$$
\Lambda_t \, P_t = \frac{1}{C_t - H_t}
$$
Flexible-wage labor supply

$$
\Lambda_t \, W_t^\mathrm{flex} = N_t{}^\psi
$$


---

## Labor unions

Choose $W_t$ to maximize

$$
\mathrm E_t \sum_t \left(\beta \, \beta_1\right) ^t \, \tfrac{1}{2} \left[
	\left(\log W_t - \log W_t^\mathrm{flex} \right)^2
	+ \xi_{W} \, \left( \Delta \log W_t - \mathit{ix}_{W,t} \right)^2
\right]
$$

where
* $\beta_1$ is an additional (uncertainty) discounting surcharge
* $\mathit{ix}_{W,t} \equiv \Delta \log P_{t-1} + \Delta \log A_{t-1}$ is a wage indexation term

---

## Supply side

* Consists of two divisions, production and distribution
* Externalize the other division's decisions

---

## Production division

#### Production technology

Combine labor, $N_t$, and capital, $k_t$, to produce final goods, $Y_t$

$$
Y_t = A_t \, \left(N_t - N_t^{o} \right)^\gamma \, k_t{}^{1-\gamma}
$$

where
* $A_t$ is a low-frequency source of growth
* $N_t^o$ is overhead labor (given as part of technology specification)
* $N_t-N_t^o$ is variable labor


#### Profit maximization

Choose $N_t$ and $K_T$ to maximize period profits, $\Pi_{Y1,t}$

$$
\Pi_{Y1,t} = Q_t\,Y_t - W_t \, N_t - R_{K,t} \, k_t
$$

where $Q_t$ is the flexible price at which $Y_t$ is sold to distributors
#### First-order conditions

Demand for labor

$$
\gamma \, Q_t \, Y_t = W_t \left(N_t - N_t^o \right)
$$

Demand for capital

$$
\left(1- \gamma\right) \, Q_t \, Y_t = R_{K,t} \, k_t
$$

---

## Distribution division

Choose the combination of a final price, $P_t$ and final output, $Y_t$ to maximize intertemporal profits

$$
\mathrm E_t \sum_{t=0}^\infty \left( \beta \, \beta_1 \right)^t \, \Lambda_t \left[
\left(P_t - Q_t\right) \, Y_t 
- \tfrac{1}{2}\, \xi_{P} \, \overline P_t \, \overline Y_t \,\left( 
\Delta \log P_t - \mathit{ix}_{P,t}
\right)^2
\right]
$$

where

* $\mathit{ix}_{P,t}\equiv \Delta \log \overline P_t$ is a price indexation term
* $\xi_P$ is a price adjustment cost parameters
* $\beta_1$ is an additional discounting surcharge

---

## Monetary policy

* Choose a short rate to stabilize inflation over the medium run
* Described by a simple reaction function

$$
\log R_t = \rho_R \, \log R_{t-1}
+ \left(1-\rho_R\right) \left[ \log \overline R + \mathit{react}_t \right]
+ \varepsilon_{R,t}
$$

with the following reaction term

$$
\mathit{react}_t \equiv
\kappa_P \left( \tfrac{1}{4} \, \log \Delta_4 P_{t+4} - \pi \right)
+ \kappa_N \, \left(\log N_t - \log N_\mathrm{ss} \right)
$$

where
* $\kappa_P$ and $\kappa_N$ are reaction parameters
* $\pi$ is an inflation target parameter

---

## Aggregation and symmetric equilibrium

#### Zero net aggregate supply of IOUs

$$
B_t = 0
$$

#### Fixed aggregate supply of production capital

$$
K_t = k_t = k
$$

#### Final goods

$$
Y_t = C_t
$$


#### Externalized variables

$$
\overline C_t = C_t, \qquad \overline P_t = P_t, \qquad \overline Y_t = Y_t
$$

