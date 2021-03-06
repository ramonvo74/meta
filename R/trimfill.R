#' Trim-and-fill method to adjust for bias in meta-analysis
#' 
#' @description
#' Trim-and-fill method for estimating and adjusting for the number
#' and outcomes of missing studies in a meta-analysis.
#' 
#' @aliases trimfill trimfill.meta trimfill.default
#' 
#' @param x An object of class \code{meta}, or estimated treatment
#'   effect in individual studies.
#' @param seTE Standard error of estimated treatment effect.
#' @param left A logical indicating whether studies are supposed to be
#'   missing on the left or right side of the funnel plot. If NULL,
#'   the linear regression test for funnel plot symmetry (i.e.,
#'   function \code{metabias(..., method="linreg")}) is used to
#'   determine whether studies are missing on the left or right side.
#' @param ma.fixed A logical indicating whether a fixed effect or
#'   random effects model is used to estimate the number of missing
#'   studies.
#' @param type A character indicating which method is used to estimate
#'   the number of missing studies. Either \code{"L"} or \code{"R"}.
#' @param n.iter.max Maximum number of iterations to estimate number
#'   of missing studies.
#' @param sm An optional character string indicating underlying
#'   summary measure, e.g., \code{"RD"}, \code{"RR"}, \code{"OR"},
#'   \code{"ASD"}, \code{"HR"}, \code{"MD"}, \code{"SMD"}, or
#'   \code{"ROM"}; ignored if \code{x} is of class \code{meta}.
#' @param studlab An optional vector with study labels; ignored if
#'   \code{x} is of class \code{meta}.
#' @param level The level used to calculate confidence intervals for
#'   individual studies. If existing, \code{x$level} is used as value
#'   for \code{level}; otherwise 0.95 is used.
#' @param level.comb The level used to calculate confidence interval
#'   for the pooled estimate. If existing, \code{x$level.comb} is used
#'   as value for \code{level.comb}; otherwise 0.95 is used.
#' @param comb.fixed A logical indicating whether a fixed effect
#'   meta-analysis should be conducted.
#' @param comb.random A logical indicating whether a random effects
#'   meta-analysis should be conducted.
#' @param hakn A logical indicating whether the method by Hartung and
#'   Knapp should be used to adjust test statistics and confidence
#'   intervals.
#' @param method.tau A character string indicating which method is
#'   used to estimate the between-study variance \eqn{\tau^2} and its
#'   square root \eqn{\tau}. Either \code{"DL"}, \code{"PM"},
#'   \code{"REML"}, \code{"ML"}, \code{"HS"}, \code{"SJ"},
#'   \code{"HE"}, or \code{"EB"}, can be abbreviated.
#' @param method.tau.ci A character string indicating which method is
#'   used to estimate the confidence interval of \eqn{\tau^2} and
#'   \eqn{\tau}. Either \code{"QP"}, \code{"BJ"}, or \code{"J"}, or
#'   \code{""}, can be abbreviated.
#' @param prediction A logical indicating whether a prediction
#'   interval should be printed.
#' @param level.predict The level used to calculate prediction
#'   interval for a new study.
#' @param backtransf A logical indicating whether results should be
#'   back transformed in printouts and plots. If
#'   \code{backtransf=TRUE}, results for \code{sm="OR"} are printed as
#'   odds ratios rather than log odds ratios and results for
#'   \code{sm="ZCOR"} are printed as correlations rather than Fisher's
#'   z transformed correlations, for example.
#' @param pscale A numeric giving scaling factor for printing of
#'   single event probabilities or risk differences, i.e. if argument
#'   \code{sm} is equal to \code{"PLOGIT"}, \code{"PLN"},
#'   \code{"PRAW"}, \code{"PAS"}, \code{"PFT"}, or \code{"RD"}.
#' @param irscale A numeric defining a scaling factor for printing of
#'   single incidence rates or incidence rate differences, i.e. if
#'   argument \code{sm} is equal to \code{"IR"}, \code{"IRLN"},
#'   \code{"IRS"}, \code{"IRFT"}, or \code{"IRD"}.
#' @param irunit A character specifying the time unit used to
#'   calculate rates, e.g. person-years.
#' @param silent A logical indicating whether basic information on
#'   iterations shown.
#' @param \dots other arguments
#'
#' @details
#' The trim-and-fill method (Duval, Tweedie 2000a, 2000b) can be used
#' for estimating and adjusting for the number and outcomes of missing
#' studies in a meta-analysis. The method relies on scrutiny of one
#' side of a funnel plot for asymmetry assumed due to publication
#' bias.
#' 
#' Three different methods have been proposed originally to estimate
#' the number of missing studies. Two of these methods (L- and
#' R-estimator) have been shown to perform better in simulations, and
#' are available in this R function (argument \code{type}).
#' 
#' A fixed effect or random effects model can be used to estimate the
#' number of missing studies (argument \code{ma.fixed}). Furthermore,
#' a fixed effect and/or random effects model can be used to summaries
#' study results (arguments \code{comb.fixed} and
#' \code{comb.random}). Simulation results (Peters et al. 2007)
#' indicate that the fixed-random model, i.e. using a fixed effect
#' model to estimate the number of missing studies and a random
#' effects model to summaries results, (i) performs better than the
#' fixed-fixed model, and (ii) performs no worse than and marginally
#' better in certain situations than the random-random
#' model. Accordingly, the fixed-random model is the default.
#' 
#' An empirical comparison of the trim-and-fill method and the Copas
#' selection model (Schwarzer et al. 2010) indicates that the
#' trim-and-fill method leads to excessively conservative inference in
#' practice. The Copas selection model is available in R package
#' \bold{metasens}.
#' 
#' The function \code{\link{metagen}} is called internally.
#' 
#' @return
#' An object of class \code{c("metagen", "meta", "trimfill")}. The
#' object is a list containing the following components:
#' \item{studlab, sm, left, ma.fixed, type, n.iter.max}{As defined
#'   above.}
#' \item{level, level.comb, level.predict}{As defined above.}
#' \item{comb.fixed, comb.random, prediction}{As defined above.}
#' \item{hakn, method.tau, method.tau.ci,}{As defined above.}
#' \item{TE, seTE}{Estimated treatment effect and standard error of
#'   individual studies.}
#' \item{lower, upper}{Lower and upper confidence interval limits for
#'   individual studies.}
#' \item{zval, pval}{z-value and p-value for test of treatment effect
#'   for individual studies.}
#' \item{w.fixed, w.random}{Weight of individual studies (in fixed and
#'   random effects model).} 
#' \item{TE.fixed, seTE.fixed}{Estimated overall treatment effect and
#'   standard error (fixed effect model).}
#' \item{TE.random, seTE.random}{Estimated overall treatment effect
#'   and standard error (random effects model).}
#' \item{seTE.predict}{Standard error utilised for prediction
#'   interval.}
#' \item{lower.predict, upper.predict}{Lower and upper limits of
#'   prediction interval.}
#' \item{k}{Number of studies combined in meta-analysis.}
#' \item{Q}{Heterogeneity statistic Q.}
#' \item{tau}{Square-root of between-study variance.}
#' \item{method}{Pooling method: \code{"Inverse"}.} 
#' \item{call}{Function call.}
#' \item{n.iter}{Actual number of iterations to estimate number of
#'   missing studies.}
#' \item{trimfill}{A logical vector indicating studies that have been
#'   added by trim-and-fill method.}
#' \item{df.hakn}{Degrees of freedom for test of treatment effect for
#'   Hartung-Knapp method (only if \code{hakn=TRUE}).}
#' \item{title}{Title of meta-analysis / systematic review.}
#' \item{complab}{Comparison label.} 
#' \item{outclab}{Outcome label.}
#' \item{label.e}{Label for experimental group.}
#' \item{label.c}{Label for control group.}
#' \item{label.left}{Graph label on left side of forest plot.}
#' \item{label.right}{Graph label on right side of forest plot.}
#' \item{k0}{Number of studies added by trim-and-fill.}
#' \item{n.e}{Number of observations in experimental group (only for
#'   object \code{x} of class \code{metabin} or \code{metacont}).}
#' \item{n.c}{Number of observations in control group (only for object
#'   \code{x} of class \code{metabin} or \code{metacont}).}
#' \item{event.e}{Number of events in experimental group (only for
#'   object \code{x} of class \code{metabin}).}
#' \item{event.c}{Number of events in control group (only for object
#'   \code{x} of class \code{metabin}).} 
#' \item{mean.e}{Estimated mean in experimental group (only for object
#'   \code{x} of class \code{metacont}).}
#' \item{sd.e}{Standard deviation in experimental group (only for
#'   object \code{x} of class \code{metacont}).}
#' \item{mean.c}{Estimated mean in control group (only for object
#'   \code{x} of class \code{metacont}).} 
#' \item{sd.c}{Standard deviation in control group (only for object
#'   \code{x} of class \code{metacont}).}
#' \item{n}{Number of observations (only for object \code{x} of class
#'   \code{metaprop}).}
#' \item{event}{Number of events (only for object \code{x} of class
#'   \code{metaprop}).}
#' \item{cor}{Corelation (only for object \code{x} of class
#'   \code{metacor}).} 
#' \item{class.x}{Main class of object \code{x} (e.g. 'metabin' or
#'   'metacont').}
#' \item{version}{Version of R package \bold{meta} used to create
#'   object.}
#' 
#' @author Guido Schwarzer \email{sc@@imbi.uni-freiburg.de}
#' 
#' @seealso \code{\link{metagen}}, \code{\link{metabias}},
#'   \code{\link{funnel}}
#' 
#' @references
#' Duval S & Tweedie R (2000a):
#' A nonparametric "Trim and Fill" method of accounting for
#' publication bias in meta-analysis.
#' \emph{Journal of the American Statistical Association},
#' \bold{95}, 89--98
#' 
#' Duval S & Tweedie R (2000b):
#' Trim and Fill: A simple funnel-plot-based method of testing and
#' adjusting for publication bias in meta-analysis.
#' \emph{Biometrics},
#' \bold{56}, 455--63
#' 
#' Peters JL, Sutton AJ, Jones DR, Abrams KR, Rushton L (2007):
#' Performance of the trim and fill method in the presence of
#' publication bias and between-study heterogeneity.
#' \emph{Statisics in Medicine},
#' \bold{10}, 4544--62
#' 
#' Schwarzer G, Carpenter J, Rücker G (2010):
#' Empirical evaluation suggests Copas selection model preferable to
#' trim-and-fill method for selection bias in meta-analysis
#' \emph{Journal of Clinical Epidemiology},
#' \bold{63}, 282--8
#' 
#' @examples
#' data(Fleiss93)
#' m1 <- metabin(event.e, n.e, event.c, n.c, data = Fleiss93, sm = "OR")
#' tf1 <- trimfill(m1)
#' summary(tf1)
#' funnel(tf1)
#' funnel(tf1, pch = ifelse(tf1$trimfill, 1, 16),
#'        level = 0.9, comb.random = FALSE)
#' #
#' # Use log odds ratios on x-axis
#' #
#' funnel(tf1, backtransf = FALSE)
#' funnel(tf1, pch = ifelse(tf1$trimfill, 1, 16),
#'        level = 0.9, comb.random = FALSE, backtransf = FALSE)
#' 
#' trimfill(m1$TE, m1$seTE, sm = m1$sm)
#' 
#' @rdname trimfill
#' @export trimfill


