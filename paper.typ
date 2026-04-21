// ── MATH3030 Coursework ──────────────────────────────────────────────
// Compile:  typst compile paper.typ
// Watch:    typst watch paper.typ

// ── Page & font setup ───────────────────────────────────────────────
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
  number-align: center,
)

#set text(
  font: "Libertinus Serif",
  size: 11pt,
  lang: "en",
  region: "GB",
)

#show raw: set text(font: "JetBrains Mono", size: 9pt)
#show math.equation: set text(font: "New Computer Modern Math")

#set par(
  justify: true,
  leading: 0.7em,
  first-line-indent: (amount: 1.2em, all: false),
)

#set heading(numbering: "1.1")

#show heading.where(level: 1): it => {
  set text(size: 16pt, weight: "bold")
  v(1em)
  block(it)
  v(0.3em)
}
#show heading.where(level: 2): it => {
  set text(size: 12pt, weight: "bold")
  v(0.6em)
  block(it)
  v(0.1em)
}
#show heading.where(level: 3): it => {
  set text(size: 11pt, weight: "bold", style: "italic")
  v(0.4em)
  block(it)
}

#show figure.caption: it => [
  #set text(size: 9.5pt)
  #emph[#it.supplement #it.counter.display(it.numbering).] #it.body
]

// ── Utility: insert a saved figure from the notebook ────────────────
// Usage:  #fig("plots/eda_trends.png", "Continental trends over time")
#let fig(path, caption, width: 85%) = figure(
  image(path, width: width),
  caption: caption,
)

// ── Title block ─────────────────────────────────────────────────────
#align(center)[
  #v(1em)
  #text(size: 20pt, weight: "bold", tracking: 0.02em)[MATH3030: Coursework]
  #v(0.3em)
  #text(size: 13pt, style: "italic")[Spring 2026]
  #v(1.2em)
  #text(size: 11pt)[Aayush Parekh]
  #text(size: 11pt)[Student ID: 20527121]
  #v(0.2em)
  #text(size: 10pt, fill: rgb("#555555"))[
    Multivariate Statistics \
    School of Mathematical Sciences, University of Nottingham
  ]
]

#v(1.5em)
#line(length: 100%, stroke: 0.4pt + rgb("#888888"))
#v(1em)

// ═══════════════════════════════════════════════════════════════════
= Question 1
// ═══════════════════════════════════════════════════════════════════

== Exploratory Data Analysis <eda>

The UN dataset contains GDP per capita, life expectancy, and population
for 141 countries at 12 evenly spaced time points from 1952 to 2007.
No values are missing. Sample sizes per continent are uneven (52
African, 32 Asian, 30 European, 25 American, and 2 Oceanian), so any
continent-level summary for Oceania is effectively a two-country
average of Australia and New Zealand. We summarise the 70-year
dynamics with continent-mean trajectories for each variable and a
table of 1952 and 2007 medians.

#fig("plots/eda_trends.png",
     "Continent-mean trajectories, 1952–2007. GDP and population are on
      log scales; life expectancy is linear.")

Asia shows the steepest gains on both axes. Mean life expectancy rose
from 44 to 72 years and median GDP per capita almost quadrupled,
driven by a handful of export-led economies: Singapore's GDP per
capita rose from \$2,315 to \$47,143 (20×), South Korea's by 23×,
and Taiwan's by 24×. China dominates the population panel, rising
from 556 million in 1952 to 1.32 billion in 2007. These multipliers are well above the Asian median GDP gain of 3.8×,
so the continent mean hides a wide spread rather than uniform growth.

Africa's trajectory is much shallower. Median GDP rose only 1.5× over
55 years, and mean life expectancy, after rising from 39 to 53 years,
plateaued from the 1990s onward. The plateau coincides with the peak
of the HIV/AIDS epidemic in southern Africa and a series of regional
conflicts. Zimbabwe's life expectancy fell from 48.5 to 43.5 years
(the largest decline in the dataset), Swaziland, Zambia, and Lesotho
show similar stagnation, and the Democratic Republic of the Congo is
the only country whose GDP per capita ended below its 1952 level, at
36% of its original value. Africa's population grew faster than any
other continent's, which compounds the GDP-growth shortfall on a
per-capita basis.

Europe and Oceania remain firmly at the top throughout. Europe's GDP
growth (\$5,143 to \$28,054, 5.5×) is comparable to Asia's in
multiplier terms, but its life-expectancy gain of +13 years is about
half of Asia's +28. This is structural rather than a lack of
development: a population already close to its demographic ceiling
has less room to gain years than one that is catching up. Both
continents also evolve more smoothly than Asia or Africa, with no
sharp deviations between adjacent five-year intervals.

#fig("plots/eda_bubble.png",
     "GDP per capita vs life expectancy in 2007. Bubble size is
      proportional to population.")

The 2007 snapshot compresses the trajectories into a single
cross-section and makes the joint structure visible. GDP and life
expectancy are strongly but non-linearly related: the Pearson
correlation on log(GDP) is 0.81, appreciably higher than on raw GDP
(0.68), reflecting the diminishing marginal returns on life expectancy
at high income. Continents separate cleanly, with Africa in the
lower-left, Europe in the upper-right, and the Americas grouped in the
middle. Asia is the outlier continent in this view, spanning almost
the full income range from India and Bangladesh at the low end to
Japan and Singapore at the top, with China positioned between the two
modes.

#fig("plots/eda_kde.png",
     "Kernel density estimates of each variable in 2007, one curve per
      continent.")

The KDEs show the within-continent distributional shape. Asia's GDP
distribution is visibly bimodal (Gulf states and East Asian tigers on
one side, South and Central Asia on the other), with an IQR
ratio of 8.9, the largest of any continent. Africa's life-expectancy distribution is wide and
left-skewed, with a lower tail formed by Swaziland, Zambia, Zimbabwe,
and Lesotho, all below 45 years. Population densities peak near 10
million in every continent, with Asia carrying the long right
tail that contains China and India. Continents that appeared internally
homogeneous on the trajectory plot thus conceal real heterogeneity
under the mean.

#figure(
  table(
    columns: 7,
    align: (left,) + (center,) * 6,
    stroke: 0.3pt,
    table.header([*Continent*], [*N*], [*GDP 1952*], [*GDP 2007*],
                  [*LE 1952*], [*LE 2007*], [*Pop 2007 (M)*]),
    [Africa],   [52], [987],    [1,452],  [38.8], [52.9], [929],
    [Americas], [25], [3,048], [8,948],  [54.7], [72.9], [899],
    [Asia],     [32], [1,148], [4,328],  [44.4], [72.2], [3{,}812],
    [Europe],   [30], [5,143], [28,054], [65.9], [78.6], [586],
    [Oceania],  [2],  [10,298],[29,810], [69.3], [80.7], [24],
  ),
  caption: [Median GDP per capita (USD) and life expectancy (years) by
            continent; population (millions).],
)

A small number of countries deviate strongly from their continent's
trend and are expected to appear as extreme points in the PCA, CCA,
and MDS projections below. Equatorial Guinea's GDP per capita rose
32× on the back of offshore oil discoveries; Zimbabwe's life
expectancy fell by five years; Singapore, South Korea, and Taiwan
achieved sustained 20–24× GDP multiples; and the Democratic Republic
of the Congo and Haiti are the two economies that regressed most
sharply, ending the period at 36% and 65% of their 1952 GDP per
capita respectively.


== Principal Component Analysis <pca>

We perform PCA independently on the $141 times 12$ GDP and
life-expectancy blocks. GDP values span more than two orders of
magnitude across countries, so we standardise each year column, 
which is just decomposing the correlation matrix, to prevent larger
recent-year variances from dominating. Life expectancy is on a
comparable scale across years, but we also standardise it; the
covariance and correlation decompositions produced near-identical
results (PC1 explains 92.0% and 92.3% of the variance respectively),
and standardising keeps the treatment of the two variable blocks
consistent.