trimfill <- function(x, ...)
  UseMethod("trimfill")





#' @rdname trimfill
#' @method trimfill default
#' @export
#' @export trimfill.default


trimfill.default <- function(x, seTE, left = NULL, ma.fixed = TRUE,
                             type = "L", n.iter.max = 50,
                             sm = "", studlab = NULL,
                             level = 0.95, level.comb = level,
                             comb.fixed = FALSE, comb.random = TRUE,
                             hakn = FALSE,
                             method.tau = "DL",
                             method.tau.ci = if (method.tau == "DL") "J" else "QP",
                             prediction = FALSE, level.predict = level,
                             backtransf = TRUE, pscale = 1,
                             irscale = 1, irunit = "person-years",
                             silent = TRUE, ...) {
  
  
  ##
  ##
  ## (1) Check essential arguments
  ##
  ##
  k.All <- length(x)
  ##
  chknumeric(x)
  chknumeric(seTE)
  chknull(sm)
  ##
  fun <- "trimfill"
  chklength(seTE, k.All, fun)
  ##
  if (!is.null(studlab))
    chklength(studlab, k.All, fun)
  else
    studlab <- seq(along = x)
  ##
  if (is.null(sm)) sm <- ""
  
  
  ##
  ##
  ## (2) Do meta-analysis
  ##
  ##
  m <- metagen(x, seTE, studlab = studlab, sm = sm, method.tau.ci = "")
  
  
  ##
  ##
  ## (3) Run trim-and-fill method
  ##
  ##
  res <- trimfill(m, left = left, ma.fixed = ma.fixed,
                  type = type, n.iter.max = n.iter.max,
                  level = level, level.comb = level.comb,
                  comb.fixed = comb.fixed, comb.random = TRUE,
                  hakn = hakn,
                  method.tau = method.tau, method.tau.ci = method.tau.ci,
                  prediction = prediction, level.predict = level.predict,
                  backtransf = backtransf, pscale = pscale,
                  irscale = irscale, irunit = irunit,
                  silent = silent, ...)
  
  
  res
}