=== Scree analysis and variance explained

#fig("plots/pca_scree.png",
     "Scree plots for the GDP and life-expectancy PCAs. Both are
      dominated by a single leading component.")

Both decompositions concentrate almost all variance in a single
component. PC1 explains 91.9% of the GDP variance and 92.3% of the
life-expectancy variance while PC2 adds a further 5.3% and 5.6%
respectively. Two components are sufficient as together they cover
97.1% of the GDP variance and 97.9% of the life-expectancy variance. 
This follows directly from the year-to-year redundancy within each block, 
with adjacent years correlated at approximately 0.99, so 12 columns
compress cleanly into two.

=== Interpretation of PC1 and PC2

The loadings have the same structure on both decompositions. PC1
assigns nearly uniform positive weights across all 12 years (GDP: 0.28
to 0.30; life expectancy: 0.27 to 0.30), so a country's PC1 score is
approximately proportional to its average level over the full 55-year
period. Whereas for PC2, the loadings begin strongly negative
in 1952 ($-0.35$) and rise monotonically to strongly positive
in 2007 ($+0.42$). A positive PC2 score therefore indicates a
country whose values were low early and high late (a catching-up or
fast-growth trajectory), and a negative PC2 score indicates the
opposite (stagnation or decline from a relatively high base).

=== PC score scatter plots

#fig("plots/pca_scores.png",
     "PC1 vs PC2 scatter plots for GDP (left) and life expectancy
      (right), coloured by continent.")

The GDP scatter is structured by level on PC1. Switzerland
(+10.7), the US (+9.7), Norway, Canada, Denmark sit at
the top end while Myanmar, Burundi, Ethiopia, Eritrea, and Malawi at the
bottom. PC2 then separates countries by growth trajectory. The top Asian countries 
form the obvious cluster at the top of PC2 (Singapore +3.8,
Hong Kong +2.8, Taiwan +2.5, South Korea +2.1, Japan +1.9), which
identifies the countries whose relative position improved most over
the period. Strongly negative PC2 scores belong to Venezuela, Iraq,
and Libya, relatively high-income economies in 1952 that did not
sustain their early position advantage.

The life-expectancy scatter has the same geometry. PC1 separates
Iceland, Sweden, Norway, the Netherlands, and Switzerland at the top
and Sierra Leone, Afghanistan, Angola, Guinea-Bissau, and Mozambique
at the bottom. PC2 captures the rate of improvement with Oman (+2.2),
Vietnam, Saudi Arabia, Indonesia, and Libya gaining life expectancy
fastest, while Zimbabwe ($-2.3$), Zambia, Rwanda, Botswana, and the
Democratic Republic of the Congo have the strongly negative PC2
scores consistent with the health epidemic and regional conflicts
identified in the EDA. Continent clusters are distinct with Europe and
Oceania at the top of PC1, Africa at the bottom, the Americas in the
middle, and Asia stretched along PC2 consistent with its bimodal GDP
distribution.

=== GDP PC1 versus life-expectancy PC1

#fig("plots/pca_cross.png",
     "First PC scores, GDP against life expectancy.")

Plotting the two leading PC1 scores against each other presents the
relationship between overall economic level and overall health levels
across the full period. The Pearson correlation is 0.77, consistent
with the 0.81 log(GDP)–life expectancy correlation seen in the 2007
snapshot and confirming that wealth and health run together over long
time horizons. Most countries lie close to the diagonal; the
systematic deviations are countries whose health outcomes are either
stronger or weaker than their income level would predict, reflecting
external factors such as public health investment, diet, and health
system access that the economic dimension alone does not capture.

=== Limitations of linear PCA

The decomposition is restricted to linear combinations of the year
columns and the GDP–life expectancy relationship is non-linear
(Pearson correlation 0.68 on raw GDP against 0.81 on log(GDP)).
Kernel PCA, which applies the standard decomposition in a feature
space induced by a kernel, would capture this curvature directly and
would be expected to produce tighter continent separation than the
linear projection used here.#footnote[Background reading carried out
for a separate statistical project this year; a fuller treatment is
given in Hastie, Tibshirani, and Friedman, _The Elements of
Statistical Learning_ (2nd ed., 2009), Chapter 14.]


== Canonical Correlation Analysis <cca>

We apply CCA with $log("GDP")$ as the first variable set and life
expectancy as the second, giving $p = q = 12$. The log transform is
motivated by the same skewness and non-linearity noted in the EDA
and the PCA limitations subsection, since raw GDP is strongly
right-skewed (skewness 1.88) and the 2007 GDP–life expectancy
relationship curves noticeably on the raw scale but is close to
linear on the log scale.

#fig("plots/cca_scatter.png",
     "First pair of canonical variables, coloured by continent.")

=== Canonical correlations

The first canonical correlation is 0.93, and subsequent correlations
decay rapidly to 0.63, 0.54, and 0.50, with the remainder below 0.40.
The first pair therefore captures most of the shared linear structure
between the two blocks, and the higher-order pairs are unlikely to
admit a clean interpretation given how quickly they fall off.

=== Interpretation of the first canonical pair

The first canonical axis ranks countries by a joint development level
that log(GDP) and life expectancy identify together. The lower
extreme is dominated by sub-Saharan African and conflict-affected
Asian states, with Mozambique, Myanmar, and Sierra Leone at the
bottom, and the upper extreme by Western European countries and the
United States, with Norway and Switzerland at the top. This ordering
is near-identical to the one PCA produced on either variable
separately, because the 12 year columns within each block are
correlated at approximately 0.99 and there is little room for CCA's
maximum-correlation objective to choose a direction meaningfully
different from PCA's maximum-variance one. The continent structure
on the canonical scatter reproduces the PCA pattern, with Africa in
the lower-left and Europe and Oceania in the upper-right.

=== Effect of the log transform

Repeating the analysis on raw GDP gives a first canonical correlation
of 0.89, materially lower than the 0.93 achieved with log(GDP). CCA
only finds linear combinations of the variables it is given, so any
curvature in the raw GDP–life expectancy relationship is left
unaccounted for. The log transform straightens the relationship and
raises the canonical correlation, and this 0.04 gain is the direct
numerical expression of the linearity limitation noted earlier in
the PCA section.


== Multidimensional Scaling <mds>

Classical (metric) MDS is applied to the combined 36-dimensional
dataset formed by concatenating log(GDP), life expectancy, and
log(population), using Euclidean distance as specified in the
coursework. The log transforms on GDP and population bring them onto
a roughly comparable scale with life expectancy. The Pearson
correlation between pairwise distances in the original 36-D space
and the 2D MDS projection is 0.997, so the two retained dimensions
preserve the distance geometry of the full data almost exactly.

#fig("plots/mds.png",
     "Two-dimensional MDS representation, coloured by continent.")

=== Development axis

Dimension 1 is a clear development axis. The continent centroids
line up from Africa at $-37$ through the Americas at $+19$ and
Europe at $+43$ to Oceania at $+52$, in the same order they occupy
on every previous projection. The lower extreme is dominated by
sub-Saharan African and conflict-affected Asian states such as
Sierra Leone, Afghanistan, Angola, Guinea-Bissau, and Rwanda, while
the upper extreme is occupied by Scandinavian and Alpine European
countries including Sweden, Iceland, Norway, the Netherlands, and
Switzerland. This country ordering matches the one produced by PCA
and CCA, since all three methods are projecting the same dominant
development signal that accounts for the bulk of the variation in
the data.

=== Growth direction

Dimension 2 separates countries by the direction of change in life
expectancy over the period rather than by level. The most negative
scores belong to countries with the largest life-expectancy gains
over the 55 years, a cluster containing Oman, Vietnam, Indonesia,
and Yemen, while the most positive scores belong to countries whose
life expectancy fell or stagnated under the HIV epidemic, including
Zimbabwe, Botswana, Zambia, and Swaziland. Asia's centroid is pulled
below the horizontal axis by its concentration of fast-gaining
countries, while Africa's centroid sits near the horizontal because
the continent contains both rapidly improving and declining cases.
The contrast is the same one that appeared as PC2 in the
life-expectancy PCA, now reproduced with all three variables
analysed simultaneously.