#' @rdname trimfill
#' @method trimfill meta
#' @export
#' @export trimfill.meta


trimfill.meta <- function(x, left = NULL, ma.fixed = TRUE,
                          type = "L", n.iter.max = 50,
                          level = x$level, level.comb = x$level.comb,
                          comb.fixed = FALSE, comb.random = TRUE,
                          hakn = x$hakn,
                          method.tau = x$method.tau,
                          method.tau.ci = x$method.tau.ci,
                          prediction = x$prediction,
                          level.predict = x$level.predict,
                          backtransf = x$backtransf, pscale = x$pscale,
                          irscale = x$irscale, irunit = x$irunit,
                          silent = TRUE, ...) {
  
  
  ##
  ##
  ## (1) Check for meta object and upgrade older meta objects
  ##
  ##
  chkclass(x, "meta")
  if (inherits(x, "metacum"))
    stop("This function is not usable for an object of class \"metacum\"")
  if (inherits(x, "metainf"))
    stop("This function is not usable for an object of class \"metainf\"")
  x <- updateversion(x)
  
  
  ##
  ## Check arguments
  ##
  type <- setchar(type, c("L", "R"))
  ##
  chklevel(level)
  chklevel(level.comb)
  chklevel(level.predict)
  ##
  chklogical(comb.fixed)
  chklogical(comb.random)
  ##
  chklogical(prediction)
  ##
  chklogical(backtransf)
  sm <- x$sm
  if (!is.prop(sm))
    pscale <- 1
  chknumeric(pscale, single = TRUE)
  if (!backtransf & pscale != 1) {
    warning("Argument 'pscale' set to 1 as argument 'backtransf' is FALSE.")
    pscale <- 1
  }
  if (!is.rate(sm))
    irscale <- 1
  chknumeric(irscale, single = TRUE)
  if (!backtransf & irscale != 1) {
    warning("Argument 'irscale' set to 1 as argument 'backtransf' is FALSE.")
    irscale <- 1
  }
  ##
  chklogical(silent)
  
  
  TE <- x$TE
  seTE <- x$seTE
  studlab <- x$studlab
  ##
  n.e <- x$n.e
  n.c <- x$n.c
  n <- x$n
  ##
  event.e <- x$event.e
  event.c <- x$event.c
  event <- x$event
  ##
  time.e <- x$time.e
  time.c <- x$time.c
  time <- x$time
  ##
  cor <- x$cor
  ##
  mean.e <- x$mean.e
  mean.c <- x$mean.c
  ##
  sd.e <- x$sd.e
  sd.c <- x$sd.c
  ##
  transf.null.effect <- null.effect <- x$null.effect
  ##
  if (sm %in% c("PFT", "PAS"))
    transf.null.effect <- asin(sqrt(null.effect))
  else if (is.log.effect(sm))
    transf.null.effect <- log(null.effect)
  else if (sm == c("PLOGIT"))
    transf.null.effect <- log(null.effect / (1 - null.effect))
  else if (sm %in% c("IRS", "IRFT"))
    transf.null.effect <- sqrt(null.effect)
  else if (sm == "ZCOR")
    transf.null.effect <- 0.5 * log((1 + null.effect) / (1 - null.effect))
  
  
  if(length(TE) != length(seTE))
    stop("length of argument TE and seTE must be equal")
  ##
  if(length(TE) != length(studlab))
    stop("length of argument TE and studlab must be equal")
  ##
  ## Exclude studies from meta-analysis
  ##
  if (!is.null(x$exclude)) {
    exclude <- x$exclude
    nomiss <- !is.na(TE) & !is.na(seTE)
    miss <- !nomiss & !exclude
    ##
    sel <- nomiss & !exclude
  }
  else {
    exclude <- exclude.na <- NULL
    nomiss <- !is.na(TE) & !is.na(seTE)
    miss <- !nomiss
    ##
    sel <- nomiss
  }
  ##
  if (any(miss))
    warning(paste(sum(miss),
                  "observation(s) dropped due to missing values"))
  
  
  TE <- TE[sel]
  seTE <- seTE[sel]
  studlab <- studlab[sel]
  ##
  if (!is.null(n.e))
    n.e <- n.e[sel]
  if (!is.null(n.c))
    n.c <- n.c[sel]
  if (!is.null(n))
    n <- n[sel]
  ##
  if (!is.null(event.e))
    event.e <- event.e[sel]
  if (!is.null(event.c))
    event.c <- event.c[sel]
  if (!is.null(event))
    event <- event[sel]
  ##
  if (!is.null(time.e))
    time.e <- time.e[sel]
  if (!is.null(time.c))
    time.c <- time.c[sel]
  if (!is.null(time))
    time <- time[sel]
  ##
  if (!is.null(cor))
    cor <- cor[sel]
  ##
  if (!is.null(mean.e))
    mean.e <- mean.e[sel]
  if (!is.null(mean.c))
    mean.c <- mean.c[sel]
  ##
  if (!is.null(sd.e))
    sd.e <- sd.e[sel]
  if (!is.null(sd.c))
    sd.c <- sd.c[sel]
  ##
  k <- length(TE)
  ##
  if (k <= 2) {
    warning("Minimal number of three studies for trim-and-fill method")
    return(invisible(NULL))
  }
  
  
  if (is.null(left))
    left <- as.logical(sign(metabias(TE, seTE, method = "linreg", k.min = 3)$estimate[1]) == 1)
  ##
  if (!left) TE <- -TE
  ##
  ord <- order(TE)
  TE <- TE[ord]
  seTE <- seTE[ord]
  studlab <- studlab[ord]
  ##
  if (!is.null(n.e))
    n.e <- n.e[ord]
  if (!is.null(n.c))
    n.c <- n.c[ord]
  if (!is.null(n))
    n <- n[ord]
  ##
  if (!is.null(event.e))
    event.e <- event.e[ord]
  if (!is.null(event.c))
    event.c <- event.c[ord]
  if (!is.null(event))
    event <- event[ord]
  ##
  if (!is.null(time.e))
    time.e <- time.e[ord]
  if (!is.null(time.c))
    time.c <- time.c[ord]
  if (!is.null(time))
    time <- time[ord]
  ##
  if (!is.null(cor))
    cor <- cor[ord]
  ##
  if (!is.null(mean.e))
    mean.e <- mean.e[ord]
  if (!is.null(mean.c))
    mean.c <- mean.c[ord]
  ##
  if (!is.null(sd.e))
    sd.e <- sd.e[ord]
  if (!is.null(sd.c))
    sd.c <- sd.c[ord]
  
  
  if (ma.fixed)
    TE.sum <- metagen(TE, seTE)$TE.fixed
  else
    TE.sum <- metagen(TE, seTE, method.tau = method.tau)$TE.random
  
  
  if (k == 1) {
    n.iter <- 0
    k0 <- -9
  }
  else {
    n.iter  <-  0
    k0.last <- -1
    k0      <-  0
    ##
    while (k0.last != k0 & k0 <= (k - 1) & n.iter < n.iter.max) {
      ##
      n.iter <- n.iter + 1
      ##
      k0.last <- k0
      ##
      sel <- 1:(k - k0)
      ##
      if (ma.fixed)
        TE.sum <- metagen(TE[sel], seTE[sel])$TE.fixed
      else
        TE.sum <- metagen(TE[sel], seTE[sel],
                          method.tau = method.tau)$TE.random
      ##
      trim1 <- estimate.missing(TE, TE.sum, type)
      ##
      if (!silent) {
        cat(paste0("n.iter = ", n.iter, "\n"))
        if (type == "L")
          cat(paste0("L0 = ", round(trim1$res0, 2), "\n\n"))
        if (type == "R")
          cat(paste0("R0 = ", round(trim1$res0 + 0.5, 2), "\n\n"))
      }
      ##
      k0 <- trim1$res0.plus
    }
  }
  
  
  if (k0 > (k - 1)) k0 <- k - 1
  ##
  if (k0 > 0) {
    TE.star   <- 2 * TE.sum - TE[(k - k0 + 1):k]
    seTE.star <- seTE[(k - k0 + 1):k]
    ##
    trimfill  <- c(rep(FALSE, length(TE)),
                   rep(TRUE, length(TE.star)))
    ##
    TE      <- c(TE[order(ord)], TE.star)
    seTE    <- c(seTE[order(ord)], seTE.star)
    studlab <- c(studlab[order(ord)],
                 paste("Filled:", studlab[(k - k0 + 1):k]))
    ##
    if (!is.null(n.e))
      n.e <- c(n.e[order(ord)], n.e[(k - k0 + 1):k])
    if (!is.null(n.c))
      n.c <- c(n.c[order(ord)], n.c[(k - k0 + 1):k])
    if (!is.null(n))
      n <- c(n[order(ord)], n[(k - k0 + 1):k])
    ##
    if (!is.null(event.e))
      event.e <- c(event.e[order(ord)], event.e[(k - k0 + 1):k])
    if (!is.null(event.c))
      event.c <- c(event.c[order(ord)], event.c[(k - k0 + 1):k])
    if (!is.null(event))
      event <- c(event[order(ord)], event[(k - k0 + 1):k])
    ##
    if (!is.null(time.e))
      time.e <- c(time.e[order(ord)], time.e[(k - k0 + 1):k])
    if (!is.null(time.c))
      time.c <- c(time.c[order(ord)], time.c[(k - k0 + 1):k])
    if (!is.null(time))
      time <- c(time[order(ord)], time[(k - k0 + 1):k])
    ##
    if (!is.null(cor))
      cor <- c(cor[order(ord)], cor[(k - k0 + 1):k])
    ##
    if (!is.null(mean.e))
      mean.e <- c(mean.e[order(ord)], mean.e[(k - k0 + 1):k])
    if (!is.null(mean.c))
      mean.c <- c(mean.c[order(ord)], mean.c[(k - k0 + 1):k])
    ##
    if (!is.null(sd.e))
      sd.e <- c(sd.e[order(ord)], sd.e[(k - k0 + 1):k])
    if (!is.null(sd.c))
      sd.c <- c(sd.c[order(ord)], sd.c[(k - k0 + 1):k])
  }
  else {
    TE.star   <- NA
    seTE.star <- NA
    trimfill  <- rep(FALSE, length(TE))
    TE        <- TE[order(ord)]
    seTE      <- seTE[order(ord)]
    studlab   <- studlab[order(ord)]
    ##
    if (!is.null(n.e))
      n.e <- n.e[order(ord)]
    if (!is.null(n.c))
      n.c <- n.c[order(ord)]
    if (!is.null(n))
      n <- n[order(ord)]
    ##
    if (!is.null(event.e))
      event.e <- event.e[order(ord)]
    if (!is.null(event.c))
      event.c <- event.c[order(ord)]
    if (!is.null(event))
      event <- event[order(ord)]
    ##
    if (!is.null(time.e))
      time.e <- time.e[order(ord)]
    if (!is.null(time.c))
      time.c <- time.c[order(ord)]
    if (!is.null(time))
      time <- time[order(ord)]
    ##
    if (!is.null(cor))
      cor <- cor[order(ord)]
    ##
    if (!is.null(mean.e))
      mean.e <- mean.e[order(ord)]
    if (!is.null(mean.c))
      mean.c <- mean.c[order(ord)]
    ##
    if (!is.null(sd.e))
      sd.e <- sd.e[order(ord)]
    if (!is.null(sd.c))
      sd.c <- sd.c[order(ord)]
  }
  
  
  if (!left)
    m <- metagen(-TE, seTE, studlab = studlab,
                 level = level, level.comb = level.comb,
                 hakn = hakn,
                 method.tau = method.tau, method.tau.ci = method.tau.ci,
                 prediction = prediction, level.predict = level.predict,
                 null.effect = transf.null.effect)
  else
    m <- metagen(TE, seTE, studlab = studlab,
                 level = level, level.comb = level.comb,
                 hakn = hakn,
                 method.tau = method.tau, method.tau.ci = method.tau.ci,
                 prediction = prediction, level.predict = level.predict,
                 null.effect = transf.null.effect)
  
  
  ##
  ## Calculate H, I-Squared, and Rb
  ##
  Hres  <- calcH(m$Q, m$df.Q, level.comb)
  I2res <- isquared(m$Q, m$df.Q, level.comb)
  Rbres <- with(m,
                Rb(seTE[!is.na(seTE)], seTE.random, tau^2, Q, df.Q, level.comb))
  
  
  ##
  ## Number of filled studies
  ##
  k0 <- sum(trimfill)
  
  
  if (!is.null(exclude) && any(exclude)) {
    exclude.na <- c(exclude, rep(NA, k0))
    exclude <- c(exclude, rep(FALSE, k0))
    TE.all <- seTE.all <- studlab.all <- rep(NA, length(exclude))
    ##
    TE.all[exclude] <- x$TE[exclude]
    TE.all[!exclude] <- TE
    ##
    seTE.all[exclude] <- x$seTE[exclude]
    seTE.all[!exclude] <- seTE
    ##
    studlab.all[exclude] <- x$studlab[exclude]
    studlab.all[!exclude] <- studlab
    ##
    if (!left)
      m.all <- metagen(-TE.all, seTE.all, studlab = studlab.all,
                       exclude = exclude, level = level,
                       null.effect = transf.null.effect)
    else
      m.all <- metagen(TE.all, seTE.all, studlab = studlab.all,
                       exclude = exclude, level = level,
                       null.effect = transf.null.effect)
  }
  else
    m.all <- m
  
  
  res <- list(studlab = m.all$studlab,
              TE = m.all$TE, seTE = m.all$seTE,
              lower = m.all$lower, upper = m.all$upper,
              zval = m.all$zval, pval = m.all$pval,
              w.fixed = m.all$w.fixed, w.random = m.all$w.random,
              exclude = exclude.na,
              ##
              TE.fixed = m$TE.fixed, seTE.fixed = m$seTE.fixed,
              lower.fixed = m$lower.fixed, upper.fixed = m$upper.fixed,
              zval.fixed = m$zval.fixed, pval.fixed = m$pval.fixed,
              ##
              TE.random = m$TE.random, seTE.random = m$seTE.random,
              lower.random = m$lower.random, upper.random = m$upper.random,
              zval.random = m$zval.random, pval.random = m$pval.random,
              ##
              seTE.predict = m$seTE.predict,
              lower.predict = m$lower.predict,
              upper.predict = m$upper.predict,
              level.predict = level.predict,
              ##
              k = m$k, Q = m$Q, df.Q = m$df.Q, pval.Q = m$pval.Q,
              tau2 = m$tau2,
              lower.tau2 = m$lower.tau2, upper.tau2 = m$upper.tau2,
              se.tau2 = m$se.tau2,
              tau = m$tau, lower.tau = m$lower.tau, upper.tau = m$upper.tau,
              method.tau.ci = m$method.tau.ci,
              sign.lower.tau = m$sign.lower.tau,
              sign.upper.tau = m$sign.upper.tau,
              ##
              H = Hres$TE,
              lower.H = Hres$lower,
              upper.H = Hres$upper,
              ##
              I2 = I2res$TE,
              lower.I2 = I2res$lower,
              upper.I2 = I2res$upper,
              ##
              Rb = Rbres$TE,
              lower.Rb = Rbres$lower,
              upper.Rb = Rbres$upper,
              ##
              sm = sm,
              method = m$method,
              ##
              call = match.call(),
              left = left,
              ma.fixed = ma.fixed,
              type = type,
              n.iter.max = n.iter.max,
              n.iter = n.iter,
              trimfill = trimfill,
              hakn = m$hakn,
              df.hakn = m$df.hakn,
              method.tau = m$method.tau,
              prediction = prediction,
              title = x$title,
              complab = x$complab,
              outclab = x$outclab,
              label.e = x$label.e,
              label.c = x$label.c,
              label.left = x$label.left,
              label.right = x$label.right,
              k0 = k0,
              level = level, level.comb = level.comb,
              comb.fixed = comb.fixed,
              comb.random = comb.random,
              ##
              n.e = n.e,
              n.c = n.c,
              n = n,
              ##
              event.e = event.e,
              event.c = event.c,
              event = event,
              ##
              time.e = time.e,
              time.c = time.c,
              time = time,
              ##
              cor = cor,
              ##
              mean.e = mean.e,
              mean.c = mean.c,
              ##
              sd.e = sd.e,
              sd.c = sd.c,
              ##
              null.effect = x$null.effect,
              ##
              class.x = class(x)[1]
              )
  
  res$backtransf <- backtransf
  res$pscale <- pscale
  res$irscale <- irscale
  res$irunit <- irunit
  
  res$version <- packageDescription("meta")$Version
  
  class(res) <- c("metagen", "meta", "trimfill")
  ##
  res
}