=== Comparison with the earlier analyses

The MDS projection is consistent with the PCA and CCA results rather
than revealing new structure, with dimension 1 recovering the
development level axis and dimension 2 recovering the
growth-direction contrast. Its distinctive contribution is that it
operates on all three variables simultaneously, so a single 2D
summary captures joint structure that PCA and CCA required separate
analyses to recover. The 0.997 distance correlation between the
original and reduced pairwise distances makes the 2D projection a
near-lossless summary of the 36-dimensional dataset, which
strengthens the claim that the development and growth-direction axes
are the two dominant sources of variation in the full UN data.

#pagebreak()

// ═══════════════════════════════════════════════════════════════════
= Question 2
// ═══════════════════════════════════════════════════════════════════

== Linear Discriminant Analysis <lda>

We use LDA to predict continent from all 36 features (GDP, life
expectancy, and population across 12 years). The data are split 70/30
into training and test sets. A single fixed split with seed 42 gives
a test accuracy of 0.512 on 43 held-out countries, and averaging over
50 random splits gives a more stable estimate of $0.594 plus.minus
0.064$. Both figures sit comfortably above the 0.20 five-class chance
rate and above the 0.37 majority-class baseline set by Africa's
sample proportion, so the classifier is extracting genuine structure
from the features.

#figure(
  table(
    columns: 6,
    align: (left,) + (center,) * 5,
    stroke: 0.3pt,
    table.header([*True \\ Pred*], [*Africa*], [*Americas*], [*Asia*],
                  [*Europe*], [*Oceania*]),
    [Africa],   [11], [3], [2], [0], [0],
    [Americas], [2],  [3], [2], [1], [0],
    [Asia],     [3],  [3], [2], [0], [0],
    [Europe],   [0],  [2], [1], [6], [1],
    [Oceania],  [0],  [0], [0], [1], [0],
  ),
  caption: [Confusion matrix on the 43-country test set at seed 42.
            Rows are true continents, columns are predicted.],
)

Per-class accuracy varies substantially. Africa is the best-classified
continent at 0.69, followed by Europe at 0.60, the Americas at 0.38,
and Asia at 0.25. The single Oceanian country in the test set is
misclassified as European. Asia's errors are spread across Africa,
the Americas, and Europe in roughly equal proportions. This is
consistent with the EDA finding that Asia spans almost the full
development range with a strongly bimodal GDP distribution. LDA
assumes each class is drawn from a Gaussian with a common covariance,
and a bimodal continent violates that assumption. The classifier
places Asia's mean somewhere between its two modes, where it overlaps
with the other continents and is frequently misclassified. Africa,
the other internally heterogeneous continent, is classified more
accurately because its spread is along a single unimodal axis rather
than a bimodal one.


== Clustering <clustering>

Three methods from the module are applied to the standardised GDP
and life-expectancy blocks (24 features). k-means and the Gaussian
mixture model are fitted directly, and hierarchical clustering is
applied via its linkage-distance dendrogram. k is chosen from the
dendrogram and the GMM BIC curve, with the same k then used for
k-means so that all three methods can be compared on equal footing.

#fig("plots/cluster_selection.png",
     "Left: hierarchical clustering dendrogram. Right: GMM BIC as a
      function of number of components.")

=== Choice of k

The dendrogram's three largest merge distances are 57.6, 41.0, and
19.5, with every subsequent merge below 16. The substantial gap
between merges 3 and 4 identifies $k = 3$ as the cleanest cut point.
The GMM BIC curve decreases monotonically over the range we examined
rather than producing a minimum. This usually indicates that the data
do not form sharply separated Gaussian clumps and instead lie on a
continuous development manifold, which is consistent with the MDS
result showing smooth variation along dimension 1. The rate of BIC
improvement slows considerably after $k = 3$, so $k = 3$ remains a
defensible choice from the model-based perspective even without a
true minimum.

=== Agreement between methods

#fig("plots/cluster_comparison.png",
     "Cluster assignments at k = 3 for k-means, hierarchical
      clustering, and the GMM.")

At $k = 3$ the three methods produce strongly consistent labellings.
The Adjusted Rand Index is 0.84 between k-means and hierarchical
clustering, 0.83 between k-means and the GMM, and 0.68 between
hierarchical and the GMM. Agreement this high across the three
methods is strong evidence that the cluster structure is intrinsic
to the data rather than an artefact of any single algorithm.

=== Cluster interpretation

The three clusters have a natural development interpretation. The
first cluster contains 18 of the 30 European countries, 6 Asian
countries, and both Oceanian countries, placing it at the high-GDP
and high-life-expectancy end of the development axis already seen in
PCA and MDS. The second cluster contains 42 of the 52 African
countries together with 10 Asian and 2 American ones, and sits at
the low-development end. The third is the middle cluster, dominated
by the Americas (21 of 25) with a substantial Asian contingent (16 of
32) and the remaining 12 European countries. The ordering reproduces
the PCA and MDS development axis and shows that continent is a
reasonable but imperfect proxy for development level. Africa and
Europe fall almost entirely into the low and high clusters
respectively, while the Americas and Asia are split across the
middle and the extremes.


== Linear Regression <regression>

We predict 2007 life expectancy from the 11 GDP columns for 1952–2002,
excluding 2007 GDP to avoid contemporaneous leakage. The 11 predictors
are correlated with one another at approximately 0.99 (the
year-to-year structure noted in the EDA), which is textbook
multicollinearity and motivates testing methods that handle it
directly rather than OLS alone. Six models are compared. Ordinary
least squares, ridge regression, and principal component regression
(PCR) are each applied to raw GDP and to $log("GDP")$. Ridge
regularisation strength is chosen by built-in cross-validation over
a grid of 50 values, and PCR's number of components is chosen by
cross-validation over $k = 1, dots, 11$. All models are scored by
leave-one-out cross-validated RMSE and $R^2$.

Leave-one-out is appropriate for this dataset. The 141-country sample
is small enough that a single 70/30 split would leave only around 99
training rows against 12 coefficients per model, and the $n$-fold
fitting cost is negligible for linear and ridge regression. Scoring
every model on the same sequence of 141 single-country holdouts also
makes the comparison between them unambiguous, because any RMSE
difference between two models reflects the model specification rather
than which split happened to be drawn.

=== Ridge shrinkage and principal component regression

Ridge regression minimises a penalised least-squares objective,

$ norm(y - X beta)^2 + alpha norm(beta)^2, $

which shrinks every coefficient toward zero. The amount of shrinkage
applied to each direction in the predictor space is inversely
proportional to the variance of that direction, so low-variance
directions are penalised most. Under multicollinearity the OLS
coefficients in those same directions have large variance, and ridge
stabilises them at the cost of a small amount of bias. The tuning
parameter $alpha$ controls the trade-off, with $alpha -> 0$ recovering
OLS and $alpha -> infinity$ driving all coefficients to zero. We select
$alpha$ by cross-validation over a log-sapce grid search of  50
candidates in $[10^(-2), 10^3]$, taking the value that minimises the
held-out prediction error. The grid is wide enough that the selected
$alpha$ is interior for both the raw and log specifications, so the
optimum is not an artefact of the search range.

Principal component regression implements a similar idea through hard
thresholding rather than continuous shrinkage. The original predictors
are replaced with their first $k$ principal components, we run OLS in
the reduced space, and the low-variance PC directions are discarded
entirely. This is particularly well-suited to the present setting
because the PCA of the GDP block in @pca showed that two or three
components already explain 97–99% of the variance, so the directions
PCR discards carry negligible signal and their inclusion in OLS adds 
estimator variance.

#fig("plots/ridge_path.png",
     "Standardised Ridge coefficients as a function of the penalty
      $alpha$, on raw GDP (left) and log GDP (right). The vertical
      dashed line marks the CV-optimal $alpha$ used in the main
      results.")

At low $alpha$ the eleven year coefficients are large and opposing
in sign. This is expected when predictors are near-collinear, since
OLS can produce many combinations of large coefficients that mostly
cancel when predicting the response. Increasing $alpha$ shrinks the
coefficients toward zero and flattens the year-to-year differences
between them. The cross-validated $alpha$ sits in the intermediate
region, where shrinkage has stabilised the coefficients without yet
removing their signal.

#figure(
  table(
    columns: 3,
    align: (left,) + (center,) * 2,
    stroke: 0.3pt,
    table.header([*Model*], [*LOOCV RMSE*], [*LOOCV $R^2$*]),
    [OLS (raw GDP)],              [9.26],   [0.41],
    [OLS (log GDP)],              [7.64],   [0.60],
    [Ridge (raw GDP)],            [9.26],   [0.41],
    [Ridge (log GDP)],            [7.21],   [0.64],
    [PCR (raw GDP, $k=2$)],       [8.98],   [0.44],
    [PCR (log GDP, $k=3$)],       [*7.15*], [*0.65*],
  ),
  caption: [Leave-one-out cross-validated performance for the candidate regression models.],
)

OLS on raw GDP gives
a LOOCV RMSE of 9.26 years and $R^2 = 0.41$, while OLS on log(GDP)
gives RMSE 7.64 and $R^2 = 0.60$, a one-and-a-half-year reduction in
prediction error from the transform alone. Ridge on log(GDP) with
its penalty $alpha = 11.5$ improves this further to
RMSE 7.21 and $R^2 = 0.64$, while the penalty on raw
GDP is $alpha = 0.01$, small enough that Ridge collapses onto OLS.
The mechanism is the same one discussed in the PCA and CCA sections.
GDP's skewness makes the linear relationship with life expectancy
non-linear on the raw scale but close to linear on the log scale, and
the regression results express the cost of ignoring this as 0.19
units of $R^2$.

Principal component regression is the nominal winner. On log(GDP) the
best configuration uses $k = 3$ components and achieves LOOCV RMSE
7.15 and $R^2 = 0.65$, narrowly ahead of Ridge. This is consistent
with the PCA of the GDP block in @pca, where the first three
components already explain 99% of the variance, so a three-component
regression retains essentially all of the signal while discarding the
near-zero-variance directions that inflate the least-squares variance.
PCR on raw GDP peaks at $k = 2$ with RMSE 8.98 but still does not
reach the log-based models, confirming that the transform is more
important than the multicollinearity fix.

The margin between PCR and Ridge warrants some caution. The number of
components $k$ is chosen by the same leave-one-out procedure that
reports the final RMSE, so the tuning and evaluation overlap and the
7.15 figure is a mildly optimistic estimate of true out-of-sample
error. The same concern applies to Ridge's $alpha$, which is also
selected by cross-validation, so the PCR-versus-Ridge comparison is
at least fair. The 0.06-year gap between them is small relative to
LOOCV noise at $n = 141$, and the two methods should be treated as
statistically indistinguishable at this sample size. What the data
do support is that both methods provide a modest improvement over OLS
on log(GDP) by treating the near-collinear GDP year columns, with no
reliable basis for preferring one over the other.

#fig("plots/regression_best.png",
     "Leave-one-out predictions against actual 2007 life expectancy
      for the best model.")

The largest residuals are the countries already flagged in the EDA.
Zimbabwe, Swaziland, and Zambia are substantially over-predicted
because their pre-1990 GDP history is consistent with the
life-expectancy growth seen in most other countries, and the model
has no predictor capable of capturing the HIV-driven mortality shock
that followed. This is a structural limitation of using GDP alone to
predict life expectancy. A health shock that leaves GDP largely
unaffected is invisible to the model, and the countries in the
HIV-affected cluster sit furthest from the diagonal under every
combination of transform, regularisation, and component count we
tried.


